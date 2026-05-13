/**
 * log-git-attempts
 *
 * Observation-only sibling to the `prefer-graphite` extension
 * (https://github.com/shopify-playground/shop-pi-fy/tree/main/extensions/prefer-graphite).
 *
 * Goal: gather data on how agents are *trying* to use git so we can decide
 * which raw git commands are safe to allow through (e.g. `git add` is fine
 * in a Graphite-tracked repo; `git push` is not).
 *
 * What it does:
 *   - Listens to bash tool_call events. If the command contains a `git` or `gt`
 *     invocation it writes a JSON line to a per-session log file.
 *   - Listens to bash tool_result events to record the outcome (passed through
 *     vs. blocked by prefer-graphite) for the same toolCallId.
 *   - Listens to assistant message_end events and keeps the most recent text
 *     snippet around as best-effort "consternation" context — the agent's own
 *     words leading up to the command. Optional, may be empty.
 *
 * Logs land at: ~/.agents/var/log/prefer-graphite/<timestamp>-<session>.log
 * Each line is a JSON record. We do NOT block, modify, or rewrite anything.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType, isBashToolResult } from "@mariozechner/pi-coding-agent";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

const LOG_DIR = path.join(os.homedir(), ".agents", "var", "log", "prefer-graphite");

/** Max chars of agent assistant text to attach as "consternation" context. */
const CONSTERNATION_MAX_CHARS = 600;

/** Max chars of blocked-reason snippet to record (prefer-graphite messages are short). */
const REASON_MAX_CHARS = 400;

// ---------------------------------------------------------------------------
// Sub-command detection
//
// Mirrors prefer-graphite's general approach but stripped to the minimum we
// need: split on shell operators, ignore quoted/heredoc content, then look at
// the first token of each sub-command.
// ---------------------------------------------------------------------------

