# PHASE1_AUDIT.md — Eucalyptus Edge (UE 5.8, Blueprint-only)

**Original live-editor audit:** 2026-07-14  
**Current directive revision:** 2026-07-15

> This document contains historical audit evidence plus newer implementation logs.  
> When an older section conflicts with **Section 0 — Current Canon and Immediate Directive**, Section 0 is authoritative.

---

## 0. Current Canon and Immediate Directive

### Active roster

The current roster data must contain:

**Base fighters**
- Koda
- Wren
- Ripper
- Kiri
- Echo
- Banjo
- Atlas

**Secret unlockable**
- Sonia the White Tigress — locked/hidden by default, Twin Crescent Chakrams, orange-and-gold clothing, white fur

Do not use Mako, Bindi, Bramble, or Tazra in new gameplay/UI work. Mako is permanently removed, Bindi is cut, and Bramble/Tazra are archived.

### Canonical arenas

The current canonical arena roster is:

- Eucalyptus Summit
- Crystal Caverns
- Bamboo Harbor
- Frostpine Ridge
- Sunbaked Outback
- Moonlit Rainforest
- Edge Festival Colosseum
- Blightroot Hollow

`Sunbaked Outback` and `Sunbaked Outback` are obsolete names. Use **Sunbaked Outback**.

The original audit's asset inventory records what existed in UE at that moment; it does not define canon. A missing map means implementation is pending, not that the arena has been removed.


### Canonical arena correction

The current arena canon includes **Blightroot Hollow**, the newest Blight-corrupted arena concept. Any older arena list that omits it is incomplete.

Blightroot Hollow should be treated as a distinct future arena/environment featuring:

- corrupted roots and hollow trees
- purple and black Blight crystals
- drifting spores and black smoke
- unstable terrain and ring-out hazards
- readable family-friendly presentation rather than horror


### Current fighter-model status

All seven canonical fighter model folders are now present:

- Atlas
- Banjo
- Echo
- Kiri
- Koda
- Ripper
- Wren

No active-roster fighter is missing.

The first combat validation pair is now:

```text
Wren vs. Ripper
Arena: Eucalyptus Summit
```

This supersedes the older Koda-vs.-Ripper recommendation. Wren and Ripper are preferred because their weapons are already integrated into their models, avoiding a weapon-modeling dependency for the first playable fight.

Before implementation, verify in the live editor:

- Wren skeletal mesh, skeleton, physics asset, materials, and animation compatibility
- Ripper skeletal mesh, skeleton, physics asset, materials, and animation compatibility
- whether either mesh needs retargeting cleanup or scale correction

### First playable matchup

The first combat implementation target is:

```text
Wren vs. Ripper
Arena: Eucalyptus Summit
```

This supersedes the older Koda-vs.-Ripper target because Wren and Ripper already have their weapons integrated into their current models, removing the separate weapon-modeling dependency.

### Correct front-end flow

```text
Main Menu
→ Play
→ Dynamic Character Select
→ Mode Select
→ Arena Select popup
→ Match
```

Only three major full-screen front-end states are intended:

1. Main Menu
2. Character Select
3. Mode Select

### Main Menu buttons

```text
Play
Lore
Options
Credits
Exit
```

The existing `Local_Versus_btn` is legacy and should become `Lore_btn`.  
The Character Select placeholder inside `WBP_MainMenu` is not the final Character Select and must be removed after the dedicated flow is connected.

### Dynamic Character Select requirement

The defining Character Select behavior is:

> When a player highlights a fighter, the camera glides through Verdantia to that fighter's in-world showcase location.

Character Select must not remain a modal popup over the Main Menu and must not be flattened into one stationary preview model.

Required capabilities:

- data-driven eight-entry roster: seven base fighters plus locked secret fighter Sonia
- full-screen dedicated Character Select presentation
- Player 1 active by default
- Player 2 joins from a second controller
- independent player navigation and ready states
- camera blend to each fighter's showcase point
- character-specific idle/attention/confirm animation hooks
- Continue only when all active players confirm
- transition to Mode Select, not directly to a match
- controller-first navigation
- configurable duplicate-selection rule

### Preferred new assets

