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

- [x] **Menu texture + video pass** (2026-07-15, via MCP — details in `PHASE1_AUDIT.md` §9): Images/ atlases spliced with alpha (12 pieces: 4 large plank button states, 4 small button states, green banner + parchment panels, gem divider, vine flourish) and applied to all WBP_MainMenu buttons/panels; **video background LIVE** — `EE_MenuMediaPlayer` + `EE_MenuMediaTexture` + `M_EE_MenuVideo` + full-screen `IMG_VideoBG`, Construct opens `EE_Background`; verified playing in PIE
- [x] **MP4 audio + 60 FPS cap** (2026-07-15): Native Audio Out enabled on `EE_MenuMediaPlayer` (WmfMedia → OS mixer; bypasses UE audio so Master Volume doesn't govern it yet); default `FrameRateLimit` = 60 in `BP_EE_SettingsSave` + `[/Script/Engine.GameUserSettings] FrameRateLimit=60` in DefaultEngine.ini — PIE-verified `t.MaxFPS=60` at startup
- [x] **Settings framework + Options + font pack** (2026-07-15, `PHASE1_AUDIT.md` §10): `BP_EE_SettingsSave` SaveGame (25 settings incl. accessibility) + `BP_EE_GameInstance` (loads & applies settings at startup, registered in DefaultEngine.ini) + reusable row widgets (`WBP_EE_Row_Slider/Check/Dropdown` with dispatchers + instance-editable labels/options) + working Options panel (12 rows, Sync-on-open, Apply→apply+save to `EE_Settings.sav`; PIE-verified). **Verdantia Font Pack live**: Cinzel = Verdantia Display (nav/titles/prompts), Inter = Edge Sans (body/settings rows), both OFL with license files

## Pending Work

- [ ] TEMP_ button sounds (manual import; MCP can't create audio assets) — last M1 gap
- [ ] SoundClass/SoundMix assets so the stored Master/Music/SFX volume settings actually apply (blocked on first audio assets)
- [ ] Real UWidgetAnimation fade/slide transitions (0.15–0.3s) to replace instant panel show/hide (MCP can't create widget animations)
- [ ] Options panel layout polish (rows overhang the banner art at some aspect ratios); more settings categories (Controls/Accessibility tabs) using the existing row widgets
- [ ] Optional: `WBP_EE_MenuButton` reusable widget (art now applied directly to the Buttons, so this is a refactor, not a blocker)
- [ ] Lore panel — note: current button column has **Local Versus**, not Lore; Local Versus currently opens the CharSelect placeholder panel
- [ ] Credits panel contents (studio placeholder text in place)
- [ ] Menu background video replacement per Trevor's direction: living Edge Festival scene (moving banners, birds, waterfalls, evolving Blight storm) instead of a static scenic shot

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
| `BP_EE_GameInstance` | GameInstance | Project GameInstance — loads `EE_Settings` save on Init and applies all settings (resolution, window mode, VSync, FPS cap, scalability, res scale, motion blur) |
| `BP_EE_SettingsSave` | SaveGame | 25 persisted settings across Display/Graphics/Audio/Controls/Gameplay/Accessibility |
| `WBP_EE_Row_Slider` / `_Check` / `_Dropdown` | Widgets | Reusable setting rows (label + control + change dispatcher + Get/Set accessors) — the UI framework for all future screens |
| `WBP_MainMenu` | Widget | The single full-screen front-end widget — nav column, WidgetSwitcher panels (CharSelect placeholder/Options/Credits), quit modal, `OnPlayRequested` dispatcher; all buttons wired (2026-07-15) |
| `WBP_EE_MenuButton` | Widget | *(planned)* reusable 4-state menu button |

## TODO / Next Recommended Task

**➡ Next: Character Select (M2)** — bind to `OnPlayRequested`, reuse the Framework row/panel widgets and the two fonts. Remaining M1 polish in parallel: TEMP_ button sounds + fade/slide widget animations (manual editor steps), plus a hands-on PIE pass with a controller (focus/nav/Apply behavior, video loop, settings persisting across restarts).

After M2: arena/fight loop work per `PHASE1_AUDIT.md` §7.
