# Eucalyptus Edge — Project State

> Maintained as the current source of truth for Claude and Unreal MCP work.
> Last updated: **2026-07-16**

**Game:** Family-friendly UE 5.8 3D weapon-based arena fighter, Blueprint-only.  
**World:** Verdantia  
**Tagline:** **Cute Fighters. Serious Skills.**  
**Primary presentation references:** Monster Hunter World, Tekken 8, Super Smash Bros.  
**Current engine:** Unreal Engine 5.8

---

## PERFORMANCE STANDARD (Permanent Engineering Requirement — 2026-07-16)

Performance is a core engineering requirement for all future development.

**Targets**
- 60 FPS locked during gameplay. Combat is the highest priority; Character Select also targets 60 FPS.
- Future 120 FPS support is optional and must never change gameplay timing.

**Engineering rules**
- Gameplay must remain frame-rate independent. Never base combat logic on rendered frames.
- Use Delta Time, Animation Notifies, Timers, and Montages.
- Hit windows must be animation-driven, not frame-count driven.
- Movement must never assume a specific FPS.

**Performance priority (highest → lowest)**
1. Combat responsiveness
2. Stable frame pacing
3. Animation quality
4. VFX
5. Shadows
6. Post processing
7. Background foliage density

If performance drops below 60 FPS, reduce visual quality before sacrificing gameplay responsiveness.

**Vertical Slice requirement:** the Wren vs Ripper demo is not complete unless combat holds a stable 60 FPS, the camera stays smooth, ring-outs stay smooth, Edge Energy stays smooth, and there is no noticeable hitching during combat.

Current enforcement already in place: `t.MaxFPS 60` via `BP_EE_SettingsSave` default + `DefaultEngine.ini` (`FrameRateLimit=60`, `bSmoothFrameRate=False`); combat logic is event/notify/timer-driven (no frame counting); Character Select environments are lightweight streamed Level Instances.

---

## Canonical Phase 1 Roster

The project currently has seven modeled base fighters:

1. Koda the Koala
2. Wren the Kangaroo
3. Ripper the Tasmanian Devil
4. Kiri the Kookaburra
5. Echo the Platypus
6. Banjo the Sugar Glider
7. Atlas the Emu

### Secret unlockable fighter

8. **Sonia the White Tigress** — secret unlockable fighter and teaser for the future regional DLC direction.

Sonia must:
- remain hidden or locked in the normal roster until her unlock condition is met
- use white tiger fur with orange-and-gold clothing accents
- use Twin Crescent Chakrams
- appear in roster data now, but not as a normal immediately available fighter
- have a configurable secret/unlock flag rather than being hard-coded into UI visibility

**Removed or archived:**
- Mako is permanently removed from the franchise.
- Bindi is cut.
- Bramble and Tazra are archived concepts and are not part of the active game roster.

Claude must not restore obsolete roster entries from older GDD revisions or old folders.

**Current model-folder check:** All seven canonical fighter model folders are present: Atlas, Banjo, Echo, Kiri, Koda, Ripper, and Wren. No active-roster fighter is missing.

---

## Canonical Arena Roster

The current canonical Verdantia arena roster is:

1. **Eucalyptus Summit** — ancient mountain sanctuary
2. **Crystal Caverns** — underground crystal shrine
3. **Bamboo Harbor** — peaceful riverside village and docks
4. **Frostpine Ridge** — frozen mountain pass
5. **Sunbaked Outback** — harsh golden-red desert arena
6. **Moonlit Rainforest** — dense magical rainforest at night
7. **Edge Festival Colosseum** — Verdantia championship arena
8. **Blightroot Hollow** — corrupted root-choked hollow shaped by the Blight

**Canon correction:**  
`Red Dune Outpost` and `Sunbreak Outback` are obsolete names. The correct arena name is **Sunbaked Outback**.

Arena canon and implementation status are separate:
- An arena may be canonical even if its UE level is not built yet.
- Existing meshes or concept art do not automatically mean a playable map exists.
- Claude must not remove an arena from canon merely because its level asset is missing.