```text
/Game/EE_ProjectFiles/CharacterSelect/
├── Blueprints/
│   ├── BP_EE_CharacterSelectGameMode
│   ├── BP_EE_CharacterSelectController
│   ├── BP_EE_CharacterSelectManager
│   └── BP_EE_CharacterShowcasePoint
├── Data/
│   ├── ST_EE_CharacterSelectEntry
│   └── DA_EE_CharacterRoster
├── Level/
│   └── LV_CharacterSelect
└── Widgets/
    ├── WBP_CharacterSelect
    ├── WBP_CharacterPortrait
    ├── WBP_PlayerJoinPanel
    └── WBP_CharacterInfoPanel
```

Equivalent architecture inside a reusable front-end shell is acceptable only if it behaves as a dedicated cinematic screen rather than a popup.

### Required read-only verification before implementation

Because fighter modeling/import work has advanced since the original audit, Claude must re-audit the live editor for:

- exact skeletal mesh paths
- skeletons and physics assets
- Banjo and Atlas import status
- Ripper skeletal status
- existing Character Select placeholder assets
- input actions and mapping contexts
- local-player support
- usable idle/confirm animations
- any existing camera/showcase work
- current implementation status for all eight canonical arenas, distinguishing concept art, imported meshes, and playable maps

Do not rely on the older asset inventory for final fighter availability without checking the live project.

---

## 1. Asset inventory (/Game)

### Custom EE work — `/Game/EE_ProjectFiles/`
| Group | Assets |
|---|---|
| GameModes | `MainMenu/Blueprints/BP_EE_MainMenu` (parent: GameModeBase — project GlobalDefaultGameMode) |
| PlayerControllers | `MainMenu/Blueprints/BP_EE_MenuController` (parent: PlayerController) |
| UMG Widgets | `MainMenu/Widgets/WBP_MainMenu` (only custom widget in project) |
| Levels | `MainMenu/Level/LV_MainMenu` (EditorStartupMap + GameDefaultMap) |
| Media | `MainMenu/UI/EE_Background` (**FileMediaSource** — no MediaPlayer, MediaTexture, or media material exists anywhere in /Game) |
| Fighter meshes | Koda: `Characters/KodaKoalaModel/RiggedKoda` (+ `_Skeleton`, `_PhysicsAsset`, `0_T-Pose`, `0_Open_A_UE5`) · Kiri: `Characters/KiriKookaModel/RiggedKiri` (same set) · Echo: `Characters/EchoPlatyModel/RiggedEcho` (same set) · Wren: `Characters/KangarooModel/WrenKangaroo` (same set) |
| Ripper | Original audit found `Characters/TasModel/RipperTas` as StaticMesh only. **Superseded by current state:** Ripper now has a skeletal mesh, skeleton, and physics asset visible in UE; exact asset path and readiness require live verification. |
| Atlas / Banjo | Character folders now exist under `/Game/EE_ProjectFiles/Characters/`; user reports all seven base fighter models are present. Re-audit exact meshes, skeletons, materials, and animation assets live in UE before implementation. |
| Arena env meshes | Eucalyptus Summit: `Maps/LV_EucalyptusSummit/Environment/Main_Platform` (+ PBR textures) · Crystal Caverns: `Maps/Lv_CrystalCaverns/Environment/` (Cavern_Rock_Walls, Crystal_Cluster, Crystal_Platform, Hanging_Lantern, Large_Purple_Crystal, Wooden_Bridge) · Frostpine Ridge: `Maps/LV_FrostpineRidge/` (Breakable_Ice_Pillar, Front_Access_Stairs, Stone_Brazier, Wooden_Bridge) · plus `Maps/Right_Festival_Banner` |
| UI art | `MainMenu/Textures/ButtonStates/EE_Btn_{Idle,Hover,Pressed,Disabled}`, `MainMenu/Textures/UI_Btn{Normal,Glow}`, `MainMenu/UI/EE_logo`, `Images/` UI atlases (UI_ButtonPack, UI_Panels, UI_Icons, …) |
| Fonts | `MainMenu/Fonts/Cinzel-VariableFont` (+ `_Font` face) |
| Foliage | `Foliage/Eucalyptus_Tree` |

**No level asset exists for any arena** — Eucalyptus Summit, Crystal Caverns, Frostpine Ridge have environment meshes only. The only custom map is LV_MainMenu.

