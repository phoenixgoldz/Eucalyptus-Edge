# Eucalyptus Edge — Project State

> Auto-maintained by Claude. Updated whenever a major milestone is completed.
> Last updated: **2026-07-06**

**Game:** Family-friendly UE 5.8 3D weapon arena fighter (Soulcalibur-style), Blueprint-only.
**World:** Verdantia · **Tagline:** "Cute Fighters. Serious Skills." · "Nature Fights Back!"
**GDD:** `C:\Users\Trevor\Desktop\Eucalyptus-Edge\Docs\EucalyptusEdge_GDDv2.docx`

---

## Current Milestone

**Main Menu Overhaul** — one unified AAA-style front end (Monster Hunter World / Tekken 8 approach):

- One primary full-screen widget: `WBP_MainMenu` (modified in place — no backup widget; Git is the revert path)
- One reusable button: `WBP_EE_MenuButton` (idle/hover/pressed/disabled art states)
- Panels (Lore / Options / Credits) slide inside the same interface via WidgetSwitcher — no separate menu screens
- Optional reusable panel widget only if it proves necessary; keep widget count low
- **No placeholder systems.** Play button fires an exposed Event Dispatcher (`OnPlayRequested`) for Character Select to bind later

## Completed Work

- [x] Menu flow foundation: `LV_MainMenu` startup map → `BP_EE_MainMenu` (GameMode) → `BP_EE_MenuController` (creates `WBP_MainMenu`, adds to viewport)
- [x] Root-caused the video background never playing: `EE_Background.mp4` + FileMediaSource existed, but the MediaPlayer → MediaTexture → material chain was never created
- [x] Button art cut from `Images/MainMenuButtons.png` atlas with background removed to alpha: `MainMenu/Textures/ButtonStates/EE_Btn_{Idle,Hover,Pressed,Disabled}.png` (~1281 px wide)
- [x] Cinzel font (OFL-licensed) downloaded to `MainMenu/Fonts/` with license file — menu font (VerdantiaFont.png is just an image, not a usable font)
- [x] MCP port conflict solved: `Launch_EucalyptusEdge_Dev.bat` in project root launches UE 5.8 with `-ModelContextProtocolPort=8765` (XAMPP owns default port 8000)

## Pending Work

- [ ] Relaunch editor via `Launch_EucalyptusEdge_Dev.bat` so MCP automation is available
- [ ] Import Cinzel TTF and the 4 button-state PNGs as engine assets
- [ ] Build video pipeline: MediaPlayer + MediaTexture + UI material for `EE_Background`
- [ ] Create `WBP_EE_MenuButton` (4-state art, Cinzel label, hover/press feedback)
- [ ] Rebuild `WBP_MainMenu` in place: video bg → gradient scrim → logo → nav column → sliding content panel (WidgetSwitcher: Lore / Options / Credits) → modal layer
- [ ] Play button → `OnPlayRequested` Event Dispatcher (no placeholder Character Select)
- [ ] Options panel contents (audio/video/controls — scope TBD)
- [ ] Lore + Credits panel contents

## Known Issues

- **XAMPP squats port 8000** (UE's default MCP port) — always launch via the dev launcher. Do not stop Apache.
- **`EE_Background.mp4` location:** lives in `Content/EE_ProjectFiles/MainMenu/UI/`, not `Content/Movies/`. Plays in editor, but packaged builds won't include loose non-asset files unless the folder is added to *Additional Non-Asset Directories to Copy* (or the mp4 moves to `Content/Movies/`). Address before first packaged build.
- **UI atlases** in `Content/EE_ProjectFiles/Images/` are packed sheets with opaque dark backgrounds — any further art extracted from them needs the same flood-fill-to-alpha treatment.
- **Emptied character folders** (`AtlasEmuModel/`, `KangarooModel/`, `TasModel/`) are intentional — replacement FBX files are coming. Do not restore or delete.

## Current Assets (Content/EE_ProjectFiles)

| Area | Assets |
|---|---|
| `MainMenu/UI/` | `EE_logo`, `EE_Background` (FileMediaSource) + `EE_Background.mp4` |
| `MainMenu/Textures/` | `UI_BtnNormal`, `UI_BtnGlow`; `ButtonStates/` source PNGs (idle/hover/pressed/disabled, not yet imported) |
| `MainMenu/Fonts/` | `Cinzel-VariableFont.ttf` + `OFL.txt` (not yet imported) |
| `MainMenu/Materials/` | `M_water`, `M_Grass` |
| `Images/` | UI atlas sheets: `MainMenuButtons`, `UI_Buttons`, `UI_Panels`, `UI_Icons`, `UI_Toggles`, `UI_Dividers`, `UI_Decorative`, `UI_ButtonPack`, `CircularIcons`, `ProgressBar`, `UI_WoodCursor`, `VerdantiaFont` (image only), `EEthumbnail` |
| `Characters/` | Rigged models + physics assets + materials for **Koda** (koala), **Kiri** (kookaburra), **Echo** (platypus). Atlas/Kanga/Tas folders emptied pending replacement models |
| `Maps/` | `LV_MainMenu` (startup), `Lv_CrystalCaverns` (crystals, lanterns, bridge, platform env set), `LV_EucalyptusSummit` (tree, main platform env set) |

## Current Blueprints

| Blueprint | Type | Purpose |
|---|---|---|
| `BP_EE_MainMenu` | GameMode | Main menu game mode for `LV_MainMenu` |
| `BP_EE_MenuController` | PlayerController | Creates `WBP_MainMenu`, adds to viewport, sets input mode |
| `WBP_MainMenu` | Widget | The single full-screen front-end widget (being rebuilt this milestone) |
| `WBP_EE_MenuButton` | Widget | *(planned)* reusable 4-state menu button |

## TODO / Next Recommended Task

**➡ Next: close the current editor instance and double-click `Launch_EucalyptusEdge_Dev.bat`.**
That unblocks everything else. Immediately after MCP connects, the build order is:

1. Import font + button PNGs
2. Media pipeline for the video background
3. `WBP_EE_MenuButton`
4. `WBP_MainMenu` unified rebuild
5. Wire `OnPlayRequested`

After this milestone: character select (binds to `OnPlayRequested`), then arena/fight loop work per the GDD.
