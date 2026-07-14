# PHASE1_AUDIT.md — Eucalyptus Edge (UE 5.8, Blueprint-only)
**Read-only audit · 2026-07-14 · via unreal-mcp against the live editor**

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
| Ripper | `Characters/TasModel/RipperTas` — **StaticMesh only** (Tripo export; not usable as a fighter until skeletal FBX import) |
| Atlas / Banjo | `Characters/AtlasEmuModel/` is an empty folder (intentional); Banjo has no folder. No meshes in-project |
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
- **Event graph is empty** — zero button handlers, no panels, no animations, no video layer, no scrim. Note: the button column is Play / **Local Versus** / Options / Credits / Exit — the briefing's M1 list says "Lore", which does not exist in the widget.

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
| Fighter | Mesh | Skeleton | Status |
|---|---|---|---|
| Koda | RiggedKoda | RiggedKoda_Skeleton | ✅ imported |
| Kiri | RiggedKiri | RiggedKiri_Skeleton | ✅ imported |
| Echo | RiggedEcho | RiggedEcho_Skeleton | ✅ imported |
| Wren | WrenKangaroo | WrenKangaroo_Skeleton | ✅ imported |
| Ripper | RipperTas (**StaticMesh**) | — | ❌ needs skeletal FBX (Blender resize → AccuRig → re-import) |
| Atlas | — (empty folder, intentional) | — | ❌ pending FBX |
| Banjo | — | — | ❌ pending FBX |
| Template | SK_Mannequin, SKM_Manny_Simple, SKM_Quinn_Simple | UE5 Mannequin | ✅ |

**IK Rig / IK Retargeter assets: none in project.** Each EE fighter has its own skeleton — retargeting the Mannequin combat anims (or bespoke anims) onto RiggedKoda/RipperTas skeletons will need IK Rigs + Retargeters (or AnimBP duplication per skeleton).

---

## 6. Milestone status (M1–M5)

| Item | Status | Evidence |
|---|---|---|
| **M1 Main Menu** | | |
| Play/Lore(=Local Versus)/Options/Credits/Exit wiring | **Missing** | WBP_MainMenu event graph empty |
| Widget animations | **Missing** | none in WBP_MainMenu |
| Controller navigation | **Missing** | no focus/navigation setup; SetInputModeUIOnly without focus widget |
| Transitions (panels) | **Missing** | no panels exist |
| Button sounds | **Missing** | no audio assets in /Game at all |
| Input locking during transitions | **Missing** | n/a yet |
| Focus handling | **Partial** | UI-only input mode + cursor set in BP_EE_MenuController BeginPlay; no initial button focus |
| Animated MP4 background | **Missing** | FileMediaSource `EE_Background` exists; **no MediaPlayer/MediaTexture/material; no video layer in widget** |
| **M2 Character Select** | | |
| Screen / roster data / P2 join / portraits / ready-up | **Missing** | no assets found |
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

## 7. Shortest path to Koda vs. Ripper playable in Eucalyptus Summit
1. **Create `LV_EucalyptusSummit` map** under `/Game/EE_ProjectFiles/Maps/LV_EucalyptusSummit/` using the existing `Main_Platform` mesh + GoodSky/lighting, with two PlayerStarts and a blocking-volume perimeter → falls = ring-out zone below.
2. **Duplicate `BP_CombatCharacter` → `BP_EE_Fighter`** (keep template combat intact); child it twice (`BP_EE_Koda`, `BP_EE_Ripper`); assign RiggedKoda / (new skeletal) Ripper meshes with retargeted or placeholder Mannequin AnimBP.
3. **Ring-out volume**: adapt the `BP_Combat_LavaFloor` overlap pattern into `BP_EE_RingOutVolume` — on fighter overlap, declare the other fighter the winner instead of applying damage.
4. **Versus GameMode**: `BP_EE_VersusGameMode` — spawn P1 + P2 (second local player, splitscreen already enabled in DefaultEngine.ini) or P1 vs. dummy AI (`BP_Combat_Dummy`) for the first capture; simple round state: fight → HP 0 or ring-out → win screen widget → restart.
5. **Wire Play → Character Select → LV_EucalyptusSummit** flow (M1→M2 handoff), or for the very first capture, `Open Level LV_EucalyptusSummit` directly from Play.

**Biggest unplanned gap**: no IK Rig/Retargeter assets — the moment RiggedKoda needs the template's combat montages, retargeting setup (Mannequin → Koda skeleton) becomes the critical path. Ripper has no skeletal mesh at all yet (Blender/AccuRig workflow pending).
