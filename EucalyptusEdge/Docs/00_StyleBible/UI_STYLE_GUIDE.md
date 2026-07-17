# EUCALYPTUS EDGE — UI STYLE GUIDE
**Version 1.0 · 2026-07-16 · Source of truth: the four approved master sheets**
Changelog: v1.0 — initial. All color values SAMPLED from the approved masters, not authored.

## 1 · Palette (sampled)
| Token | Value | Use |
|---|---|---|
| GOLD | #C89938 | trim, inlays, ornament base |
| GOLD_HI | #F6DC8B | worn edges, specular, pressed warmth |
| WOOD_MID | #492E18 | plank field |
| WOOD_DK | #301E10 | recesses, panel interiors |
| EDGE_GLOW | #AED92D | hover glow, Edge energy, carve light |
| CRYSTAL | #8BC54D | Edge Crystal body |
| DISABLED | #332D26 | disabled/desaturated state |
| CREAM | #F3EAD4 | text on dark |
| VIOLET (restricted) | #8B4BC9 | **Blighted / locked content ONLY. Never disabled, never decoration-as-state.** |

## 2 · Materials
Wood: calm cathedral grain, oiled finish (Clearcoat 0.45 in 3D). Gold: forged — hammered, worn bright edges, oxidized recesses. Crystal: translucent emerald, glowing fractures. Reference renders: the master sheets; 3D specs: `handoff_props.md`.

## 3 · Geometry
Border thickness 4–8 px @1080p (hierarchy tier decides). Corner radius: panels 18 px, tiles 22 px, buttons follow the painted plate. Drop shadow: 6 px offset toward bottom-right, 30% black, 8 px blur. Spacing grid: 8 px; minimum gap between interactive elements 24 px.

## 4 · Motion
Hover: 0.12 s in / 0.20 s out, ease-out, scale 1.00→1.04 + glow 0→1. Pressed: 0.06 s, scale 0.97. Crystal pulse: emissive × (0.75 + 0.25·sin(t·1.3)). Vine grow-and-settle on menu open: 1.8 s reveal, hold 0.85. Fireflies ≤4 alive, menus only. Rule: if a playtester consciously notices one effect, halve it.

## 5 · Typography
Display/splash: EricaOne treatment (leaf terminals + engraved cuts — see wordmark system) until the custom font project. UI labels: WorkSans Bold. Body: WorkSans Regular. Sizes @1080p: title 48, button label 30, slot name 27, caption 22. Splash words stay English in localized builds; all other text is UMG Text.

## 6 · Iconography
Icon sizes: 32 / 48 / 64 px inside IconRing frames (clear center ≈ 70% inner diameter). Franchise emblem: pending final selection (round-2 candidates D–H under review); usage rules already locked in `handoff_props.md`.

## 7 · Decoration hierarchy (LAW)
Tier 1 HUD — quiet, gameplay-first · Tier 2 Menus — modest · Tier 3 Character Select — rich · Tier 4 Victory — maximum. Detail scales with importance, never uniformly.

## 8 · State language (LAW)
Idle = wood+gold · Hover = EDGE_GLOW emerald · Pressed = warm gold, pushed-in · Disabled = desaturated (never violet) · Locked/Blighted = violet.
