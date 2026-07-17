# CHARACTER SELECT — GOLD STANDARD BUILD (UE 5.8, Claude Code session)
**Goal:** one finished screen that reads "commercial game." Everything else inherits from it.

> **PARADIGM SYNC (2026-07-17):** The canonical Character Select is the **Dynamic Character Select** per PHASE1_AUDIT.md §0 — camera glides through Verdantia to each fighter's in-world showcase point (streamed Level Instances + tagged cameras, already partially built). It is a dedicated full-screen state, never a popup or a flat grid. **This document now specs the UMG OVERLAY LAYER for that system**: nameplates, join panels, health/Edge previews, ready states, and buttons composed from the component library over the 3D scene. The grid-of-rings layout in `CharSelect_GoldStandard_Mock.png` is superseded as a screen layout; its components remain the overlay kit. Layout table positions below apply to overlay elements only — the roster "slots" become focusable overlay chips/portraits, not full-screen tiles.
Milestone: M2 · Assets: `EE_UI_ComponentLibrary_v1.0.zip` · Style: `UI_STYLE_GUIDE.md` v1.0 · Layout: `CharSelect_GoldStandard_Mock.png`

## Layout table (1920×1080 design space, top-left anchored)
| Element | Component | Pos | Size |
|---|---|---|---|
| Logo | `Brand/T_UI_Logo_Lockup` | 28,18 | 300×190 |
| Title plate (UMG text: CHOOSE YOUR FIGHTER) | `Frames/Panel/T_UI_Panel_TopWide` | 610,34 | 700×140 |
| P1 portrait ring | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Large` | 90,250 | 380×380 |
| P1 nameplate (UMG text) | `Frames/Panel/T_UI_PanelLg_Normal` | 80,648 | 400×108 |
| P1 health preview | `Bars/Health/T_UI_Bar_Health_Full` | 96,772 | 368×68 |
| P1 edge preview | `Bars/Edge/T_UI_Bar_Edge_Full_Emerald` | 96,848 | 368×62 |
| P2 portrait ring | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Large` | 1450,250 | 380×380 |
| P2 nameplate (UMG text) | `Frames/Panel/T_UI_PanelLg_Normal` | 1440,648 | 400×108 |
| P2 health preview | `Bars/Health/T_UI_Bar_Health_Full` | 1456,772 | 368×68 |
| P2 edge preview | `Bars/Edge/T_UI_Bar_Edge_Full_Emerald` | 1456,848 | 368×62 |
| Slot 1 (Koda) | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Hover` | 574,300 | 160×160 |
| Slot 2 (Wren) | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Idle` | 770,300 | 160×160 |
| Slot 3 (Kiri) | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Idle` | 966,300 | 160×160 |
| Slot 4 (Ripper) | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Idle` | 1162,300 | 160×160 |
| Slot 5 (Banjo) | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Disabled` | 574,540 | 160×160 |
| Slot 6 (Echo) | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Disabled` | 770,540 | 160×160 |
| Slot 7 (Atlas) | `Frames/IconRing/T_UI_IconRing_WoodLeaves_Disabled` | 966,540 | 160×160 |
| Slot 8 (???) | `Frames/Panel/T_UI_Ring_Locked` | 1162,540 | 160×160 |
| Back button (UMG text: BACK) | `Buttons/Large/T_UI_BtnLg_Idle` | 320,936 | 500×112 |
| Fight button (UMG text: FIGHT!) | `Buttons/Large/T_UI_BtnLg_Hover` | 1100,936 | 500×112 |

## WBP tree
`WBP_CharacterSelect` → Canvas: BG (3D scene capture or gradient) · TitlePlate+Text · P1Panel / P2Panel (portrait ring, nameplate, HealthPreview ProgressBar, EdgePreview ProgressBar) · RosterGrid (UniformGrid 4×2 of `WBP_RosterSlot`) · Back / Fight `WBP_MenuButton` · Niagara firefly layer.

## WBP_RosterSlot (reusable component)
Vars: FighterRow (DataTable handle), bLocked, bMystery. Visual states map 1:1 to IconRing textures (Idle/Hover/Pressed/Disabled; mystery uses Ring_Locked). Hover anim per style guide §4. On focus: update side panel via event dispatcher.

## Data — DT_Fighters (canon-locked)
| ID | Name | Locked | Mystery |
|---|---|---|---|
| Koda | Koda | no | no |
| Wren | Wren | no | no |
| Kiri | Kiri | no | no |
| Ripper | Ripper | no | no |
| Banjo | Banjo | yes | no |
| Echo | Echo | yes | no |
| Atlas | Atlas | yes | no |
| Sonia | ??? (until unlocked) | yes | **secret — per PROJECT_STATE: present in roster data with a configurable secret/unlock flag, Twin Crescent Chakrams; display stays "???" and slot stays hidden/locked until the unlock condition; never named in any public-facing or marketing material** |
No other rows. Ever. (Ruling source: PROJECT_STATE.md §Canonical Phase 1 Roster — supersedes the earlier "never named in data" line.)

## Vertical slice defaults (CANON LOCK: Wren vs. Ripper · FLOW SYNC 2026-07-17)
P1 initial focus = **Wren**, P2 initial focus = **Ripper**. (The mock's Koda-hover was a state demonstration only.)
**Flow per PHASE1_AUDIT §0:** confirm → all active players ready → transition to **Mode Select** (never directly into a match) → Arena Select popup → match. The earlier "Fight! loads Eucalyptus Summit directly" line is superseded; direct-load remains acceptable only as a temporary capture shortcut, not the shipped flow. Koda remains selectable but is not the slice matchup until his staff pipeline completes.

## Controller navigation
UniformGrid focus navigation (D-pad/stick), wrap horizontal, explicit Down from row 2 → Fight, Up from buttons → nearest slot. A/Cross = select (locked slots play deny cue + violet shimmer 0.3 s), B/Circle = Back. Keyboard mirrors. Set `IsFocusable` and custom `OnNavigation` on edge slots.

## Materials & FX
`M_UI_EmissivePulse` (texture param + §4 pulse) on: Hover ring glow, Edge bar fill, ??? slot. Niagara: `NS_UI_Fireflies` per living-UI spec. Selected-fighter confirm: one-shot leaf-burst (reuse T_FX_LeafMote, 6 sprites, 0.6 s).

## Sound timing
Focus move 40 ms tick (soft wood knock) · Confirm: bloom-chime at t=0 + Edge hum swell 0.4 s · Locked deny: low knock + crystal fizz · Fight!: kookaburra sting is reserved for match start, not here.

## Acceptance checklist
[ ] 60 fps with all FX · [ ] full pad + KB nav, no focus traps · [ ] all text is UMG Text (localizable) · [ ] no violet outside locked slots · [ ] ??? never named · [ ] screenshot passes the "commercial game" gut test next to the arena concept boards.
