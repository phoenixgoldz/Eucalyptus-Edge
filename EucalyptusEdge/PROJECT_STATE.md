# Eucalyptus Edge — Project State

> Auto-maintained by Claude. Updated whenever a major milestone is completed.
> Last updated: **2026-07-15**

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
- [x] **PHASE1 project audit** (2026-07-15): full asset/Blueprint/milestone inventory → `PHASE1_AUDIT.md`
- [x] **M1 Main Menu wiring** (2026-07-15, via MCP — details in `PHASE1_AUDIT.md` §8): panel structure inside `WBP_MainMenu` (`Panel_Content` → `WS_Panels` WidgetSwitcher: CharSelect placeholder / Options / Credits + shared `Back_btn`), quit-confirm modal (`Overlay_QuitConfirm`, Yes → QuitGame / No → cancel), `OnPlayRequested` Event Dispatcher (fired by Play), all 5 nav buttons + Back/Yes/No wired, initial + per-transition keyboard focus, input locking (nav column collapses while a panel is open), hover scale feedback on all nav buttons. Compiled + saved.

## Pending Work

- [ ] Build video pipeline: MediaPlayer + MediaTexture + UI material for `EE_Background` + Image layer in `WBP_MainMenu` (MCP can't create Media assets — manual editor step)
- [ ] Import Cinzel TTF and the 4 button-state PNGs as engine assets; apply to nav + panel buttons
- [ ] TEMP_ button sounds (manual import; MCP can't create audio assets)
- [ ] Real UWidgetAnimation fade/slide transitions (0.15–0.3s) to replace instant panel show/hide (MCP can't create widget animations)
- [ ] Create `WBP_EE_MenuButton` (4-state art, Cinzel label, hover/press feedback) and swap in for plain Buttons
- [ ] Options panel contents (audio/video/controls — scope TBD; placeholder text in place)
- [ ] Lore panel — note: current button column has **Local Versus**, not Lore; Local Versus currently opens the CharSelect placeholder panel
- [ ] Credits panel contents (studio placeholder text in place)

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
| `WBP_MainMenu` | Widget | The single full-screen front-end widget — nav column, WidgetSwitcher panels (CharSelect placeholder/Options/Credits), quit modal, `OnPlayRequested` dispatcher; all buttons wired (2026-07-15) |
| `WBP_EE_MenuButton` | Widget | *(planned)* reusable 4-state menu button |

## TODO / Next Recommended Task

**➡ Next: manual editor pass on the menu (things MCP can't automate), then verify in PIE.**

1. Media pipeline for the video background (MediaPlayer + MediaTexture + UI material + Image layer, OpenSource+Play on Construct)
2. Import Cinzel font + button-state PNGs; apply styles
3. TEMP_ button sounds; 0.15–0.3s fade/slide widget animations for the panels
4. PIE test: focus starts on Play; panels open/lock/back correctly; Exit → confirm → quits; gamepad navigation can't escape the menu

After this milestone: Character Select (binds to `OnPlayRequested` — M2), then arena/fight loop work per `PHASE1_AUDIT.md` §7.