---


## Canonical Arenas

Current named arenas and regions include:

- Eucalyptus Summit
- Crystal Caverns
- Bamboo Harbor
- Frostpine Ridge
- Sunbaked Outback
- Edge Festival Colosseum
- Moonlit Rainforest
- **Blightroot Hollow** — the newest Blight-corrupted arena concept

Blightroot Hollow is a future arena/environment and must remain part of the project canon. It represents Verdantia overtaken by the Blight, with corrupted roots, purple crystal growth, black smoke, twisted vegetation, and dangerous ring-out terrain.

---

## First Playable Matchup

The first end-to-end combat target is now:

```text
Wren vs. Ripper
Arena: Eucalyptus Summit
```

Reason:
- Wren already has her boxing gloves integrated into the current model.
- Ripper already has his claw weapons integrated into the current model.
- Neither fighter is blocked on separate weapon modeling.
- This makes them the fastest pair for validating combat, animation, camera, health, ring-out, and victory flow.

Koda vs. Ripper is no longer the first implementation target.

For the first playable slice:
- Player 1 defaults to Wren.
- Player 2 or CPU defaults to Ripper.
- Use Eucalyptus Summit as the first arena.
- Placeholder or retargeted animations are acceptable initially.
- The match must prove movement, light/medium/heavy attacks, block/dodge foundation, health, ring-out, and win state.

---

## Current Milestone

# M2 — Dynamic Character Select

The Main Menu foundation is functional. The next milestone is a dedicated, cinematic Character Select experience.

The current Character Select placeholder panel inside `WBP_MainMenu` is temporary and incorrect as the final design. It must be removed once the dedicated Character Select flow is working.

The defining feature of Character Select is:

> As a player highlights a fighter, the camera glides through Verdantia to that fighter's physical showcase location in the world.

This is not a popup, not a static modal, and not a single stationary preview mannequin.

---

## Final Front-End Flow

Only three major full-screen front-end states are planned:

```text
1. Main Menu
2. Character Select
3. Mode Select
```

Supporting choices should use overlays or popups where appropriate.

Canonical flow:

```text
Main Menu
→ Play
→ Dynamic Character Select
→ Mode Select
→ Arena Select popup
→ Loading transition
→ Match
```

### Main Menu buttons

```text
Play
Lore
Options
Credits
Exit
```

Remove the obsolete `Local Versus` button from the Main Menu.  
Do not add a separate `Characters` button.

### Character Select responsibilities

- Player 1 is active by default.
- Player 2 can press Start on a second controller to join.
- Each active player navigates and confirms independently.
- Character portraits are data-driven.
- Highlighting a portrait updates the character information and moves the camera to that fighter's showcase point.
- Confirming triggers a character-specific confirmation pose or animation.
- Continue is enabled only when all active players are ready.
- Duplicate-character selection must be configurable rather than hard-coded.
- Secret/locked roster entries must remain discoverable through data without appearing as normal unlocked choices.
- Sonia must be present in roster data as locked/secret.

### Mode Select choices

After character confirmation:

```text
Training
Versus CPU
Local Versus
Online Battle
```

For Phase 1, Online Battle may be visible but disabled as coming later.

### Arena Select

Arena selection should be an overlay/popup over Mode Select rather than another full-screen front-end screen.

---

## Completed Work

- [x] UE 5.8 project migration.
- [x] `LV_MainMenu` configured as Editor Startup Map and Game Default Map.
- [x] `BP_EE_MainMenu` GameMode and `BP_EE_MenuController`.
- [x] `WBP_MainMenu` creation and display.
- [x] UI-only input mode and valid PlayerController connection.
- [x] Mouse cursor visibility.
- [x] Controller focus begins on the Play button.
- [x] Main Menu art states: idle, hover, pressed, disabled.
- [x] Main Menu logo, Cinzel display font, Inter body font.
- [x] Main Menu video background pipeline:
  - `EE_MenuMediaPlayer`
  - `EE_MenuMediaTexture`
  - `M_EE_MenuVideo`
  - `IMG_VideoBG`