### Fighter Variant template — `/Game/Variant_Combat/` (+ `/Game/ThirdPerson/`, `/Game/Characters/Mannequins/`, `/Game/Input/`)
- **GameModes**: `BP_CombatGameMode`, `BP_ThirdPersonGameMode`
- **Characters/Pawns**: `BP_CombatCharacter` (parent: Character), `BP_ThirdPersonCharacter`, AI: `BP_CombatEnemy`, `BP_CombatAIController`, `BP_Combat_EnemySpawner`, `ST_CombatEnemy` (StateTree) + EQS queries/contexts + StateTree tasks
- **Interfaces**: `BPI_Attacker`, `BPI_Damageable`, `BPI_Activatable`
- **Interactables**: `BP_Combat_ActivationVolume`, `BP_Combat_CheckpointVolume`, `BP_Combat_DamageableBox`, `BP_Combat_Dummy`, `BP_Combat_LavaFloor`
- **Anim**: `ABP_Manny_Combat`, montages `AM_ComboAttack`, `AM_ChargedAttack`, notifies `AN_AttackCombo`, `AN_AttackDamage`, `AN_ChargedAttack`; Mannequin anim library under `/Game/Characters/Mannequins/Anims/` (incl. `MM_Dash`, HitReacts, Deaths); `ABP_Unarmed`, `BS_Idle_Walk_Run`
- **UMG**: `UI_LifeBar`; camera shakes `BP_CameraShake_Hit_Player/_Enemy`; VFX `NS_Damage`
- **Levels**: `Lvl_Combat`, `Lvl_ThirdPerson`
- **Enhanced Input**: `IMC_Default` (IA_Move, IA_Look, IA_MouseLook, IA_Jump), `IMC_Combat` (IA_ComboAttack, IA_ChargedAttack, IA_ToggleCameraSide)

### Marketplace/plugin content (not template, not custom)
`GoodSky`, `MWLandscapeAutoMaterial`, `PWL_Light_Manager`, `PCG_Spline_Tool`, `PCKeyboardMouseIconPack`, `LevelPrototyping`

---

## 2. Key Blueprint internals

**BP_EE_MainMenu** (GameModeBase): event graph empty (bare BeginPlay/Tick). Set as GlobalDefaultGameMode in DefaultEngine.ini.

**BP_EE_MenuController** (PlayerController) — BeginPlay:
`CreateWidget(WBP_MainMenu) → AddToViewport → bShowMouseCursor=true → SetInputModeUIOnly(widget, DoNotLock)`
No focus set to any button; no gamepad consideration.

**WBP_MainMenu** (UserWidget, root CanvasPanel, 18 widgets):
- `Canvas_Root` → `VB_MenuButtons` (five SizeBox-wrapped Buttons: **`Play_btn`, `Local_Versus_btn`, `Options_btn`, `Credits_btn`, `Exit_btn`**, each with a plain TextBlock label) + `IMG_Logo`
- **Event graph is empty** — zero button handlers, no panels, no animations, no video layer, no scrim. Note: the button column is Play / **Local Versus** / Options / Credits / Exit — the briefing's M1 list says "Lore", which does not exist in the widget. *(Superseded 2026-07-15 — see §8 M1 work log: panels, quit modal, dispatcher, and all button wiring now exist.)*

**BP_CombatCharacter** (template fighter): vars — MaxHP/CurrentHP, PelvisBoneName, MeleeTraceDistance/Radius, MeleeDamage, MeleeKnockbackImpulse, MeleeLaunchImpulse, ComboAttackMontage + ComboSectionNames + input-cache tolerances, ChargedAttackMontage + charge sections, LifeBarWidget, DefaultCameraDistance/DeathCameraDistance, ShoulderOffset, CameraHeight, RespawnTime, DangerTraceDistance/Radius. Functions: Move, Aim. Input via IMC_Default + IMC_Combat.

---

