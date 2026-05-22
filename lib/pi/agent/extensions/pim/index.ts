/**
 * /pim — Pi Modes
 *
 * Toggle feature flags that append to the system prompt and gate fuggit_*
 * tool calls. State has three levels per feature:
 *   [ ] off         — no effect
 *   [s] session_on  — active this session only
 *   [D] default     — active & persisted to ~/.pi/agent/pim/defaults.json
 *
 * Feature families (e.g. commit_mode) are mutually exclusive.
 *
 * Commands:
 *   /pim          open toggle TUI
 *   /pim show     print current state
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import {
  FEATURES,
  FUGGIT_ALLOWED_UNDER_NONE,
  activeCommitMode,
  buildPromptAppend,
  isFuggitTool,
} from "./features.js";
import { FeatureStore } from "./state.js";
import { openPimMenu, summarize } from "./ui.js";

export default function pimExtension(pi: ExtensionAPI) {
  const store = new FeatureStore();

  // ── /pim command ─────────────────────────────────────────────
  pi.registerCommand("pim", {
    description: "Toggle pim feature flags (system-prompt + tool gating)",
    handler: async (args, ctx) => {
      const sub = args?.trim().toLowerCase();
      if (sub === "show" || sub === "status") {
        ctx.ui.notify(summarize(store), "info");
        return;
      }
      if (sub === "help") {
        ctx.ui.notify(
          [
            "/pim          open toggle TUI",
            "/pim show     print current state",
            "/pim help     show this help",
            "",
            "Features:",
            ...FEATURES.map((f) => `  ${f.label} — ${f.description}`),
          ].join("\n"),
          "info",
        );
        return;
      }
      // Always re-read disk before opening — external edits land cleanly.
      store.reload();
      await openPimMenu(ctx, store);
    },
  });

  // ── system prompt injection ──────────────────────────────────
  pi.on("before_agent_start", async (event) => {
    const extra = buildPromptAppend(store.activeSet());
    if (!extra) return;
    return { systemPrompt: `${event.systemPrompt}\n\n${extra}` };
  });

  // ── tool_call gating (fuggit interactions) ───────────────────
  pi.on("tool_call", async (event, ctx) => {
    if (!isFuggitTool(event.toolName)) return;

    const mode = activeCommitMode(store.activeSet());
    if (!mode || mode === "commit_mode:auto") return;

    if (mode === "commit_mode:none") {
      if (FUGGIT_ALLOWED_UNDER_NONE.has(event.toolName)) return;
      const reason =
        "pim commit_mode:none — no commits or stages permitted. Leave all work dirty.";
      if (ctx.hasUI) ctx.ui.notify(`Blocked ${event.toolName}: ${reason}`, "warning");
      return { block: true, reason };
    }

    if (mode === "commit_mode:append" && event.toolName === "fuggit_commit") {
      const input = event.input as { amend?: boolean } | undefined;
      if (input?.amend === true) {
        const reason =
          "pim commit_mode:append — `--amend` not permitted. Create a new commit instead.";
        if (ctx.hasUI) ctx.ui.notify(`Blocked fuggit_commit amend: ${reason}`, "warning");
        return { block: true, reason };
      }
    }
  });
}