- [x] Options framework and persistent settings:
  - `BP_EE_SettingsSave`
  - `BP_EE_GameInstance`
  - reusable slider/check/dropdown rows
- [x] Quit confirmation modal.
- [x] Main Menu music: `WAV_Menu_Loop` (Path of Adventure pack, 96 s loop, SoundGroup Music, bLooping) spawned at 0.7 volume in WBP_MainMenu Construct, layered under the video's native ambience. The pack's `WAV_Battle_Loop`/`WAV_BossBattle_Loop` are earmarked for the arena. Volume is a raw multiplier until SoundClass/SoundMix assets exist for the Options mixer.
- [x] Credits and Options panel foundation.
- [x] Default 60 FPS cap.
- [x] Main Menu project organization under `/Game/EE_ProjectFiles/`.
- [x] All seven canonical fighter model folders now exist: Atlas, Banjo, Echo, Kiri, Koda, Ripper, and Wren. Wren and Ripper are the first combat pair because their weapons are already integrated. Claude must still verify exact live asset paths, skeletons, physics assets, materials, and animation readiness before binding them.

### Vertical Slice v0.1 — minimum flow (2026-07-16, PIE-verified end-to-end)

Full loop works: **Main Menu → Play/Local Versus → Character Select (Wren/Ripper) → Fight → LV_EucalyptusSummit → match → KO or ring-out → Results → Rematch / Character Select / Main Menu.** Both winner directions verified; Rematch, back-to-select, and back-to-menu all verified in PIE.

- [x] **Character Select (interim, functional)** — `/Game/EE_ProjectFiles/CharacterSelect/`:
  - `Level/LV_CharacterSelect` (stripped duplicate of Lvl_ThirdPerson): Wren + Ripper preview SkeletalMeshActors on a lit stage, fixed `CharSelectCamera`, GameMode override set.
  - `Blueprints/BP_EE_CharSelectGameMode` (SpectatorPawn) + `BP_EE_CharSelectController` (view target → camera, creates widget, UI-only input + cursor).
  - `Widgets/WBP_EE_CharacterSelect`: Verdantia-styled bottom band — 7 roster buttons (Wren/Ripper selectable, Koda/Kiri/Echo/Banjo/Atlas visible-but-LOCKED/disabled), selection readout, BACK → main menu, FIGHT! → arena. Selection stored in `BP_EE_GameInstance` (`SelectedFighterP1/P2` Name vars + `bP2IsAI`); P2 auto-set to the non-chosen fighter.
  - This is **not** the final M2 cinematic Character Select — it is the minimum functional stand-in; camera-travel showcase design still pending.
- [x] **Combat framework** — `/Game/EE_ProjectFiles/Combat/` (template untouched; all EE work in child/new classes):
  - `BP_EE_Fighter` (child of `BP_CombatCharacter`): `FighterName`, `RingOutZ` (−400, instance-editable), `bIsKOd`; Tick ring-out check (Z below threshold → eliminated); `HandleDeath` override (ragdoll + hide lifebar + report to GameMode, no respawn/destroy); `EEStrike` custom event (own sphere trace 250uu/r100 Pawn-only → ApplyDamage MeleeDamage) fired by IA_ComboAttack and by the AI.
  - `BP_EE_Wren` / `BP_EE_Ripper` children with their skeletal meshes (AnimationSingleNode mode — no retargeted anims yet, fighters are unanimated).
  - `BP_EE_VersusGameMode`: BeginPlay reads GameInstance selections → `SpawnFighterAt` at PlayerStart 0/1 → possess P1 (`BP_EE_MatchPlayerController` adds IMC_Default/MouseLook/Combat) + spawn `BP_EE_MatchAIController` for P2 → wires `BP_EE_MatchCamera` (Tick: frames both fighters, distance-scaled) → `OnFighterEliminated(Loser)` shows results once.
  - `BP_EE_MatchAIController`: chase target until ~200uu, face target, strike every 1.2s. Architecture keeps P2-as-human clean (swap AI controller for a second player controller).
  - `Widgets/WBP_EE_Results`: parchment panel, `SetWinner(Name)` → "WREN/RIPPER WINS!", REMATCH / CHARACTER SELECT / MAIN MENU (controller-focusable).