## 3. How the template implements combat
- **Movement**: standard CharacterMovement, **free 3D movement — NOT plane-constrained** (this is the 3D action-brawler variant). ✅ No 2D-fighter assumption to break here.
- **Camera**: third-person follow (shoulder offset + camera height + IA_ToggleCameraSide). **No lock-on** — must be built for arena dueling.
- **Attacks**: montage-driven. Combo chain via montage sections + `AN_AttackCombo`/`AN_AttackDamage` notifies; hit detection = melee sphere trace (distance/radius vars) on the damage notify; applies damage + knockback/launch impulses through `BPI_Damageable`/`BPI_Attacker`. Charged attack with loop/release sections.
- **Blocking**: none. **Dodging**: none wired (an `MM_Dash` anim exists unused).
- **Health/damage**: Current/Max HP on the character, `UI_LifeBar` widget, hit-react + death montages, ragdoll via PelvisBoneName, timed respawn at checkpoints.
- **Round/match flow**: none — PvE brawler flow (spawners, checkpoints, lava floor). No rounds, KO/Victory screens, or match state.
- **HUD**: `UI_LifeBar` only.
- **Flags for the 3D arena fighter**: (1) movement-plane constraint — not present, nothing to break; (2) **ring-out volumes — absent** (`BP_Combat_LavaFloor` is the closest analogue: an overlap-damage floor, a useful pattern to adapt); (3) additionally absent and required: lock-on camera, P2/local-versus pawn + input, round/match state.

---

## 4. Name searches (assets)
| Term | Hits |
|---|---|
| MainMenu | WBP_MainMenu, BP_EE_MainMenu (+MenuController), LV_MainMenu, Images/MainMenuButtons |
| CharacterSelect / ModeSelect | none |
| Edge / Meter (Edge Energy) | none (EE_ asset prefix only) |
| RingOut / KO / Victory / Round | none |
| Lore / Credits / Options | none (buttons `Options_btn`/`Credits_btn` inside WBP_MainMenu only) |

## 5. Skeletal meshes / skeletons / retargeting

**Wren current screenshot evidence:** `WrenKangaroo` SkeletalMesh, `WrenKangarooSkeleton`, PhysicsAsset, Open_A_UE5 animation, T-Pose animation, diffuse/normal textures, and material instance are visible in the current UE 5.8 project.

**Ripper current screenshot evidence:** `Ripper_Tas` SkeletalMesh, `Ripper_Tas_Skeleton`, PhysicsAsset, material, base-color texture, and normal map are visible in the current UE 5.8 project.

| Fighter | Mesh | Skeleton | Status |
|---|---|---|---|
| Koda | RiggedKoda | RiggedKoda_Skeleton | ✅ imported |
| Kiri | RiggedKiri | RiggedKiri_Skeleton | ✅ imported |
| Echo | RiggedEcho | RiggedEcho_Skeleton | ✅ imported |
| Wren | WrenKangaroo | WrenKangaroo_Skeleton | ✅ imported |
| Ripper | Ripper_Tas | Ripper_Tas_Skeleton | ✅ skeletal mesh visible in current UE screenshot; verify live path and animation compatibility |
| Atlas | present per current project state | verify live | ⚠️ re-audit exact imported assets |
| Banjo | present per current project state | verify live | ⚠️ re-audit exact imported assets |
| Template | SK_Mannequin, SKM_Manny_Simple, SKM_Quinn_Simple | UE5 Mannequin | ✅ |

**IK Rig / IK Retargeter assets: none in project.** Each EE fighter has its own skeleton — retargeting the Mannequin combat anims (or bespoke anims) onto RiggedKoda/RipperTas skeletons will need IK Rigs + Retargeters (or AnimBP duplication per skeleton).

---

## 6. Milestone status (M1–M5)