function stripHeredocBodies(command: string): string {
  return command.replace(
    /<<\s*['"]?(\w+)['"]?\n[\s\S]*?\n[ \t]*\1[ \t]*(\n|$)/gm,
    (_m, delim) => `<< '${delim}'\n`,
  );
}

function splitSubCommands(command: string): string[] {
  const out: string[] = [];
  let cur = "";
  let inSingle = false;
  let inDouble = false;
  let i = 0;
  while (i < command.length) {
    const ch = command[i];
    if (ch === "\\" && !inSingle && i + 1 < command.length) {
      cur += ch + command[i + 1];
      i += 2;
      continue;
    }
    if (ch === "'" && !inDouble) { inSingle = !inSingle; cur += ch; i++; continue; }
    if (ch === '"' && !inSingle) { inDouble = !inDouble; cur += ch; i++; continue; }
    if (!inSingle && !inDouble) {
      if ((ch === "&" && command[i + 1] === "&") || (ch === "|" && command[i + 1] === "|")) {
        out.push(cur); cur = ""; i += 2; continue;
      }
      if (ch === ";" || ch === "|" || ch === "\n") {
        out.push(cur); cur = ""; i++; continue;
      }
    }
    cur += ch;
    i++;
  }
  out.push(cur);
  return out.map((s) => s.trim()).filter(Boolean);
}

/**
 * Strip a leading prefix-command (sudo, env, nice, time, ...) so we can
 * inspect what's actually being invoked. Best-effort — we just skip simple
 * prefixes whose flags we recognise generically (FOO=bar, -x, --flag=val).
 */
const PREFIX_COMMANDS = new Set(["sudo", "env", "nice", "time", "command", "exec", "stdbuf"]);

/** Shell dispatchers whose final positional argument is itself a shell command. */
const SHELL_DISPATCHERS = new Set(["bash", "sh", "zsh", "dash", "ash"]);

function stripPrefixWords(tokens: string[]): string[] {
  let i = 0;
  // skip VAR=value assignments (env-style)
  while (i < tokens.length && /^[A-Za-z_][A-Za-z0-9_]*=/.test(tokens[i])) i++;
  // skip recognised prefix commands and any of their option-looking args
  while (i < tokens.length && PREFIX_COMMANDS.has(tokens[i])) {
    i++;
    while (i < tokens.length && tokens[i].startsWith("-")) i++;
    while (i < tokens.length && /^[A-Za-z_][A-Za-z0-9_]*=/.test(tokens[i])) i++;
  }
  return tokens.slice(i);
}

/** Crude tokeniser that respects quotes; not a full shell parser. */
function tokenise(sub: string): string[] {
  const tokens: string[] = [];
  let cur = "";
  let inSingle = false;
  let inDouble = false;
  for (let i = 0; i < sub.length; i++) {
    const ch = sub[i];
    if (ch === "\\" && !inSingle && i + 1 < sub.length) {
      cur += sub[i + 1]; i++; continue;
    }
    if (ch === "'" && !inDouble) { inSingle = !inSingle; continue; }
    if (ch === '"' && !inSingle) { inDouble = !inDouble; continue; }
    if (!inSingle && !inDouble && /\s/.test(ch)) {
      if (cur) { tokens.push(cur); cur = ""; }
      continue;
    }
    cur += ch;
  }
  if (cur) tokens.push(cur);
  return tokens;
}

interface DetectedInvocation {
  /** "git" or "gt". */
  binary: "git" | "gt";
  /** Sub-command verb if obvious (e.g. "add", "push", "submit"). May be undefined. */
  verb: string | undefined;
  /** First ~10 tokens of the invocation, joined — enough for analysis. */
  invocation: string;
}

/**
 * Pull the inner command out of `bash -c '<inner>'` / `eval '<inner>'`.
 * Returns undefined when `tokens` is not a shell-dispatcher invocation.
 */
function extractDispatchedInner(tokens: string[]): string | undefined {
  if (tokens.length === 0) return undefined;
  const head = tokens[0];
  if (head === "eval") {
    return tokens.slice(1).join(" ");
  }
  if (SHELL_DISPATCHERS.has(head)) {
    // Find -c and grab the next token. Anything after that is positional args
    // we can drop ($0, $1, ...) for purposes of intent detection.
    const idx = tokens.indexOf("-c");
    if (idx !== -1 && tokens[idx + 1]) return tokens[idx + 1];
  }
  return undefined;
}

function detectInvocations(rawCommand: string, depth = 0): DetectedInvocation[] {
  // Guard against pathological nesting like `bash -c "bash -c '...'"`.
  if (depth > 3) return [];

  const command = stripHeredocBodies(rawCommand);
  // Cheap reject: avoid all the splitting work when there's no candidate at all.
  if (!/\b(git|gt)\b/.test(command)) return [];

  const found: DetectedInvocation[] = [];
  for (const sub of splitSubCommands(command)) {
    const tokens = stripPrefixWords(tokenise(sub));
    if (tokens.length === 0) continue;

    const inner = extractDispatchedInner(tokens);
    if (inner !== undefined) {
      // Recurse into the dispatched command — that's the real intent.
      found.push(...detectInvocations(inner, depth + 1));
      continue;
    }

    const head = tokens[0];
    if (head !== "git" && head !== "gt") continue;
    const verb = tokens[1] && !tokens[1].startsWith("-") ? tokens[1] : undefined;
    found.push({
      binary: head,
      verb,
      invocation: tokens.slice(0, 10).join(" "),
    });
  }
  return found;
}

// ---------------------------------------------------------------------------
// Log file management
// ---------------------------------------------------------------------------

interface LogState {
  path: string;
  stream: fs.WriteStream;
}

let logState: LogState | undefined;

function ensureLogFile(sessionId: string): LogState {
  if (logState) return logState;

  fs.mkdirSync(LOG_DIR, { recursive: true });

  // ISO-ish timestamp with characters safe for filenames.
  const ts = new Date().toISOString().replace(/[:.]/g, "-");
  // Process pid breaks ties if two sessions ever share an id (shouldn't, but cheap insurance).
  const safeSession = (sessionId || "unknown").replace(/[^A-Za-z0-9_-]/g, "_");
  const fname = `${ts}-${safeSession}-${process.pid}.log`;
  const fullPath = path.join(LOG_DIR, fname);

  const stream = fs.createWriteStream(fullPath, { flags: "a" });
  // Best-effort: don't crash the agent if logging breaks.
  stream.on("error", () => { /* swallow */ });

  logState = { path: fullPath, stream };
  return logState;
}

function writeRecord(sessionId: string, record: Record<string, unknown>): void {
  try {
    const state = ensureLogFile(sessionId);
    state.stream.write(JSON.stringify(record) + "\n");
  } catch {
    // Logging is best-effort; never break the agent.
  }
}

// ---------------------------------------------------------------------------
// Cross-event state
// ---------------------------------------------------------------------------

/**
 * Most recent snippet of assistant prose. Captured at message_end and attached
 * to the next git/gt tool_call as best-effort "consternation" context.
 *
 * It's a single value (not a queue) on purpose: we only care about what the
 * agent was just talking about right before it tried the command.
 */
let lastAssistantSnippet: string | undefined;

/** toolCallId -> minimal record we logged at call time, so we can correlate the result. */
const pendingByToolCallId = new Map<string, { command: string; invocations: DetectedInvocation[] }>();

/** Cap the pending map so a long-running session can't leak memory. */
const MAX_PENDING = 256;

function rememberPending(toolCallId: string, command: string, invocations: DetectedInvocation[]): void {
  if (pendingByToolCallId.size >= MAX_PENDING) {
    // Drop oldest — Map iteration order is insertion order.
    const firstKey = pendingByToolCallId.keys().next().value;
    if (firstKey !== undefined) pendingByToolCallId.delete(firstKey);
  }
  pendingByToolCallId.set(toolCallId, { command, invocations });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function extractAssistantText(message: any): string {
  const content = message?.content;
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  const parts: string[] = [];
  for (const block of content) {
    if (block && typeof block === "object" && block.type === "text" && typeof block.text === "string") {
      parts.push(block.text);
    }
  }
  return parts.join("\n").trim();
}

function truncate(s: string, max: number): string {
  if (s.length <= max) return s;
  return s.slice(0, max) + "…";
}

function extractResultText(content: unknown): string {
  if (!Array.isArray(content)) return "";
  const parts: string[] = [];
  for (const block of content as any[]) {
    if (block && typeof block === "object" && block.type === "text" && typeof block.text === "string") {
      parts.push(block.text);
    }
  }
  return parts.join("\n").trim();
}

// ---------------------------------------------------------------------------
// Extension entry
// ---------------------------------------------------------------------------

export default function (pi: ExtensionAPI) {
  pi.on("message_end", async (event) => {
    const msg: any = event.message;
    if (msg?.role !== "assistant") return;
    const text = extractAssistantText(msg);
    if (text) lastAssistantSnippet = truncate(text, CONSTERNATION_MAX_CHARS);
  });

  pi.on("tool_call", async (event, ctx) => {
    if (!isToolCallEventType("bash", event)) return;
    const command = event.input?.command ?? "";
    if (!command) return;

    const invocations = detectInvocations(command);
    if (invocations.length === 0) return;

    const sessionId = ctx.sessionManager?.getSessionId?.() ?? "unknown";

    writeRecord(sessionId, {
      ts: new Date().toISOString(),
      session: sessionId,
      cwd: ctx.cwd,
      phase: "call",
      toolCallId: event.toolCallId,
      command,
      invocations,
      consternation: lastAssistantSnippet,
    });

    rememberPending(event.toolCallId, command, invocations);

    // Don't reuse the same snippet for unrelated subsequent calls.
    lastAssistantSnippet = undefined;

    // Observation only — never block.
    return undefined;
  });

  pi.on("tool_result", async (event, ctx) => {
    if (!isBashToolResult(event)) return;

    const pending = pendingByToolCallId.get(event.toolCallId);
    if (!pending) return;
    pendingByToolCallId.delete(event.toolCallId);

    const sessionId = ctx.sessionManager?.getSessionId?.() ?? "unknown";
    const reasonText = truncate(extractResultText(event.content), REASON_MAX_CHARS);

    // Result rows omit `session` and `invocations` — both are present on the
    // matching call row and joinable via toolCallId.
    writeRecord(sessionId, {
      ts: new Date().toISOString(),
      phase: "result",
      toolCallId: event.toolCallId,
      isError: event.isError,
      // When prefer-graphite blocks, the reason text starts with "This repo uses Graphite".
      // Recording isError + the snippet lets us classify outcomes downstream without
      // hardcoding that string here.
      resultSnippet: reasonText,
    });

    return undefined;
  });
}