- [x] **LV_EucalyptusSummit (first playable arena)** — `Maps/LV_EucalyptusSummit/LV_EucalyptusSummit`: Main_Platform mesh scaled ×12 (top ≈ Z 67), two PlayerStarts at ±280, MatchCamera, GameMode override, sky/light/fog kept from template level, no safety floor (falls ring out below Z −400).
- [x] Main Menu `Play_btn` and `Local_Versus_btn` now Open Level → LV_CharacterSelect (OnPlayRequested dispatcher still fires; all other menu behavior untouched).

### Character Select presentation pass (2026-07-16, PIE-verified end-to-end)

The flat lineup was replaced with the in-world presentation concept. All v0.1 selection/match/results logic is unchanged underneath.

- [x] **Per-fighter streamed environments** (canon architecture): `Level/LVI_CS_Wren` (Edge Festival training terrace — warm spot, banners, eucalyptus trees, braziers, training-post placeholders) and `Level/LVI_CS_Ripper` (rough combat pit — broken/tilted wood, tipped brazier, dead tree, red accents, distant purple Blight glow), each a lightweight non-WP level placed in `LV_CharacterSelect` as a **Level Instance** actor (tags `ENV_Wren` / `ENV_Ripper`). Future fighters follow the same pattern (`LVI_CS_<Name>`). Both stay loaded in Phase 1 (tiny prop sets, 60 FPS safe); per-highlight hide/unload is a later optimization.
- [x] **Camera flow**: 5 tagged CameraActors (`CSCam_Overview`, `CSCam_Wren`, `CSCam_WrenClose`, `CSCam_Ripper`, `CSCam_RipperClose`). Controller resolves them by tag on BeginPlay and flies with `Set View Target with Blend` (cubic, 0.9 s highlight / 0.5 s lock-in push / 1.0 s return). Overview on entry.
- [x] **Highlight ≠ confirm**: roster row now navigates the 3D world. Highlight → camera flight + "WREN — Disciplined Counter Boxer" / "RIPPER — Wild Pressure Brawler" + CONFIRM appears. CONFIRM → GameInstance write + close-cam push + FIGHT revealed. BACK: confirmed → highlighted → overview → Main Menu (all four states PIE-verified).
- [x] **Rotation fix** at preview-actor level only: both fighters face their presentation cameras at world yaw +90 (mesh native forward is +Y, matching the Manny component convention used in combat). Arena spawn rotations untouched.
- [x] **Idle motion (placeholder)**: `EE_Seq_WrenIdle` / `EE_Seq_RipperIdle` Level Sequences auto-play looping actor-transform idles (calm 2 s bob/sway for Wren; faster, twitchier 1.33 s bob/swing for Ripper). These are placeholders until real skeletal idles exist (see Wren section below).

### Wren clean reimport (2026-07-16)