| Item | Status | Evidence |
|---|---|---|
| **M1 Main Menu** | | |
| Play/Lore(=Local Versus)/Options/Credits/Exit wiring | **Done** (2026-07-15) | All 5 buttons + Back/QuitYes/QuitNo wired via component-bound OnClicked events; Play fires `OnPlayRequested` dispatcher + opens CharSelect placeholder panel; Exit opens quit-confirm modal → QuitGame |
| Widget animations | **Partial** | Hover/unhover SetRenderScale 1.05/1.0 on all 5 nav buttons; real UWidgetAnimation fade/slide (0.15–0.3s) cannot be created via MCP — manual editor step |
| Controller navigation | **Partial** | Construct sets keyboard focus to Play_btn; Back restores focus to Play_btn, quit-confirm focuses No; default VerticalBox arrow/gamepad nav applies. Explicit nav-wrap rules = manual polish |
| Transitions (panels) | **Done** (structure) | `Panel_Content` Border (anchored right, collapsed) → `VB_Panel` → `WS_Panels` WidgetSwitcher (P_CharSelect / P_Options / P_Credits) + shared `Back_btn`; instant show/hide, animated slide pending (see above) |
| Button sounds | **Missing** | no audio assets in /Game; MCP cannot create sound assets — TEMP_ placeholder sounds are a manual import step. **Only remaining M1 gap.** |
| Input locking during transitions | **Done** | `VB_MenuButtons` collapsed while a panel is open (blocks re-click + removes from nav); quit-confirm overlay scrim (zOrder 10) blocks clicks behind it |
| Focus handling | **Done** | UI-only input mode (BP_EE_MenuController) + initial focus Play_btn on Construct; focus explicitly moved on every panel open/close |
| Animated MP4 background | **Done** (2026-07-15) | `EE_MenuMediaPlayer` (PlayOnOpen+Loop) + `EE_MenuMediaTexture` + `M_EE_MenuVideo` (UI-domain material) + full-screen `IMG_VideoBG` layer (zOrder -10, hit-test invisible); Construct calls OpenSource(EE_Background). **Verified playing in PIE.** |
| **M2 Dynamic Character Select** | | |
| Dedicated full-screen state | **Missing / placeholder incorrect** | Current Main Menu contains only a temporary Character Select panel; it must not become the final system |
| Data-driven seven-fighter roster | **Missing** | Build from struct/Data Asset or Data Table |
| Camera travel to in-world showcase points | **Missing** | Core defining requirement |
| P2 join and independent selection | **Missing** | Second-controller join required |
| Ready-up and Continue to Mode Select | **Missing** | Must not launch directly into a match |
| **M3 Mode Select** | | |
| Training / Local Versus / disabled Online | **Missing** | `Local_Versus_btn` exists unwired in main menu; no mode select screen |
| **M4 Eucalyptus Summit level** | **Missing** (assets Partial) | no map asset; env meshes at `EE_ProjectFiles/Maps/LV_EucalyptusSummit/Environment/Main_Platform` |
| **M5 Combat** | | |
| Movement (free 3D) | **Template-provided** | BP_CombatCharacter + CharacterMovement, IMC_Default |
| Camera | **Partial (template)** | follow cam + side toggle; no lock-on |
| Lock-on | **Missing** | — |
| Health | **Template-provided** | CurrentHP/MaxHP, UI_LifeBar, BPI_Damageable |
| Light attack | **Template-provided** | IA_ComboAttack → AM_ComboAttack combo chain |
| Heavy attack | **Template-provided** | IA_ChargedAttack → AM_ChargedAttack |
| Block | **Missing** | — |
| Dodge | **Missing** | MM_Dash anim exists, unwired |
| Ring-out | **Missing** | BP_Combat_LavaFloor is an adaptable pattern |
| Win screen | **Missing** | no round/match flow |

---

## 7. Shortest path to Wren vs. Ripper playable in Eucalyptus Summit
1. **Create `LV_EucalyptusSummit` map** under `/Game/EE_ProjectFiles/Maps/LV_EucalyptusSummit/` using the existing `Main_Platform` mesh + GoodSky/lighting, with two PlayerStarts and a blocking-volume perimeter → falls = ring-out zone below.
2. **Duplicate `BP_CombatCharacter` → `BP_EE_Fighter`** (keep template combat intact); child it twice (`BP_EE_Wren`, `BP_EE_Ripper`); assign the current Wren and Ripper skeletal meshes with retargeted or placeholder AnimBPs. Their integrated gloves/claws remove the need for separate weapon attachment work in the first test.
3. **Ring-out volume**: adapt the `BP_Combat_LavaFloor` overlap pattern into `BP_EE_RingOutVolume` — on fighter overlap, declare the other fighter the winner instead of applying damage.
4. **Versus GameMode**: `BP_EE_VersusGameMode` — spawn P1 + P2 (second local player, splitscreen already enabled in DefaultEngine.ini) or P1 vs. dummy AI (`BP_Combat_Dummy`) for the first capture; simple round state: fight → HP 0 or ring-out → win screen widget → restart.
5. **Wire Play → Character Select → LV_EucalyptusSummit** flow (M1→M2 handoff), or for the very first capture, `Open Level LV_EucalyptusSummit` directly from Play.

