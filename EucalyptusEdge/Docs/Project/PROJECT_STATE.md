# Eucalyptus Edge — Project State

> Maintained as the current source of truth for Claude and Unreal MCP work.
> Last updated: **2026-07-17**

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
- [x] Main Menu music: `WAV_Menu_Loop` (Path of Adventure pack, 96 s loop, SoundGroup Music, bLooping) spawned at 0.7 volume in WBP_MainMenu Construct, layered under the video's native ambience. The pack's `WAV_Battle_Loop`/`WAV_BossBattle_Loop` are earmarked for the arena. (Sprint 2: submix routing + live volume sliders now exist — see Sprint 2 section.)
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

### Sprint 2 — Combat anims via compatible skeletons, full audio pass, themed select stages, select cinematics, Niagara (2026-07-16)

- [x] **Combat animations (no retarget set needed for the slice):** `SK_Mannequin` (template skeleton) added to **CompatibleSkeletons** on `WrenKangaroo_Skeleton` and `Ripper_Tas_Skeleton`; `BP_EE_Wren`/`BP_EE_Ripper` mesh components switched from empty AnimationSingleNode (T-pose) to **AnimationBlueprint** mode running the template `ABP_Manny_Combat`. PIE-verified: fighters idle and locomote in the arena (AI Ripper walks in and wins vs. an idle player, exactly as v0.1 logic dictates); Wren's guard idle verified in the select close-up. Bones map by name — Wren matches 71/161 Manny bones (tail/extras keep ref pose), Ripper 23/161 (no twists/fingers). Template montage attacks run through the same compatibility path. The manual Retarget-Animations step is now **optional polish**, no longer a blocker.
- [x] **Audio wired end-to-end** (`/Game/EE_ProjectFiles/Audio/`): `EE_Master/EE_Music/EE_SFX` SoundClasses + `EE_MusicSubmix`/`EE_SFXSubmix` (duplicated from engine assets — MCP has no create-asset tool for these). Routing: menu = existing `WAV_Menu_Loop`; **Character Select** = `CUE_Village_Loop` (widget Construct); **Fight** = `CUE_Battle_Loop` (`BP_EE_VersusGameMode` BeginPlay); **KO** = `Breaking_Bones_01_Cue` (head of `HandleDeath`); **Ring-out** = `Mgc_Water_Throw_02_Cue` (Tick ring-out branch, before `HandleElimination`); **Victory** = `Trailer_Horns_of_War_Cue` (Results Construct); **Hover/Click** = `S_Wood_Mono_2_Cue`/`Drs_Close_Box_01_Cue` set as WidgetStyle Hovered/PressedSlateSound on all 22 buttons across MainMenu/CharacterSelect/Results (no graph or layout changes). Known-benign: `PlaySound2D` looping music logs an "orphaned sound" warning; level travel stops it. Convert to SpawnSound2D audio components later if per-track control is wanted.
- [x] **Volume sliders are live:** new `BP_EE_GameInstance.ApplyAudioSettings` (SetSubmixOutputVolume on engine `MasterSubmixDefault` + the two EE submixes from `BP_EE_SettingsSave` Master/Music/SFX values), called at the head of `ApplyAllSettings` — so it applies on game Init *and* on Options APPLY. All routed cues/waves carry the EE submix + SoundClass. *(2026-07-17: a parallel session briefly built a duplicate SoundClass/SoundMix framework at `Framework/Audio/` — unified back onto this submix system, duplicates deleted, `WAV_Menu_Loop` re-pointed to `Audio/EE_Music`; the submix approach is canonical.)*
- [x] **Themed select stages:** `LVI_CS_Wren` = Australian rocky plateau — MWAM stone outcrops ringing the terrace, grass clumps on/around the platform, warm-tinted spot/point lights + 2 orange brazier PointLights. `LVI_CS_Ripper` = blighted forest — 5 tilted/scaled eucalyptus (dead-forest cluster), stones, existing distant glow recolored **purple** (170,60,255 @ 12k), 2 extra purple corruption PointLights, 2 **LocalFogVolumes** with purple albedo (localized so Wren's stage stays clear; extinction tuned low after an opaque-purple first pass). PIE-verified from the game cameras — note the editor viewport's exposure misleads badly here; judge lighting in PIE only.
- [x] **Select cinematics:** preview actors tagged `CSPreview_Wren`/`CSPreview_Ripper` and now play **real skeletal idles** (`Wren_Idle_Boxing` native; Ripper `MM_Idle` via compatible skeleton); the transform-bob `EE_Seq_*` LevelSequences set to bAutoPlay=false (actors kept). `FlyToFighter` re-plays the fighter's idle on highlight; `FlyToClose` re-plays it at lock-in. (Tried `MM_ChargedAttack` as a lock-in pose — its root motion lunges the preview out of the close camera frame; reverted to idle.) PIE-verified: WREN → camera flight → boxing-guard idle → CONFIRM ("LOCKED IN") → close push → FIGHT!.
- [x] **Niagara set dressing:** `NS_leaf` ×2 drifting leaves over Wren's terrace; `NS_Sparkling_Glow`/`_Glow_2`/`_Noise` as purple corruption motes in Ripper's grove. PIE-verified visible from the overview and close cams. (No true rain system exists in the imported packs — LocalFogVolumes + motes carry the weather mood for now; a real NS rain system is a future import.)

**⚠ Mid-sprint collision (mitigated; final fix waits on Blender re-export):** while Sprint 2 was running, a parallel session renamed `TasModel/Ripper_Tas` (+skeleton) to `Ripper_Tas_original_backup` and attempted to reimport a new `RipperModel/Ripper_Tas.fbx`, which **failed** ("nothing to import…"), and imported `TasModel/Animations/Ripper_Idle_Aggressive` **without a skeleton** (asset-check error). This nulled the mesh pointers on the Ripper select preview and the `BP_EE_Ripper` CDO. **Mitigation applied same day:** both re-pointed at `Ripper_Tas_original_backup` (whose skeleton carries the SK_Mannequin compatibility edit), so Ripper displays and fights again. When a good re-export lands (work order in `CLAUDE_DESKTOP_HANDOFF.md` rev 2): (1) import at the original `TasModel/Ripper_Tas` name, (2) add `SK_Mannequin` to the new skeleton's CompatibleSkeletons, (3) re-point `BP_EE_Ripper` + the select preview from the backup to the new asset, (4) rebind `Ripper_Idle_Aggressive` and swap it in as Ripper's select idle.

**Same-day rendering fixes after Trevor's playtest feedback:** Wren's "partially invisible" select preview was overexposure — `LVI_CS_Wren`'s PointLight_0 sat *inside* the character (now intensity 0) and the presentation spot was far too hot (now 1200, soft warm 255/214/170). PIE-verified: Wren's close-up reads clean (armor, guard pose, falling leaves). Ripper preview restored via the backup re-point above.

### Match HUD v1 — Soulcalibur-style screen-space HUD (2026-07-16 evening, PIE-verified)

`Widgets/WBP_EE_MatchHUD`, created by `BP_EE_VersusGameMode.CreateMatchHUD` (new function, called at the end of BeginPlay after both fighters + camera are wired). All text uses the **Verdantia** font pack (`Framework/Fonts/Verdantia_Font`).

- [x] **Layout** (per Trevor's mock): WREN / RIPPER name plates top-left/top-right (names resolved from GameInstance selections at Construct), two mirrored 640px health bars (P1 fills right-to-left, P2 left-to-right, green), thin cyan **EDGE** meters + labels below each bar, center **round timer** (Verdantia 56) with **ROUND 1** beneath in gold.
- [x] **Live health**: HUD Tick polls `Current HP / Max HP` on both fighters (`FighterP1/P2` instance-editable refs set by the GameMode before AddToViewport). PIE-verified draining as the AI lands hits.
- [x] **Match intro**: READY… (1.2 s) → **FIGHT!** (0.8 s) → clear, driven by a Tick-accumulated IntroTime (no latent nodes). Big gold Verdantia center text. PIE-verified.
- [x] **Round timer**: counts 60 → 0 after the intro; at 0 the lower-HP fighter is eliminated via `HandleElimination` (tie eliminates P1/awards P2). *Logic in graph; the 60 s time-out path itself not yet observed in PIE (matches end in ~13 s vs the current AI).*
- [x] **Finish banner**: new HUD function `ShowFinish(Loser)` — shows **RING OUT!** if the loser fell below its RingOutZ, else **K.O.!** — called from `OnFighterEliminated`. Known polish item: the Results panel appears the same frame and covers the banner; the banner needs a beat (~1.5 s) before Results, which wants the results call moved out of the function graph (latent Delay not allowed there).
- [x] **Floating over-head lifebars hidden**: `BP_EE_Fighter` BeginPlay now hides the template LifeBar widget component (template untouched; per the roadmap these are replaced, not polished).
- Not yet: Edge Energy meters are visual placeholders (system doesn't exist), no round system beyond the ROUND 1 label, and the temporary event overlays (combo counter, COUNTER, PERFECT, GUARD CRUSH, EDGE ULTIMATE READY) are future work on the same widget.

### HUD v1.1 + finish presentation + locked roster platforms (2026-07-16 late, PIE-verified, all 12 gameplay/UI Blueprints compile clean)

- [x] **HUD portraits (placeholder)**: `Img_PortraitP1/P2` — 96×96 dark framed squares flanking the name plates (names/health/EDGE shifted outward to fit). Swap their brushes for real portrait textures when art exists.
- [x] **Winner banner**: `Txt_WinnerBanner` (Verdantia 54, gold) — `ShowFinish` now shows **K.O.! / RING OUT!** plus **WREN WINS! / RIPPER WINS!** beneath it the moment a fighter is eliminated.
- [x] **Delayed results = ring-out camera hold**: `OnFighterEliminated` refactored — sets `WinnerName` (new GameMode var), fires the HUD banner, then `SetTimerByFunctionName → ShowResults` (new function: creates/populates the Results widget) after **1.8 s**. During that beat the match camera keeps framing both fighters, so a ring-out loser is tracked falling before the panel appears. (Latent `Delay` nodes are unavailable to MCP graph writes — the timer-to-function pattern is the sanctioned equivalent.)
- [x] **Ring-out behavior notes**: KO already triggers only at the kill plane (fighter Tick: Z < RingOutZ = −400, the \"kill volume\" equivalent); airborne fighters play the template falling state through `ABP_Manny_Combat` (CharacterMovement falling drives it — no extra wiring). Bespoke Launch/Falling/Land takes remain ordered from Blender (handoff WO4).
- [x] **Locked-roster presentation platforms**: 5 individual `Main_Platform` (×3.5) platforms in an arc behind the hero stages in `LV_CharacterSelect` — Koda, Kiri, Echo, Banjo, Atlas — each with its fighter's skeletal mesh rendered as a **black silhouette** via new `CharacterSelect/Materials/M_EE_Silhouette` (OverrideMaterials on all slots). Banjo has no model yet and uses a silhouetted `SKM_Manny_Simple` stand-in. Outliner folder `LockedRoster`, labels `EE_CS_*`. Locked buttons stay disabled; the camera only flies to Wren/Ripper.
- [x] **Wren re-verified**: renders correctly in select (post-exposure-fix) and is present + taking hits in the arena (health drains). Not always on-screen mid-match — that is the match camera's framing, i.e. roadmap item 4 (cinematic camera), not a mesh/material issue. No Blender assets touched.
- [x] **Compile gate**: WBP_EE_MatchHUD, WBP_EE_Results, BP_EE_VersusGameMode, BP_EE_Fighter, BP_EE_Wren, BP_EE_Ripper, BP_EE_MatchPlayerController, BP_EE_MatchAIController, BP_EE_CharSelectController, WBP_EE_CharacterSelect, WBP_MainMenu, BP_EE_GameInstance — all compile with no errors. Ready for Trevor's commit.

### Eucalyptus Summit enlargement + dressing v1, and asset cleanup (2026-07-16 evening, PIE-verified)

**Arena** (`Maps/LV_EucalyptusSummit`): Main_Platform scaled non-uniformly to (22.2, 22.2, 12) — walkable radius measured by trace: **710 → ~1310 uu (1.85×)**, top height unchanged (~Z 51–67, so ring-out tuning is untouched). PlayerStarts widened ±280 → ±400. Dressing v1 from existing props: 4 festival banners (rim, facing in), 4 stone braziers at cardinals with warm fire PointLights, 8 eucalyptus trees ringing the summit below the rim (canopy breaks the silhouette), 6 MWAM stone outcrops on the slope, 3 NS_leaf drift emitters. All dressing actors live under outliner folders `Arena/Dressing`, `Arena/FX`, `Arena/Lighting` with `EE_Sum_` labels. **Do not use `SM_MWAM_MountainA/B` as distant scenery** — tried three placements; they always render as sky-filling walls or broken fragments against the SkyAtmosphere. A proper backdrop (skybox or purpose-built vista meshes, e.g. from Fab) is the future answer; the clean floating-summit horizon looks intentional meanwhile.

**Cleanup done:** `/Game/Dev/` (Claude's morph-test imports) deleted; loose assets at `Maps/` root (Right_Festival_Banner + its tripo material/textures) moved to `EE_ProjectFiles/Props/Festival/` (redirectors left in place — run **Fix Up Redirectors** on `EE_ProjectFiles` when convenient).

**Pack audit (for Trevor's in-editor bulk delete — sampled reference check found no users; the CB delete dialog does the authoritative check):**

| Pack | Size | Verdict |
|---|---|---|
| `A_Surface_Footstep` | 349 MB | DELETE — footstep system, overlaps SmallSoundKit/FootstepsMiniPack, unused |
| `PWL_Light_Manager` | 235 MB | DELETE — lighting tool, unused |
| `Ambient_Music_v1` | 187 MB | DELETE — unused music (PathOfAdventure + FreeAtmos cover music) |
| `MC_Sample` | 159 MB | DELETE — emote/prop demo on its own skeleton, out of scope |
| `Free_Crawl_Animation` | 147 MB | DELETE — prone crawl set, out of scope |
| `FreeAnimsMixPack` | 386 MB | KEEP for now — Manny-skeleton `AS_Combo`/`AS_DyingFromWounds`/`AS_SwingSword` are combat-anim candidates via compatible skeletons; delete its `Demo/` + `Map/` subfolders if space matters |
| `FreeAnimationLibrary` | 181 MB | KEEP for now — counter/finisher/knockdown anims useful for combat gaps |
| `FreeModularMagicSFX` | 95 MB | KEEP — Edge Energy SFX source |
| `_SplineVFX` | 74 MB | KEEP — corruption/Blight VFX (MiasmaBoil) earmarked |
| GoodSky / FootstepsMiniPack / PCG_Spline_Tool / PCKeyboardMouseIconPack | ~30 MB total | KEEP — small, plausibly useful |
| `ThirdPerson` | 0.3 MB | KEEP — referenced by Variant_Combat blueprints |

In-use packs (do not touch): MWLandscapeAutoMaterial, PathOfAdventure, FreeAtmosGameMusic (victory sting), SmallSoundKit, FreeParticle_SoftTofu, Variant_Combat, Characters, Input, LevelPrototyping, GoodSky (sky refs).

**Fab note:** Claude cannot reach the logged-in Fab library from tooling; to upgrade the arena/stage nature dressing, add to the project from Fab (UE 5.8): a **eucalyptus/outback vegetation set** (tree + bush + fern variety), a **rock/cliff set** (the MWAM stones are snow-tinted), and a **distant-mountain/vista or skybox** pack. Once they exist under `/Game/`, Claude places them.

### Wren native animation integration — fast pass (2026-07-16 night) — EXACT PASS/FAIL

**PASS — assets & organization:** the four imports (from `KangarooModel/` FBXes, already on the production `WrenKangaroo_Skeleton`, no new skeleton) reorganized to `Characters/WrenKangarooModel/Anims/` with clean names: `Wren_Dodge_BackHop`, `Wren_Dodge_Bound_L`, `Wren_Dodge_Bound_R`, `Wren_Heavy_TailSpringDoubleKick` (+ `Wren_Idle_Boxing` moved alongside; old-path references resolve via redirectors). `bEnableRootMotion = true` on the three dodges; heavy left root-static per spec.

**PASS — critical bug found & fixed:** `BP_EE_Wren`'s CDO `SkeletalMeshAsset` had been **nulled** (collateral from a failed property-set rollback this session) — this was the real "Wren invisible in arena" bug. Restored to `WrenKangaroo`, AnimationMode=AnimationBlueprint confirmed, compiled, saved, PIE-verified spawning with mesh.

**PASS — gameplay wiring (all compiles clean, verified firing in PIE):**
- Inputs: **F** = heavy, **Q/E/C** = dodge left/right/back (polled via `WasInputKeyJustPressed` in `PollDodgeInput`, called from Wren's Tick after Parent:Tick — new InputActions/IMC mappings are not tool-editable, mappings live in a private field). Keyboard-only for now.
- `DoHeavy` / `DoDodge(Anim)` / `HeavyImpact` / `StartIFrames` / `EndIFrames` / `ClearBusy` functions on `BP_EE_Wren`; `Busy` gating verified in PIE (sets on press, auto-clears via timer — no animation lock, no re-trigger).
- **Heavy impact window:** damage fires only via `SetTimerByFunctionName → HeavyImpact` at `HeavyImpactDelay` (default **0.73 s** = the F22 impact frame), not for the whole animation. Impact = 250 uu forward sphere trace → `ApplyDamage(HeavyDamage=2)` + `LaunchCharacter` (forward × `HeavyKnockback=900` + up 320) for ring-out pressure. (Anim-notify authoring isn't exposed to MCP; the timer window is the frame-rate-independent equivalent, all values instance-editable.)
- **Dodge i-frames:** `DodgeInvulnerable` (new on `BP_EE_Fighter`) gated into `EEStrike` before ApplyDamage (Branch spliced; AI hits respect it). Window data-driven: `DodgeIFrameStart=0.08`, `DodgeIFrameEnd=0.55`, `DodgeDuration=0.7` — all tunable floats on Wren.

**FAIL — native animation playback (engine/tooling wall, root-caused):** Wren's mesh runs the shared `ABP_Manny_Combat` (compatible-skeleton setup from Sprint 2). UE 5.8 **strict-checks skeletons on every montage path**: `PlaySlotAnimationAsDynamicMontage` returns None for Wren-skeleton sequences, and `Montage_Play` returns 0 even for Manny montages (consistent with the v0.1 finding that template montage combos never played on EE skeletons). Compatible-skeleton entries exist **both directions** — montages ignore them. Dynamic-montage return is now captured in `LastMontage` for diagnosis. MCP cannot create AnimMontage assets (duplicate refused) nor Animation Blueprints, so the block is not resolvable from tooling.

**UNBLOCK (Trevor, ~3 min):** Content Browser → right-click → Animation → **Animation Blueprint**, target skeleton `WrenKangaroo_Skeleton`, name `ABP_Wren` (suggested: `Characters/WrenKangarooModel/`). In its AnimGraph: play `Wren_Idle_Boxing` → **Slot 'DefaultSlot'** → Output Pose. Save. Then Claude sets `BP_EE_Wren`'s AnimClass to `ABP_Wren` — every mechanism wired tonight (heavy + impact window, root-motion dodges, i-frames) becomes live with strict-matching skeletons, and PIE verification of travel-direction / no-double-movement completes. Trade-off until a fuller ABP exists: Wren's combat locomotion becomes the boxing idle (no walk blend).

**Not touched per spec:** Blender assets, rigs, Ripper, camera, VFX, HUD, audio.

### M2 Dynamic Character Select — Verdantia origin-world v1 (2026-07-17, PIE-verified core loop)

`LV_CharacterSelect` is no longer a flat stage: the 504 m × 504 m World-Partition landscape now hosts **one connected Verdantia with seven origin regions**, and highlight → camera-travel → showcase resolves **through data, not branch chains**. Screenshots: `Saved/Screenshots/Verdantia_M2/`.

**World layout** (anchors in uu; conceptual map honored — Kiri north, Banjo/Koda/Echo mid row, Ripper/Wren south flanks, Atlas far south):
| Region | Fighter | Anchor | Elevation |
|---|---|---|---|
| Ancient Eucalyptus Sanctuary (heart of Verdantia) | Koda | (0, 0) | ground, carved stone training circle |
| Sunlit Grassland Rise | Wren | (−5000, 7000) | ground — existing festival-terrace LVI moved intact |
| Tasmanian Woodland Hollow | Ripper | (−5000, −7000) | ground — existing pit LVI moved intact |
| High Canopy Wind Perch | Kiri | (11000, 0) | stage ≈ Z 330 atop boulder outcrop, open sky behind |
| Crystal Wetland Shrine | Echo | (4000, 9000) | stone shelf over a real water plane (fighter stays dry) |
| Upper Canopy Hideout | Banjo | (4000, −9000) | stage ≈ Z 140 on rock pillar amid ×7-scaled eucalypts |
| Windswept Outback Escarpment | Atlas | (−11000, 0) | mesa ≈ Z 120, red-rock materials, 4 distant mesa silhouettes |

- Landscape material: new `CharacterSelect/Materials/MI_EE_VerdantiaLandscape` (instance of the MWAM MountainRange example; `MW_UseSnow` off, snow scalars zeroed, grass correction warmed). Original Fab assets untouched — everything is instances/overrides.
- Dressing v1 (~100 actors, outliner `Verdantia/<Region>`): Eucalyptus_Tree groves, DZ Cork Oak/Aspen woodland, GV shrubs as ferns/scrub, MWAM grass + stones, water plane with `M_Water_Ocean_2_Inst` at Echo, DesertValley red-rock overrides on Atlas rocks, transition trees along the camera corridors. Niagara: NS_leaf (Koda/Wren/Ripper/Banjo), NS_feather (Kiri), NS_Sparkling_Noise shimmer + subtle teal LocalFogVolume mist (Echo), Edge motes (Koda). One warm soft SpotLight per new stage (800–1500 cd — the Wren overexposure lesson applied). Single DirectionalLight/SkyLight/SkyAtmosphere/VolumetricCloud stack — no per-region suns. Violet check passed: a violet-reading sparkle system at Echo was removed (violet = Blight only).

**Data architecture (new):** `Blueprints/BP_EE_CharacterShowcasePoint` — instance-editable per-fighter data (CharacterID, DisplayName, FighterRole, WeaponName, OriginRegion, OriginDescription, InfoLine, SignatureColor, bLocked/bSecret/bSelectable, CameraBlendTime, ShowcaseCamera/CloseCamera/FighterActor refs, Idle/Attention/Confirm anim refs, ConfirmVFX, bPlayAnims) + functions (GetID, GetShowcaseCam, GetCloseCam, GetShowcaseBlendTime, GetInfoLine, GetIsSelectable, GetIsLocked, OnHighlighted/OnUnfocused/OnConfirmed). Seven instances placed (`EE_SP_<Name>`), each also actor-tagged with its plain CharacterID for the runtime lookup. **No Mako/Bindi/Bramble/Tazra anywhere. Sonia is not exposed** — the architecture supports a hidden entry via bSecret, and per the 2026-07-17 ruling a "???"-displayed secret row can be added when the UI-M2 widget rebuild lands.

**Controller/widget rework (all compile clean):** `FlyToFighter(ID)` resolves the showcase point by tag → `CurrentShowcase` → `SetViewTargetWithBlend` (cubic, per-fighter blend time) → `OnHighlighted`; `FlyToClose` uses the point's close camera + `OnConfirmed`; new `GetHighlightInfo`/`CanConfirmCurrent` feed the widget. Retargeting is inherently interruptible — the newest highlight simply re-targets the blend. All 7 roster buttons now highlight & travel; CONFIRM is gated by `CanConfirmCurrent` (Wren/Ripper selectable; Koda/Kiri highlight-only until their combat BPs exist; Echo/Banjo/Atlas story-locked). PIE-verified: Koda highlight travel + data info line, Wren confirm (LOCKED IN + close-cam push + FIGHT), BACK cancel restore, Koda confirm correctly denied, zero Blueprint runtime errors on the final pass.

**Fighters:** Koda `RiggedKoda`, Kiri `RiggedKiri`, Echo `RiggedEcho`, Atlas `Atlus` now show **real materials** (silhouette overrides cleared) with native `*0_Open_A_UE5` single-node idles (Atlas static — no anims exist for his skeleton). `Preview_Wren`'s mesh pointer was **nulled again** (reimport collateral) — restored, boxing idle re-set, confirm anim = `Wren_Heavy_TailSpringDoubleKick`. Ripper unchanged on `_original_backup` + MM_Idle. **Banjo = black-silhouette Manny stand-in (TEMP — no model exists in Content).**

**Known gaps / follow-ups (M2 continues):**
- P2 join / dual focus / camera-ownership policy, Mode Select destination, duplicate-pick rule — not built (widget still the single-focus interim band; FIGHT still loads the arena directly).
- No landscape-sculpt tooling in MCP — relief is mesh-built; proper cliff/vista meshes still wanted from Fab (MWAM stones are small scatter rocks, so the perch/mesa forms are modest).
- Weapon trails: no prebuilt one-shot/trail Niagara in the project; ribbon materials identified for a bespoke pass (`_SplineVFX/_GenericSource/Material/M_Vfx_RibbonBeamRay`, `MI_Basic_trail05`, `T_Vfx_trail_05`). ConfirmVFX refs left None meanwhile (guarded).
- Atlas has **no polearm mesh in-project** (`SM_WindspinePolearm` deleted in the asset churn; only `polearmTextures/` remain) — needs re-export from Blender.
- Roster buttons still carry "LOCKED" labels on the five non-slice fighters; the ??? mystery slot arrives with the gold-standard UI-M2 widget rebuild.
- Kiri/Koda/Echo/Atlas need real idle/attention/confirm takes; Banjo needs a model (work orders in CLAUDE_DESKTOP_HANDOFF.md).

### Wren "twig" deformation — root-caused and FIXED (2026-07-17, arena-PIE-verified)

**Root cause:** `BP_EE_Wren` ran `ABP_Manny_Combat` (target skeleton `SK_Mannequin`) on `WrenKangaroo_Skeleton` — and the 2026-07-16 14:08 mesh reimport had **wiped `WrenKangaroo_Skeleton.CompatibleSkeletons`** (now empty), so Manny-proportioned bone data collapsed Wren's limbs in the arena. Character Select never deformed because the preview uses AnimationSingleNode + native `Wren_Idle_Boxing`.
**Isolation:** Test A (reference pose in Eucalyptus Summit) = correct proportions → mesh/transform/skinning healthy. Test B (native boxing idle, single-node, in arena) = correct → fault is the ABP_Manny_Combat evaluation path, not the import.
**Fix (least-risk, matches the already-approved ABP_Wren v1 trade-off):** `BP_EE_Wren` CharacterMesh0 → `AnimationSingleNode` + looping `Wren_Idle_Boxing`; `DoHeavy`/`DoDodge` switched from `PlaySlotAnimationAsDynamicMontage` (returned None on Wren per the montage strict-check wall) to direct `PlayAnimation` of the native takes; `ClearBusy` now restores the looping idle. All timers/damage/i-frames/knockback logic untouched. Backup at `Combat/Backups/BP_EE_Wren_PreTwigFix_20260717`. **Rollback:** set AnimationMode back to AnimationBlueprint (AnimClass ref still on the CDO) or restore the backup.
**Validated in arena PIE:** correct proportions at intro and mid-match, combat loop → K.O. → Results all work, no new warnings. **Note:** MCP *can* now create an AnimBlueprint asset shell (`BlueprintTools.create`, parent AnimInstance) but cannot set TargetSkeleton nor author AnimGraph nodes — Trevor's 3-minute manual ABP_Wren remains the upgrade path for locomotion blending (dodge root-motion displacement also waits on it; single-node dodges play in place).

**ABP_Wren status (2026-07-17, live-verified twice):** the ABP now EXISTS (Trevor-created) at `Characters/WrenKangarooModel/ABP_Wren`, TargetSkeleton = `WrenKangaroo_Skeleton`; `BP_EE_Wren` runs it (AnimationMode = AnimationBlueprint, AnimClass = ABP_Wren_C, mesh pointer healthy). Boxing idle through the ABP is PIE-verified with correct proportions; `DoHeavy`/`DoDodge` restored to `PlaySlotAnimationAsDynamicMontage` via DefaultSlot (skeletons now match, so root-motion dodges + auto-return are live in logic). **Open:** the heavy/dodge swings are logic-verified but eyeball-pending — automation cannot press F/Q/E/C with game-viewport focus faster than the AI ends the match; a ~10-second human playtest closes it. v1 AnimGraph is idle→DefaultSlot→Output only; v2 (locomotion blendspace + state machine, editor work) is the "real locomotion" gate.
**Same-day CharSelect touch-ups:** roster labels corrected (KODA/KIRI no longer say LOCKED — they highlight but can't confirm; Echo/Banjo/Atlas keep LOCKED), auto-exposure clamped 0.9–1.1 with fast adaptation (no brightness pumping during camera travel), height fog warmed/tuned. Landscape sculpting and the UI Component Library restyle remain open (no sculpt tooling via MCP; restyle is its own UMG session).

### Combat facing + match-end freeze + production UI pass (2026-07-17, PIE-verified)

- **Fighters now face each other at spawn:** LV_EucalyptusSummit's PlayerStart at (+400) was yaw 0 (facing away); now yaw 180. Verified in PIE — Wren and Ripper square up at READY.
- **Match-end freeze:** the HUD timer was already gated on `bMatchEnded` (stops the instant ShowFinish fires — verified frozen at K.O.); the missing piece was the WORLD kept simulating under the Results panel. `BP_EE_VersusGameMode.ShowResults` now ends with `SetGamePaused(true)`. Results buttons still work while paused (verified: CHARACTER SELECT traveled correctly; fresh levels load unpaused, so no unpause step is needed). **No in-match pause menu exists yet** — pausing mid-fight (Start/Esc + menu) is still an open feature, noted below.
- **UI Component Library integration (partial by availability):** only `Buttons/Large`, `Buttons/IconRound`, `Bars/*`, and `Brand/T_UI_Logo_Lockup` were ever imported (they live at `MainMenu/UI/01_ImportToUnreal/`). The `Frames/` (IconRing rings, panels, Ring_Locked), `Ornaments/`, and FX-sprite sets from COMPONENTS.md are **not in the project and no source PNGs exist on disk** — they need re-delivery/import before the full gold-standard overlay (portrait rings, nameplate panels, ??? slot ring) can be built. Applied now, per the 2026-07-17 paradigm-synced `handoff_charselect.md` (UMG overlay over the 3D world): carved-wood Idle/Hover/Pressed/Disabled button styles on all 7 roster buttons + BACK/CONFIRM/FIGHT in `WBP_EE_CharacterSelect`, the same set on the three `WBP_EE_Results` buttons, production Health/Edge bar textures on all four `WBP_EE_MatchHUD` progress bars, and the Eucalyptus Edge logo lockup (new `Img_Logo`) top-left of Character Select. All text remains UMG Text. All widgets compile clean. Screenshots: `Saved/Screenshots/UI_Combat_Pass/`.

**What remains after v0.1 (not started / unchanged):**
- Fighter animation is template-generic via compatible skeletons (`ABP_Manny_Combat` on both). Character-specific movesets, native-authored takes (`Wren_Idle_Boxing` pattern), and the block/get-up/victory gaps remain.
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

**Queue sync 2026-07-17 (see SESSION_LOG.md for the full consolidated list):** the standing brief (`Docs/02_ClaudeCode_UE5/FOR_CLAUDE_CODE_UE5.md`) orders a **Session-1 full project audit (inspection only, per PROJECT_AUDIT.md)** before further building — warranted after multiple parallel sessions — followed by **Session-2 UI-M2** (gold-standard Character Select overlay per `handoff_charselect.md`), which is **gated on re-delivering the Frames/Ornaments/FX UI texture sets** (not in the project, no source PNGs on disk). Quick unblockers: Trevor's ~10 s F/Q-E-C playtest (ABP_Wren montage eyeball check) and the Blender work orders (Ripper re-export — current desktop FBX is a 4 KB empty file — Banjo model, Atlas polearm, showcase takes).

Roadmap set by Trevor 2026-07-16 evening after Sprint 2 review. Guiding principle: **the architecture is in place — the remaining work is presentation and gameplay polish, not restructuring. Do not polish placeholders** (the floating over-head health widgets and the temporary arena floor have served their purpose and get *replaced*, not improved). Claude Terminal stays on UE; Blender work stays with Claude Desktop.

1. ~~Fix Wren's rendering issue so both preview fighters display correctly.~~ **DONE same day** (Wren = overexposure fix; Ripper = backup mesh re-point — see Sprint 2 section). Final Ripper asset still lands via the Blender re-export.
2. ~~**Soulcalibur-style screen-space HUD**~~ **v1 DONE same day** (see "Match HUD v1" section): name plates, mirrored health bars, timer + ROUND 1, EDGE meters, READY…/FIGHT! intro, K.O./RING OUT banner, over-head widgets hidden. Remaining on this item: event overlays (combo counter, COUNTER, PERFECT, GUARD CRUSH, EDGE ULTIMATE READY), character-intro beat before READY…, banner-before-results timing, real round system.
3. ~~**Enlarge + dress Eucalyptus Summit**~~ **DONE same day** (see "Eucalyptus Summit enlargement" section): platform 1.85× (radius 710 → ~1310 uu), spawns ±400, rim banners/braziers with fire light, eucalyptus treeline + stone outcrops below the rim, drifting-leaf Niagara, PIE-verified with the new HUD. Remaining: unique summit landmarks (this is dressing v1 from existing props), and the MWAM background-mountain meshes proved unusable as distant scenery — a proper skybox/backdrop is a future pick (Fab).
4. **Cinematic match camera** (Soulcalibur feel): low lateral framing — never top-down — both fighters always framed, dynamic zoom/rotation, invisible to the player.
5. **Ring-out presentation**: hit → launch → falling anim → slight camera track → fade → RING OUT → winner pose (launch/falling/land takes ordered from Blender in handoff WO4).
6. **Cinematic Character Select as designed**: one connected Verdantia with distinct showcase environments, smooth camera travel, confirmation animations (foundation from Sprint 2: themed LVIs, fly-cams, real idles).
7. **Integrate Wren's native boxing set from Blender** as takes land (idle is in; heavy tail-spring kick, dodges, get-up queued behind Gate B), then build out the full combat animation set for both fighters.
8. **Combat feel polish**: hit reactions, block, dodge, Edge Energy, VFX and sound on every exchange (frame-rate-independent per the Performance Standard).