- [x] Corrected `WrenKangaroo.fbx` (Claude Desktop's Blender fix, exported 2026-07-16 04:00) validated in a temp import: **129 bones**, `tail_01–tail_07` + `ctrl_tail_root/mid/tip` + `TailPlant_IK`, Manny-convention names incl. `ik_hand_*`/`ik_foot_*`, **exactly 175 cm**, feet at Z=0, scale 1.0, no import rotation, no stretching.
- [x] Promoted as production: `Characters/WrenKangarooModel/WrenKangaroo` (+ `_Skeleton`, `_PhysicsAsset` from the same corrected import). `BP_EE_Wren` and the Character Select preview repointed; no mesh-component scale compensation anywhere (template's standard −90° yaw / −90 Z offset retained — correct for this skeleton).
- [x] The pre-correction assets were removed during Trevor's own reimport; `BP_EE_Wren`'s stale (None) mesh pointer was the "poisoning" and is fixed.
- [ ] **Morph targets: the corrected FBX contains none** (verified via two import paths). Facial morphs need to be re-exported from Blender with shape keys enabled — work order + export gotchas written up in `CLAUDE_DESKTOP_HANDOFF.md`.
- [ ] **Retarget set NOT yet generated** — IK Rig / IK Retargeter assets cannot be created through MCP tooling, and the Content Browser "Retarget Animations" dialog is not reachable by UI automation. **One manual editor step remains:** select `MM_Idle`, `MF_Unarmed_Walk_Fwd/Bwd/Left/Right`, `MM_HitReact_Front_Lgt_01`, `MM_HitReact_Front_Hvy_01`, `MM_Death_Front_01`, `MM_Death_Back_01`, `MM_Dash` → right-click → Retarget Animations → target `WrenKangaroo` → export to `Characters/WrenKangarooModel/Anims` with `Wren_` prefix. Claude can then wire idle/locomotion/reactions. Note: **block, get-up, and victory animations do not exist in the template** — those need bespoke or store animations.
- Cleanup note for Trevor: `Characters/WrenKangarooModel/ImportClean/` holds load-locked duplicate skeleton/physics/texture orphans from the repair — safe to delete in-editor.

**What remains after v0.1 (not started / unchanged):**
- Fighters are unanimated (single-node ref pose; no IK Rigs/Retargeters yet) — retargeting or bespoke anims is the next combat-feel step.
- Only the simple `EEStrike` attack works on Wren/Ripper skeletons (template montage combos require Manny skeleton); block/dodge/Edge Energy/lock-on/rounds not built.
- Local Versus P2 (second controller) not implemented — AI stands in; architecture ready.
- Match HUD is the template over-head lifebars only; no round intro/announcer/audio.
- Main Menu cleanup deferred: `Local_Versus_btn` → `Lore_btn` rename and removing the internal `P_CharSelect` placeholder panel.
- M2 cinematic Character Select (camera travel, showcase points, P2 join, Mode Select) still the real milestone; the interim screen should be replaced, not extended.

---

## Main Menu Corrections Required

The present widget still contains legacy work from the earlier menu plan.

Required cleanup:

- [ ] Rename/replace `Local_Versus_btn` with `Lore_btn`.
- [ ] Remove the Character Select placeholder from the Main Menu's internal `WidgetSwitcher`.
- [ ] Make Play transition to the dedicated Character Select state or level.
- [ ] Preserve Options, Credits, and Quit modal behavior.
- [ ] Do not rebuild the working Main Menu from scratch.
- [ ] Retain the existing video background, settings framework, fonts, button art, and focus handling.

The Main Menu should remain visually minimal:

```text
Play
Lore
Options
Credits
Exit
```

---

## Required Character Select Architecture

Preferred content structure:

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

A single equivalent full-screen state inside a front-end shell is acceptable only if it preserves the same dedicated cinematic experience and does not behave like a popup.

### Character data fields

Each roster entry should expose:

```text
Character ID
Display Name
Role / Fighting Style
Weapon Name
Portrait
Signature Color
Skeletal Mesh or Character Blueprint
Showcase Point ID
Showcase Camera / Camera Target
Idle Animation
Attention Animation
Confirm Animation
Unlock State
```

Do not hard-code a long chain of character-specific branches when a struct, Data Asset, or Data Table can drive the roster.

---

## Dynamic Camera Rules

When a fighter is highlighted:

1. Read the selected character entry.
2. Update name, role, weapon, portrait, and player focus color.
3. Resolve that fighter's `BP_EE_CharacterShowcasePoint`.
4. Glide or blend the camera to the corresponding view.
5. Trigger the fighter's attention/idle response.

Initial camera blend target:

```text
0.6–1.0 seconds
```

Camera movement should be:

- smooth
- cinematic
- readable
- controller-responsive
- never shaky
- fast enough that roster navigation does not feel sluggish

The camera should make Verdantia feel like one connected living showcase environment.

---

## Local Player Join Rules

- Player 1 exists by default.
- Player 2 joins with Start/Menu on a second controller.
- Each local player must have separate focus, selected character, confirmation state, and input ownership.
- Do not let one physical device control both players.
- Controller support is the priority.
- Mouse support can remain for Player 1.
- The interface must clearly communicate:
  - Press Start to Join
  - Selecting
  - Ready
  - Back / Cancel

---

## First Playable Fight Target

The first playable combat matchup is now:

```text
Wren vs. Ripper
Arena: Eucalyptus Summit
```

Reason:

- Wren already has her Verdantia boxing gloves integrated into the model.
- Ripper already has his claw weapons integrated into the model.
- Both can enter the combat pipeline without waiting for separate weapon modeling or attachment work.
- This makes them the fastest pair for validating movement, camera, hit reactions, light/medium/heavy attacks, defense, Edge Energy hooks, ring-outs, and local-versus flow.

Koda is no longer the required first combat test opponent. He remains part of the active roster and can follow once his staff pipeline is ready.

---

## Current Combat Foundation

The project still uses Epic's Fighting/Combat Variant as a foundation.

Useful template systems:

- free 3D CharacterMovement
- light combo montage
- charged/heavy attack montage
- melee sphere traces
- health and life bar
- damage interfaces
- hit reactions
- AI foundation

Still required for Eucalyptus Edge:

- lock-on camera
- block
- dodge/parry framework
- Edge Energy
- local Player 2 spawning/input
- round state
- ring-out state
- victory flow
- character-specific combat
- retargeting or custom animation setup

Do not destructively modify the original template assets. Duplicate them into `/Game/EE_ProjectFiles/Combat/` before Eucalyptus Edge-specific changes.

---

## Known Issues and Constraints

- XAMPP uses port 8000. Launch UE through the project development launcher using MCP port 8765.
- The menu MP4 should eventually live in `Content/Movies/` or be included through packaging settings.
- Native MediaPlayer audio currently bypasses the normal SoundClass mixer.
- Some Options rows need responsive-layout polish.
- Real UMG fade/slide animations still require a manual editor pass.
- Final fighter asset paths and rig status must be re-audited in the live UE 5.8 editor before implementation.
- Missing final animations must not block architecture: use temporary poses or mannequins at showcase points until the real assets are ready.

---

## Immediate Next Task

The Vertical Slice v0.1 flow, the in-world Character Select presentation, and the Wren reimport are done (2026-07-16, see Completed Work). Next steps, in rough order:

1. **Claude Desktop (Blender side):** work orders in **`CLAUDE_DESKTOP_HANDOFF.md`** — Wren re-export WITH shape keys (current FBX has zero morph targets), source-authored idle takes for Wren (boxing) and Ripper (aggressive), and the template-gap animations (block, get-up, victory, defeat).
2. **Manual (Trevor, ~5 min):** run the Retarget Animations dialog for the 10 Manny anims listed in the Wren section (MCP tooling can't reach it). Then Claude wires idle/locomotion/hit-react/knockdown/defeat onto Wren. (Skippable for any motion Claude Desktop authors natively.)
3. Combat feel: montage-driven attacks on the EE skeletons, block/dodge foundation, knockback tuning (frame-rate-independent per the Performance Standard).
4. Local Versus Player 2 (second controller) replacing the stand-in AI.
5. Character Select polish toward full M2: data-driven roster, per-highlight environment show/hide-unload, lock-in character reaction anims, P2 join, Mode Select.
6. Main Menu cleanup: rename `Local_Versus_btn` → `Lore_btn`, remove the internal `P_CharSelect` placeholder panel.
7. Proper match HUD (fixed health bars, round state) and Eucalyptus Summit environment dressing.
