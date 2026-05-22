/**
 * Feature registry for /pim.
 *
 * Each feature has:
 *   - id: stable identifier used in the defaults file & TUI
 *   - family: features in the same family are mutually exclusive (radio).
 *             Activating one auto-deactivates the others in that family.
 *   - label / description: shown in TUI
 *   - systemPrompt: appended to system prompt when active
 *   - familyDefault: if true and no member of family is active on first run,
 *                    this feature is seeded as the default.
 */

export interface Feature {
  id: string;
  family?: string;
  label: string;
  description: string;
  systemPrompt: string;
  familyDefault?: boolean;
}

export const FEATURES: Feature[] = [
  {
    id: "commit_mode:auto",
    family: "commit_mode",
    label: "commit_mode:auto",
    description: "use best judgement — append or amend as needed",
    systemPrompt:
      "When committing, use your best judgement as to whether we should append or amend commits.",
    familyDefault: true,
  },
  {
    id: "commit_mode:append",
    family: "commit_mode",
    label: "commit_mode:append",
    description: "append-only — block git commit --amend",
    systemPrompt:
      "All commits must be appended. No `git commit --amend` permitted.",
  },
  {
    id: "commit_mode:none",
    family: "commit_mode",
    label: "commit_mode:none",
    description: "no commits or stages — leave all work dirty",
    systemPrompt:
      "No commits or stages are permitted. Leave all work dirty.",
  },
];

/** Active commit_mode feature id (or undefined when none in family active). */
export function activeCommitMode(active: ReadonlySet<string>): string | undefined {
  if (active.has("commit_mode:none")) return "commit_mode:none";
  if (active.has("commit_mode:append")) return "commit_mode:append";
  if (active.has("commit_mode:auto")) return "commit_mode:auto";
  return undefined;
}

/** All fuggit_* tools start with this prefix. */
export function isFuggitTool(name: string): boolean {
  return name.startsWith("fuggit_");
}

/** fuggit tools allowed even under commit_mode:none (read-only inspection). */
export const FUGGIT_ALLOWED_UNDER_NONE: ReadonlySet<string> = new Set([
  "fuggit_stack_log",
]);

/** Get the system prompt suffix from active features. */
export function buildPromptAppend(active: ReadonlySet<string>): string {
  const parts: string[] = [];
  for (const feature of FEATURES) {
    if (active.has(feature.id)) parts.push(feature.systemPrompt);
  }
  return parts.join("\n");
}