**Biggest unplanned gap**: no IK Rig/Retargeter assets — retargeting remains a critical path for both Wren and Ripper unless their current skeletons already support the required combat animation pipeline. The live editor now shows a Ripper skeletal mesh, skeleton, and physics asset, so the older static-mesh-only warning is superseded and must be re-verified rather than assumed.

---

## 7A. Front-End Flow Correction (2026-07-15)

The earlier M1 implementation opened a Character Select placeholder panel inside `WBP_MainMenu`. That was useful only as a temporary wiring test and is now superseded.

Required correction:

1. Keep the working Main Menu, video, Options, Credits, settings, quit modal, fonts, and button art.
2. Replace `Local_Versus_btn` with `Lore_btn`.
3. Remove `P_CharSelect` from the Main Menu's internal panel flow after the dedicated Character Select is connected.
4. Bind Play to transition into the dedicated Dynamic Character Select.
5. Build Character Select around camera travel between physical fighter showcase points.
6. After all active players confirm, transition to Mode Select.
7. Use an Arena Select popup from Mode Select.

Do not delete working M1 systems and do not create another Character Select popup.

---

## 8. M1 work log (2026-07-15)

### Assets modified
Only **one** asset was modified — `/Game/EE_ProjectFiles/MainMenu/Widgets/WBP_MainMenu` (compiled + saved). No assets were created, renamed, or deleted. Per the unified-menu decision (2026-07-06), everything lives inside WBP_MainMenu — no placeholder widgets.

### Widgets added to WBP_MainMenu (18 new, tree now 36)
- `Panel_Content` (Border, **variable**, collapsed, anchors 0.55/0.08–0.97/0.92, zOrder 5, dark green-black 85%) — sliding content panel
  - `VB_Panel` (VerticalBox, padding 32)
    - `WS_Panels` (WidgetSwitcher, **variable**, fill) — index 0 `P_CharSelect`, 1 `P_Options`, 2 `P_Credits` (each a VerticalBox with `Txt_*Title` + `Txt_*Body` TextBlocks; CharSelect is the placeholder panel: "CHARACTER SELECT / Choose your fighter — coming soon.")
    - `Back_btn` (Button, **variable**, centered) + `Txt_Back`
- `Overlay_QuitConfirm` (Border, **variable**, collapsed, full-screen scrim black 60%, zOrder 10)
  - `VB_Quit` (centered) → `Txt_QuitPrompt` ("Quit Eucalyptus Edge?") + `HB_QuitButtons` → `QuitYes_btn`/`Txt_QuitYes`, `QuitNo_btn`/`Txt_QuitNo`
- `VB_MenuButtons` flipped to **variable** (needed for input locking)

### Blueprint graph (was empty; now 21 events)
- **Event dispatcher `OnPlayRequested`** added — Character Select hooks this later (no temp flow)
- **Construct** → SetKeyboardFocus(Play_btn)
- **Play_btn** → Call OnPlayRequested + open panel 0 (CharSelect placeholder); **Local_Versus_btn** → panel 0; **Options_btn** → panel 1; **Credits_btn** → panel 2. Panel open = show Panel_Content, collapse VB_MenuButtons (input lock), focus Back_btn
- **Back_btn** → collapse Panel_Content, restore VB_MenuButtons, focus Play_btn
- **Exit_btn** → show Overlay_QuitConfirm, focus QuitNo_btn; **QuitYes_btn** → QuitGame; **QuitNo_btn** → close overlay, focus Exit_btn
- **OnHovered/OnUnhovered** on all 5 nav buttons → SetRenderScale 1.05 / 1.0

### Manual editor steps remaining (MCP tooling cannot create these asset types)
1. **Button sounds**: import TEMP_ placeholder WAVs → set each Button style's Pressed/Hovered sound.
2. **Widget animations**: replace instant panel show/hide with 0.15–0.3s fade/slide UWidgetAnimations; optional focus-highlight animation.
3. Optional polish: explicit navigation wrap rules on VB_MenuButtons; Cinzel font applied to the menu TextBlocks (TTF on disk under `MainMenu/Fonts/`, needs import as Font asset).

---

## 9. Texture + video work log (2026-07-15, second pass)

