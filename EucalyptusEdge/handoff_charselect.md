# CHARACTER SELECT — GOLD STANDARD BUILD (UE 5.8, Claude Code session)
**Goal:** one finished screen that reads "commercial game." Everything else inherits from it.
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
| Mystery | ??? | yes | **yes — never named anywhere in data, UI, or asset names** |
No other rows. Ever.

## Vertical slice defaults (CANON LOCK: Wren vs. Ripper)
P1 initial focus = **Wren**, P2 initial focus = **Ripper**. (The mock's Koda-hover was a state demonstration only.) On Fight!: save both selections and load **Eucalyptus Summit**. Koda remains selectable in the grid but is not the slice matchup until his staff pipeline completes.

## Controller navigation
UniformGrid focus navigation (D-pad/stick), wrap horizontal, explicit Down from row 2 → Fight, Up from buttons → nearest slot. A/Cross = select (locked slots play deny cue + violet shimmer 0.3 s), B/Circle = Back. Keyboard mirrors. Set `IsFocusable` and custom `OnNavigation` on edge slots.

## Materials & FX
`M_UI_EmissivePulse` (texture param + §4 pulse) on: Hover ring glow, Edge bar fill, ??? slot. Niagara: `NS_UI_Fireflies` per living-UI spec. Selected-fighter confirm: one-shot leaf-burst (reuse T_FX_LeafMote, 6 sprites, 0.6 s).

## Sound timing
Focus move 40 ms tick (soft wood knock) · Confirm: bloom-chime at t=0 + Edge hum swell 0.4 s · Locked deny: low knock + crystal fizz · Fight!: kookaburra sting is reserved for match start, not here.

## Acceptance checklist
[ ] 60 fps with all FX · [ ] full pad + KB nav, no focus traps · [ ] all text is UMG Text (localizable) · [ ] no violet outside locked slots · [ ] ??? never named · [ ] screenshot passes the "commercial game" gut test next to the arena concept boards.
