/**
 * /pim TUI menu.
 *
 * Renders a SettingsList of all features. Each row shows the current toggle
 * marker ([ ] / [s] / [D]) as the value column. Cycling space/enter walks the
 * states; family siblings are auto-deactivated on activation by FeatureStore.
 */

import type { ExtensionCommandContext } from "@mariozechner/pi-coding-agent";
import { getSettingsListTheme } from "@mariozechner/pi-coding-agent";
import {
  Container,
  type Component,
  type SettingItem,
  SettingsList,
  Text,
} from "@mariozechner/pi-tui";
import { FEATURES } from "./features.js";
import type { FeatureState, FeatureStore } from "./state.js";

const MARKER: Record<FeatureState, string> = {
  off: "[ ]",
  session_on: "[s]",
  default: "[D]",
};

const VALUE_ORDER: readonly string[] = [MARKER.off, MARKER.session_on, MARKER.default];

function stateFromMarker(marker: string): FeatureState {
  if (marker === MARKER.session_on) return "session_on";
  if (marker === MARKER.default) return "default";
  return "off";
}

function buildItems(store: FeatureStore): SettingItem[] {
  return FEATURES.map((f) => ({
    id: f.id,
    label: f.label,
    description: f.description,
    currentValue: MARKER[store.get(f.id)],
    values: [...VALUE_ORDER],
  }));
}

export async function openPimMenu(ctx: ExtensionCommandContext, store: FeatureStore): Promise<void> {
  await ctx.ui.custom<undefined>((tui, theme, _kb, done) => {
    const container = new Container();

    // ── header with key legend ───────────────────────────────────
    const headerLines: Component = {
      render(_width: number): string[] {
        return [
          theme.fg("accent", theme.bold("/pim — feature toggles")),
          "",
          `Key:  ${theme.fg("dim", "[ ]")} off    ${theme.fg("accent", "[s]")} session only    ${theme.fg("success", "[D]")} default (persisted)`,
          theme.fg("dim", "space/enter cycles · esc closes · commit_mode rows are mutually exclusive"),
          "",
        ];
      },
      invalidate() {},
    };
    container.addChild(headerLines);

    const items = buildItems(store);

    const settings = new SettingsList(
      items,
      Math.min(items.length + 2, 12),
      getSettingsListTheme(),
      (id, newValue) => {
        const desired = stateFromMarker(newValue);
        store.set(id, desired);

        // SettingsList drove `newValue` for `id`; but family invariant in
        // store may have flipped siblings to off. Reflect that in the list.
        for (const f of FEATURES) {
          const marker = MARKER[store.get(f.id)];
          settings.updateValue(f.id, marker);
        }
        tui.requestRender();
      },
      () => done(undefined),
    );

    container.addChild(settings);

    return {
      render(width: number): string[] {
        return container.render(width);
      },
      invalidate() {
        container.invalidate();
      },
      handleInput(data: string) {
        settings.handleInput(data);
        tui.requestRender();
      },
    };
  });
}

/** Compact one-line summary for ctx.ui.notify. */
export function summarize(store: FeatureStore): string {
  const lines = FEATURES.map((f) => `  ${MARKER[store.get(f.id)]} ${f.label}`);
  return ["pim state:", ...lines].join("\n");
}