### Atlas splicing (on disk, C# flood-fill cutter — crops region, removes near-black bg connected to image border, trims)
From `Content/EE_ProjectFiles/Images/` source PNGs, cut with alpha to:
- `MainMenu/Textures/ButtonStates/`: **EE_Btn_Idle / Hover / Pressed / Disabled** (~1281×192–205, from MainMenuButtons.png; re-cut clean — the old cuts had a logo-banner scrap baked into the corner)
- `MainMenu/Textures/UI/`: **EE_Panel_Parchment** (473×709), **EE_Panel_Green** (474×706) from UI_Panels.png; **EE_BtnSm_Idle/Hover/Pressed/Disabled** (~462–512×250–317) from UI_Buttons.png row 2; **EE_Divider_Gem** (1280×153) from UI_Dividers.png; **EE_Flourish_Vine** (1304×233) from UI_Decorative.png
- All 12 auto-imported by the editor as Texture2D assets (verified sizes match today's pixels)

### Widget styling (WBP_MainMenu — same single asset modified)
- 5 nav buttons: `widgetStyle` Normal/Hovered/Pressed/Disabled = EE_Btn_* plank art (drawAs Image, content padding 44/10–14)
- `Back_btn`, `QuitYes_btn`, `QuitNo_btn`: EE_BtnSm_* small-frame art
- `Panel_Content`: background = EE_Panel_Green banner (tint reset to white)
- New `Border_QuitPlate` (Border) wraps `VB_Quit` inside `Overlay_QuitConfirm`: parchment background, padding 70/90; `Txt_QuitPrompt` recolored dark-brown for parchment
- New Images: `IMG_Div_CharSelect/Options/Credits` (EE_Divider_Gem, centered under each panel title), `IMG_Flourish` (EE_Flourish_Vine, top of quit plate)

### Video background pipeline (fully automated — MediaPlayer/MediaTexture created via editor UI automation, SlateInspector toolset)
- **EE_MenuMediaPlayer** (MediaPlayer; PlayOnOpen ✓, Loop ✓) — `MainMenu/UI/`
- **EE_MenuMediaTexture** (MediaTexture; linked to player, Clamp addressing) — `MainMenu/UI/`
- **M_EE_MenuVideo** (Material, UI domain; TextureSample(EE_MenuMediaTexture, Color sampler) → Final Color) — `MainMenu/Materials/`
- **IMG_VideoBG** Image in WBP_MainMenu: full-screen anchors, zOrder −10 (behind everything), HitTestInvisible, brush = M_EE_MenuVideo
- Construct event now calls `OpenSource(EE_MenuMediaPlayer, EE_Background)` before setting keyboard focus
- A stray `NewMediaTexture` byproduct of the automated menu clicks was deleted (created and removed same session, never referenced)
- **PIE-verified**: video plays behind logo + plank-art nav column

### Assets created this pass
`EE_MenuMediaPlayer`, `EE_MenuMediaTexture`, `M_EE_MenuVideo` + 8 new Texture2D (EE_Panel_*, EE_BtnSm_*, EE_Divider_Gem, EE_Flourish_Vine) + 4 re-imported (EE_Btn_*). Modified: `WBP_MainMenu` only.

---

## 10. Settings framework + Options system + font pack (2026-07-15, third pass)

### Architecture (all Blueprint, all under `/Game/EE_ProjectFiles/Framework/`)
- **`BP_EE_SettingsSave`** (SaveGame): 25 variables covering Display (ResolutionX/Y, WindowMode, MonitorIndex, FrameRateLimit, bVSync, Brightness, UIScale), Graphics (OverallQuality, ScreenPercentage, bMotionBlur), Audio (Master/Music/SFX/UI/Voice/Ambient volumes), Controls (bVibration, DeadZone), Gameplay (bSubtitles, bDamageNumbers, bTutorialPrompts, Language), Accessibility (bLargeText, bHighContrastUI, ColorBlindMode, bReduceCameraShake, bReduceFlashing, bMonoAudio). CDO defaults set (1920×1080, Borderless, Unlimited FPS, VSync on, Epic quality, volumes 1.0, motion blur OFF, subtitles on).
- **`BP_EE_GameInstance`** (GameInstance; registered in DefaultEngine.ini `GameInstanceClass` + live CDO): **Event Init → LoadSettings → ApplyAllSettings** (settings persist and auto-apply at every startup). Functions: `LoadSettings` (slot "EE_Settings", creates from defaults if missing/corrupt), `SaveSettings`, `ApplyAllSettings` (GameUserSettings: resolution, window mode, VSync, frame-rate limit, overall scalability, resolution scale, ApplySettings; console: r.MotionBlurQuality).
- **Reusable rows** (`Framework/Widgets/`): `WBP_EE_Row_Slider` (label+slider+value readout; `OnRowValueChanged` dispatcher; SetValue/GetValue), `WBP_EE_Row_Check` (label+checkbox; `OnRowChecked`; SetChecked/GetChecked), `WBP_EE_Row_Dropdown` (label+ComboBoxString; instance-editable `Options` string array auto-populates at Construct; `OnRowSelected`; SetIndex/GetIndex). All have instance-editable `LabelText` applied in PreConstruct. These are the building blocks for every future screen (Pause, Character Select, etc.).

### Options panel (inside WBP_MainMenu P_Options)
`SB_Options` ScrollBox with 12 rows — Resolution (720p→4K), Window Mode (Fullscreen/Borderless/Windowed), Frame Rate Limit (Unlimited→240), Overall Quality (Low→Epic), VSync, Resolution Scale (50–100%), Motion Blur, Master/Music/SFX Volume, Subtitles, Reduce Camera Shake — plus **Apply** button (EE_BtnSm art).
Flow: **Options click → SyncOptionsFromSettings** (reads save, sets all 12 rows) → user edits → **Apply → ApplyOptions** (reads all rows, writes save object, ApplyAllSettings, SaveSettings to disk). **PIE-verified end-to-end**: rows render with synced values, Apply writes `Saved/SaveGames/EE_Settings.sav`.

### Verdantia Font Pack (both OFL, auto-imported as Font assets from TTFs in `MainMenu/Fonts/`)
- **Verdantia Display = Cinzel** (`Cinzel-VariableFont_Font`): applied to all 5 nav button labels (26pt), panel titles (32pt), quit prompt (26pt), Back/Yes/No/Apply (22pt)
- **Edge Sans = Inter** (`EdgeSans-Inter-VariableFont_Font`, downloaded this session + OFL-Inter.txt): applied to panel body text (18pt) and all setting-row labels/value readouts (18pt, set once in the row classes)

### Assets created this pass
`Framework/BP_EE_SettingsSave`, `Framework/BP_EE_GameInstance`, `Framework/Widgets/WBP_EE_Row_{Slider,Check,Dropdown}`, `Fonts/EdgeSans-Inter-VariableFont` (+_Font). Modified: `WBP_MainMenu`, `Config/DefaultEngine.ini` (GameInstanceClass). Note: audio volume settings are **stored** but not yet applied (needs SoundClass/SoundMix assets — none exist in the project yet); Brightness/UIScale/DeadZone/etc. stored for future systems to read.

### Follow-up fixes (2026-07-15, same day)
- **MP4 audio**: `EE_MenuMediaPlayer` had no audio route (MediaTexture is video-only). Enabled **Native Audio Out** on the player — WmfMedia sends the MP4's AAC track straight to the OS mixer. Note: native audio bypasses UE's audio system, so the Master Volume setting won't affect it (use `SetNativeVolume` later, or switch to a MediaSoundComponent on an actor in LV_MainMenu once SoundClasses exist — that's the route that respects the mixer).
- **60 FPS cap game-wide**: `BP_EE_SettingsSave` default `FrameRateLimit` changed 0 → **60**; DefaultEngine.ini adds `[/Script/Engine.GameUserSettings] FrameRateLimit=60` + `bSmoothFrameRate=False` as belt-and-braces. Verified in PIE: `t.MaxFPS = 60` after GameInstance Init. Players can still change it in Options (it re-saves), but every fresh install starts at 60.

### Known quirks / polish backlog
- Options rows currently overhang the green banner's inner area at some aspect ratios — cosmetic, revisit when the panel becomes a proper content frame for Character Select.
- A stray-input episode during one PIE run (likely automation keys landing in the game viewport) wrote junk settings; the .sav was deleted — next launch recreates it from proper defaults.
- Dropdown option lists live on each row instance (designer-editable `Options` array).
