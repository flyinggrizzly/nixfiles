/**
 * pim feature state store.
 *
 * Per-feature state ∈ { off, session_on, default }.
 *   - off          [ ]  inactive
 *   - session_on   [s]  active for this session only — not persisted
 *   - default      [D]  active & persisted to ~/.pi/agent/pim/defaults.json
 *
 * Family invariant: at most one feature per family is non-off. Activating a
 * row force-deactivates its siblings.
 */

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import { FEATURES, type Feature } from "./features.js";

export type FeatureState = "off" | "session_on" | "default";

const DEFAULTS_FILE = join(homedir(), ".pi", "agent", "pim", "defaults.json");

interface DefaultsFile {
  /** Feature ids whose state is "default" (persisted across sessions). */
  defaults: string[];
}

export class FeatureStore {
  private state = new Map<string, FeatureState>();
  private featuresById = new Map<string, Feature>();

  constructor() {
    for (const f of FEATURES) {
      this.featuresById.set(f.id, f);
      this.state.set(f.id, "off");
    }
    this.loadFromDisk();
    this.seedFamilyDefaults();
  }

  /** Re-read disk defaults — call at session_start or before_agent_start. */
  reload(): void {
    for (const id of this.featuresById.keys()) this.state.set(id, "off");
    this.loadFromDisk();
    this.seedFamilyDefaults();
  }

  get(id: string): FeatureState {
    return this.state.get(id) ?? "off";
  }

  /** True when the feature should contribute its prompt/tool gating. */
  isActive(id: string): boolean {
    const s = this.get(id);
    return s === "session_on" || s === "default";
  }

  /** Set of all currently active feature ids. */
  activeSet(): Set<string> {
    const out = new Set<string>();
    for (const [id, s] of this.state) {
      if (s === "session_on" || s === "default") out.add(id);
    }
    return out;
  }

  /** Set a feature's state, enforcing family radio invariant & persisting if needed. */
  set(id: string, value: FeatureState): void {
    const feature = this.featuresById.get(id);
    if (!feature) return;

    this.state.set(id, value);

    if ((value === "session_on" || value === "default") && feature.family) {
      // Radio: activating one family member deactivates its siblings.
      for (const other of FEATURES) {
        if (other.id !== id && other.family === feature.family) {
          this.state.set(other.id, "off");
        }
      }
    } else if (value === "off" && feature.family) {
      // Auto-promote familyDefault when no member of the family is active.
      // Skip if the row we just turned off IS the familyDefault (avoid loop).
      const siblings = FEATURES.filter((f) => f.family === feature.family);
      const anyActive = siblings.some((s) => this.isActive(s.id));
      if (!anyActive) {
        const fallback = siblings.find((s) => s.familyDefault && s.id !== id);
        if (fallback) this.state.set(fallback.id, "session_on");
      }
    }

    this.persist();
  }

  /** Cycle one row: off → session_on → default → off. */
  cycle(id: string): FeatureState {
    const cur = this.get(id);
    const next: FeatureState =
      cur === "off" ? "session_on" : cur === "session_on" ? "default" : "off";
    this.set(id, next);
    return next;
  }

  // ── disk i/o ─────────────────────────────────────────────────────

  private loadFromDisk(): void {
    let parsed: DefaultsFile | undefined;
    try {
      const text = readFileSync(DEFAULTS_FILE, "utf8");
      parsed = JSON.parse(text) as DefaultsFile;
    } catch {
      return;
    }
    if (!parsed || !Array.isArray(parsed.defaults)) return;

    // Apply file → "default" state. Family invariant: last-wins per family.
    const seenFamily = new Set<string>();
    for (const id of parsed.defaults) {
      const f = this.featuresById.get(id);
      if (!f) continue;
      if (f.family && seenFamily.has(f.family)) {
        // Clear previously-applied family member.
        for (const other of FEATURES) {
          if (other.family === f.family) this.state.set(other.id, "off");
        }
      }
      this.state.set(id, "default");
      if (f.family) seenFamily.add(f.family);
    }
  }

  /** If no member of a family is non-off, promote its familyDefault. */
  private seedFamilyDefaults(): void {
    const families = new Map<string, Feature[]>();
    for (const f of FEATURES) {
      if (!f.family) continue;
      const list = families.get(f.family) ?? [];
      list.push(f);
      families.set(f.family, list);
    }
    for (const [, members] of families) {
      const anyActive = members.some((m) => this.isActive(m.id));
      if (anyActive) continue;
      const fallback = members.find((m) => m.familyDefault);
      if (fallback) this.state.set(fallback.id, "default");
    }
  }

  private persist(): void {
    const defaults: string[] = [];
    for (const [id, s] of this.state) {
      if (s === "default") defaults.push(id);
    }
    try {
      mkdirSync(dirname(DEFAULTS_FILE), { recursive: true });
      writeFileSync(
        DEFAULTS_FILE,
        JSON.stringify({ defaults }, null, 2) + "\n",
        "utf8",
      );
    } catch {
      // Disk write failed — keep in-memory state, surface via caller if desired.
    }
  }
}
