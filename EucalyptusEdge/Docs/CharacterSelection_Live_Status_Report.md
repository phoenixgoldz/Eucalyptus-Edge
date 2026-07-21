# Character Selection — Live Status Report (R1)

**Date:** 2026-07-21
**Scope:** Full live-project re-audit of the Eucalyptus Edge Character Selection framework
**Engine:** UE 5.8 · **Project:** `C:\Users\Trevor\Desktop\Eucalyptus-Edge\EucalyptusEdge`

**Audit method.** Six read-only auditors: A2/A3/A4/A5 (filesystem, run in parallel), A1 (live editor), A6 (live editor, exclusive). No asset was modified during this audit. Every claim below is tagged:

- **[V]** Verified directly (live editor property read, or file/binary inspection)
- **[I]** Inferred from strong evidence, not directly observed
- **[L]** Requires live audit — not determinable by the method used

> ⚠️ **Methodology warning that invalidated an earlier pass.** The `Grep`/ripgrep tool **silently stops at the first NUL byte** in `.uasset`/`.umap` binaries and returns false negatives. Two independent auditors initially reported "clean" results that were wrong. All binary reference checks in this report were re-run with `grep -a`. **Any prior "no references found" conclusion in this project is suspect until re-checked that way.**

---

### REVISION 2 — 2026-07-21, after W2 / W3 / W4

This report was first written from W1 (disk) + a preliminary live pass. The locked wave programme (W1 parallel-disk → W2 exclusive-live → W3 serialized-live → W4 exclusive-perf) has since completed. **Five findings were corrected:**

| Was | Now | Section |
|---|---|---|
| 47 actors; level dirty with 2 orphans; "do not save" | **45 actors** — orphans were transient PIE residue, garbage-collected. Caution **withdrawn** | §4.6 |
| AnimBPs are single-idle stubs; each references one clip | **`ABP_Wren` is a 5-clip blend graph** with BlendListByBool + Inertialization | §15, §16 |
| CommonUI enabled but entirely unused | **CommonUI is ACTIVE at runtime and MISCONFIGURED** — input routing explicitly non-functional | §17 |
| Navigation mechanism unknown | **Concrete cause found:** `InputMode:UIOnly` focusing a Non-Focusable widget | §17 |
| Echo import failed 2026-07-20 | **Still failing 2026-07-21 08:15**, on pose files specifically | §4.2 |

Scalability state was also captured for the first time (§10). **Numeric performance remains BLOCKED.**

---

## 1. Canonical map and current asset paths

**Canonical map [V]:** `/Game/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelection`
Confirmed non-World-Partition; `Content\__ExternalActors__\EE_ProjectFiles\CharacterSelect\Level\` exists but is **empty (0 files)** — all actors are packed in the `.umap`. **45 actors** (re-verified in W2; the transient 47 count is explained in §4.6). Zero Data Layers, zero HLOD actors, zero Level Instances, zero PostProcessVolumes, zero Niagara actors. **The map is self-contained.** [V]

**Obsolete map [V]:** `LV_CharacterSelect.umap` (no "ion") **does not exist on disk** — correctly deleted.

**Full `.umap` inventory under `EE_ProjectFiles` [V]:**
```
Content\EE_ProjectFiles\CharacterSelect\Level\LV_CharacterSelection.umap
Content\EE_ProjectFiles\MainMenu\Level\LV_MainMenu.umap
Content\EE_ProjectFiles\Maps\LV_EucalyptusSummit\LV_EucalyptusSummit.umap
Content\EE_ProjectFiles\Maps\LV_EucalyptusSummit\LV_EucalyptusSummit_Backup_PreTerrain.umap
Content\EE_ProjectFiles\Maps\LV_EucalyptusSummit\LV_EucalyptusSummit_TerrainTest.umap
```
Only **1 of 4 arenas** has a playable map. `MainMenu\Level\Maps\LV_BambooHarbor`, `LV_CrystalCaverns`, `LV_FrostpineRidge` are art folders containing **no `.umap`**. [V]

**Key Character Select asset paths [V]:**

| Purpose | Path |
|---|---|
| Level | `/Game/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelection` |
| GameMode | `/Game/EE_ProjectFiles/CharacterSelect/Blueprints/BP_EE_CharSelectGameMode` |
| Controller | `/Game/EE_ProjectFiles/CharacterSelect/Blueprints/BP_EE_CharSelectController` |
| Showcase point BP | `/Game/EE_ProjectFiles/CharacterSelect/Blueprints/BP_EE_CharacterShowcasePoint` |
| Widget | `/Game/EE_ProjectFiles/CharacterSelect/Widgets/WBP_EE_CharacterSelect` |
| Landscape material | `/Game/EE_ProjectFiles/CharacterSelect/Materials/MI_EE_VerdantiaLandscape` |
| GameInstance | `/Game/EE_ProjectFiles/Framework/BP_EE_GameInstance` |

**Boot configuration [V]** — `Config\DefaultEngine.ini` lines 4–13, verbatim:
```ini
[/Script/EngineSettings.GameMapsSettings]
EditorStartupMap=/Game/EE_ProjectFiles/MainMenu/Level/LV_MainMenu.LV_MainMenu
GameDefaultMap=/Game/EE_ProjectFiles/MainMenu/Level/LV_MainMenu.LV_MainMenu
TransitionMap=
bUseSplitscreen=True
TwoPlayerSplitscreenLayout=Horizontal
ThreePlayerSplitscreenLayout=FavorTop
GlobalDefaultGameMode=/Game/EE_ProjectFiles/MainMenu/Blueprints/BP_EE_MainMenu.BP_EE_MainMenu_C
GlobalDefaultServerGameMode=None
GameInstanceClass=/Game/EE_ProjectFiles/Framework/BP_EE_GameInstance.BP_EE_GameInstance_C
```

---

## 2. What is complete and verified

| Item | Evidence |
|---|---|
| **Landscape geometry (Stage 1)** — single `Landscape` actor, internal `Landscape_1` / label `Landscape2`; 1009×1009 heightmap, 63 quads/section, 1 section/component, 16×16 = 256 components, XY scale 50 cm, Z scale 23 → **504 × 504 m, 0–117.8 m**, centered on world origin | [V] live actor; region heights previously traced within ~0.5 m of spec |
| **Sky / lighting** — `DirectionalLight_0`, `SkyAtmosphere_0`, `SkyLight_0`, `ExponentialHeightFog_0`, `VolumetricCloud_0`, all in `Lighting` folder | [V] live |
| **7 showcase points**, correctly tagged with FighterID: Koda→`_C_0`, Wren→`_C_1`, Ripper→`_C_2`, Kiri→`_C_3`, Echo→`_C_4`, Banjo→`_C_5`, Atlas→`_C_6` | [V] live tag query |
| **8 cameras** — 7 per-fighter (`CSCam_<name>`) + `CameraActor_7` tagged `CSCam_Overview` | [V] live tag query |
| **GameMode override** = `BP_EE_CharSelectGameMode` on WorldSettings | [V] live property read |
| **Map is self-contained** — no Level Instances, no Data Layers, no HLOD, no `LVI_CS_*` references anywhere in `Content/` or `Config/` | [V] |
| **Echo wetland water body** — `WaterBodyLake_0`, calm stylized surface, clean carved shoreline, no floating edges, no Z-fighting | [V] visual validation + trace; **but see §13 for the caveats that qualify this** |
| **Frame-rate configuration** — no 70/72 cap exists anywhere; `bSmoothFrameRate=False`, `FrameRateLimit=60.000000`, live `t.MaxFPS = 60` | [V] config + live cvar |
| **No duplicate Character Select widget** — exactly one `WBP_EE_CharacterSelect` in the project | [V] |
| **No removed-character contamination** — zero assets for Mako, Bindi, Bramble, Tazra | [V] boundary-matched grep |
| **Shader compilation clean** — zero warnings, zero errors | [V] log |

---

## 3. What exists but is incomplete

| Item | State |
|---|---|
| **Character roster** | Only **4 of 7** fighters have animations: Banjo 69, Atlas 56, Wren 41, Ripper 40. Koda and Kiri have mesh + skeleton + physics asset + AnimBP but **zero clips**. [V] |
| **AnimBPs** | ⚠️ **Revision 2 correction — they are NOT stubs.** `ABP_Wren` was opened live and contains **16 nodes / 5 SequencePlayers** with real blend logic (§16). The Revision-1 claim of "one animation each" came from a binary grep that under-reported 5 referenced clips as 1. Koda/Kiri/Echo genuinely reference none (they have no clips). Graph contents of Atlas/Banjo/Ripper AnimBPs remain **[L]**. |
| **2-player support** | Exists as *state only* — `bUseSplitscreen=True`, and `BP_EE_GameInstance` has `SelectedFighterP1`, `SelectedFighterP2`, `bP2IsAI`. **No input path exists to drive P2.** [V] |
| **Ripper offense** | Thin: 3 light, 2 medium, **1 heavy** (`TorqueRush` in `_IP` + `_RM` variants — one move, not two). No grapple/throw clips. No strafe locomotion. [V] |
| **Settings infrastructure** | `BP_EE_SettingsSave` + reusable rows (`WBP_EE_Row_Check/Slider/Dropdown`) exist and are consumed by `WBP_MainMenu`; stored contents unknown. [L] |
| **Arena coverage** | 1 of 4 arenas has a playable map. [V] |
| **Atlas weapon** | `SM_WindspinePolearm` mesh + material + textures exist and the level references it, but **no attach socket verified** and no trail VFX. [V] mesh / [L] socket |

---

## 4. What is broken

### 4.1 ✅ FIXED 2026-07-21 — Main Menu could not reach Character Select *(was highest severity)*

**Resolved and verified on disk.** Three `Game|OpenLevel(byName)` nodes had a `LevelName` pin (type `Name`) holding a literal path to the deleted map. All three were repointed to `LV_CharacterSelection`; both Blueprints compiled clean and were saved.

| Node | Before | After |
|---|---|---|
| `WBP_MainMenu` : `EventGraph.K2Node_CallFunction_54` | `.../LV_CharacterSelect` | `.../LV_CharacterSelection` ✅ |
| `WBP_MainMenu` : `EventGraph.K2Node_CallFunction_55` | `.../LV_CharacterSelect` | `.../LV_CharacterSelection` ✅ |
| `WBP_EE_Results` : `EventGraph.K2Node_CallFunction_2` | `.../LV_CharacterSelect` | `.../LV_CharacterSelection` ✅ |
| `WBP_EE_Results` : `K2Node_CallFunction_1` | `LV_EucalyptusSummit` | untouched ✅ |
| `WBP_EE_Results` : `K2Node_CallFunction_3` | `LV_MainMenu` | untouched ✅ |

**Disk verification (`grep -a`):** `WBP_MainMenu.uasset` = 4 × `LV_CharacterSelection`, **0** × dead ref. `WBP_EE_Results.uasset` = 3 × `LV_CharacterSelection`, **0** × dead ref. Both files dropped off the project-wide dead-reference list.

**⚠️ Two tooling traps encountered — record these, they will recur:**
1. **`BlueprintTools.set_pin_value` does not mark the package dirty.** `AssetTools.save_assets` then returns `True` while writing nothing — "True" means *nothing needed saving*, not *saved*. **Always verify a Blueprint edit by file mtime + `grep -a`, never by the save return value.**
2. A non-dirty asset **cannot be saved from the editor either** (Save is inert). The package must be dirtied first. There is **no mark-dirty API**; `AssetTools.update_metadata_tags` was used as the dirty trigger.

**Known residue:** both assets now carry the metadata tag `EE_MapRefFix = LV_CharacterSelection`. It is functionally inert. `update_metadata_tags`'s `remove_tags` parameter fails UStruct conversion in this MCP build, so it was left in place deliberately rather than hacked around; it can be cleared in-editor if desired.

<details><summary>Original Revision-1 finding (retained for history)</summary>

### 4.1-orig 🔴 Main Menu cannot reach Character Select — **highest severity**
`WBP_MainMenu` opens the **deleted** map. Verbatim byte context (`cat -v`, `^@` = NUL) [V]:
```
e/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelect^@M-`qM-s^M4
e/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelect^@^E^@^@^@N
e/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelect^@^E^@^@^@N
```
The string terminates at NUL immediately after `...Select` — it is **not** a truncated `LV_CharacterSelection`.

| File | Occurrences |
|---|---|
| `Content\EE_ProjectFiles\MainMenu\Widgets\WBP_MainMenu.uasset` | 3 |
| `Content\EE_ProjectFiles\Combat\Widgets\WBP_EE_Results.uasset` | 2 |

**Encoded runtime flow [V]:**
```
LV_MainMenu ──Play──▶ LV_CharacterSelect            ❌ MAP DELETED
LV_CharacterSelection ──▶ LV_EucalyptusSummit        ✅ correct
LV_EucalyptusSummit ──Results──▶ LV_CharacterSelect  ❌ MAP DELETED
LV_EucalyptusSummit ──Results──▶ LV_MainMenu         ✅ correct
```
`WBP_EE_CharacterSelect` itself is **correct** and unaffected.

</details>

### 4.2 🔴 Echo does not exist as a character
- **No skeletal mesh, no skeleton, no physics asset, zero animations.** Only textures + an `ABP_Echo` that references no skeleton. [V]
- `Fighter_Echo` (`SkeletalMeshActor_5`) in the level has **`SkinnedAsset = None`** — an invisible actor. [V]
- Hard compile error in the log [V]:
```
LogBlueprint: Error: [AssetLog] ...\EchoPlatypus\Anims\ABP_Echo.uasset:
[Compiler] ABP_Echo - The skeleton asset for this animation Blueprint is missing,
so it cannot be compiled!
```
- All 68 Echo source FBX plus `SK_Echo.fbx` failed import with "nothing to import" on 2026-07-20. [V]

**⚠️ ACTIVE — still failing 2026-07-21 08:15** from a new source folder `C:\Users\Trevor\Desktop\EchoPlaty\UE_IMPORT_PACKAGE_V1_VERIFIED\` [V]:
```
LogInterchangeEngine: Error: [.../Anims/Echo_Pose_CombatReady.fbx]
  Cannot fetch FBX animation bake transforms payload because the bake range is invalid.
LogInterchangeEngine: Error: [.../Anims/Echo_Pose_Reference.fbx]
  Cannot fetch FBX animation bake transforms payload because the bake range is invalid.
EnsureFailed: Ensure condition failed: AnimationTransformPayload.Transforms.Num() ==
  BakeKeyCountForAnimationPayload [InterchangeAnimSequenceFactory.cpp] [Line: 579]
```
**Pattern worth acting on:** both failures are `Echo_Pose_*` files — *poses*, not animations. This is the identical error class that hit Atlas (`ATLAS_Pose_Reference_A_v01.fbx`, `ATLAS_Pose_CombatReady_v01.fbx`), and Atlas's later generation imported cleanly 56/56. "Bake range is invalid" on a single-frame pose export is a degenerate animation-range symptom: the Interchange baker is handed a clip with no usable frame span. Usual remedies are exporting poses with ≥2 frames, or importing them with the animation pipeline disabled so they never reach `AnimSequenceFactory`. **[I] — diagnosis by pattern, not yet proven on Echo's specific files.**

### 4.3 🔴 `BP_EE_Wren` has 4 dead animation references
```
While trying to load package /Game/EE_ProjectFiles/Combat/BP_EE_Wren, a dependent
package /Game/EE_ProjectFiles/Characters/WrenKangarooModel/Anims/Wren_Dodge_Back_v2
was not available. ... has a valid, mounted, mount point but does not exist either
on disk or in iostore. Perhaps it has been deleted or was not synced?
```
Same for **`Wren_Dodge_Left_v2`**, **`Wren_Dodge_Right_v2`**, **`Wren_Heavy_TailSpring_v2`**. [V]

### 4.4 🔴 Eucalyptus Summit collateral damage from Stage 2A (self-reported)
Two edits made during Stage 2A were reported at the time as safe/local. **Both were wrong.**

**(a) `MI_EE_VerdantiaLandscape` is shared with `LV_EucalyptusSummit`.** 51 World Partition landscape proxies reference it — 17 each across `LV_EucalyptusSummit`, `_Backup_PreTerrain`, `_TerrainTest`. Sample proxy `Content\__ExternalActors__\EE_ProjectFiles\Maps\LV_EucalyptusSummit\LV_EucalyptusSummit\0\CR\R7Q2DQ7CEQX92E837VV028.uasset` imports it directly. **The Verdantia colour retune also retextured the playable arena.** [V]

**(b) Deleting `MaterialExpressionLandscapeGrassOutput` from `MTL_MWAM_AutoMaterial_MASTER` killed all procedural grass on Summit.** Proven against git LFS blobs [V]:

| Commit | LFS oid (prefix) | Size | Grass output |
|---|---|---|---|
| `4ec6fec` | `981e207c…` | 171,219 | **present** |
| `097ea1d` | `58ae68b2…` | 177,406 | **present** |
| `92d81a3` → HEAD | `47e76ff6…` | 175,152 | **absent** |

The pre-deletion master fed all five `LGT_MWAM_Dirt/Grass/Rock/Snow/Stones` grass types; the current one references none. Those five assets are now orphaned project-wide. Summit's proxies still carry `LandscapeGrassType`/`NamedGrassTypes` references that will never spawn.

**Restore point [V]:**
`.git\lfs\objects\58\ae\58ae68b257440c0878e892d85ff208605e593641703d83acea7dc27e1913a1c1` (177,406 bytes, intact)

Corroborating: the master and `MI_EE_VerdantiaLandscape` share mtime **2026-07-19 03:28:27** to the second, while every other MWAM file is 2026-07-04 18:05:16.

### 4.5 🔴 Waterfall — four failed attempts, none viable
See §14.

### 4.6 ✅ Level drift — RESOLVED (was flagged as a blocker in Revision 1)
An identical `find_actors` query returned **45 → 47 → 45** across the session with no edits at any point. The two transient additions were `SkeletalMeshActor_8` ("Banjo"+"Temp") and `SkeletalMeshActor_9` ("Atlas"+"Temp"), both at outliner root with `AnimClass = None`.

**Cause confirmed [V]:** they were PIE-world residue awaiting garbage collection, corroborated by the log:
```
LogUtils: Error: DestroyActors. An actor to destroy is not part of the world editor.
```
That error fires precisely when something attempts to destroy actors that are **not** part of the *editor* world. W2 re-verified the level at **45 actors** with only `SkeletalMeshActor_0`–`_6`.

**The on-disk map was never affected and the in-memory level is correct. The Revision-1 "do not save" caution is WITHDRAWN.** A fresh Map Check is still owed before any save (§9).

**Operational note:** running PIE or Simulate on this map temporarily inflates actor enumeration. Do not treat a mid-PIE actor count as authoritative.

### 4.7 ⚠️ Blueprint switch name mismatch
```
LogScript: Warning: Unknown exec output "Wren" on Utilities|FlowControl|Switch|SwitchonName.
Available: ['Default', 'Case_0', 'Case_1', 'Case_2', 'Case_3', 'Case_4', 'Case_5', 'Case_6']
```
A fighter switch has generic `Case_N` pins rather than named cases. [V] log / [L] which graph

---

## 5. What is obsolete

| Item | Path | Note |
|---|---|---|
| Stale map references | `WBP_MainMenu`, `WBP_EE_Results` | Point at deleted `LV_CharacterSelect` |
| Orphan LevelSequences | `Characters\WrenKangarooModel\EE_Seq_WrenIdle.uasset`, `Characters\TasModel\EE_Seq_RipperIdle.uasset` | Bound to the deleted level; **zero referencers** |
| Stub LevelSequences | `Characters\AtlasEmu\Atlas_Idle_Combat.uasset` (3,157 B), `Characters\BanjoModel\Banjo_Idle_Combat.uasset` (3,161 B) | Empty, no tracks, and they **name-collide** with the real 444 KB AnimSequences in `Anims/` — a live-audit trap |
| Dangling startup movie | `Config\DefaultGame.ini`: `+StartupMovies=PhoenixGold Logo3D` | `Content\Movies\` does not exist; `Content\EE_ProjectFiles\Videos\` is empty |
| Stale editor template value | `Config\DefaultEditor.ini` line 2: `SimpleMapName=/Game/TP_ThirdPerson/Maps/ThirdPersonExampleMap` | Inert |
| Unwired heightmap textures | `CharacterSelect\Materials\EE_LV_CharacterSelect_Heightmap_1009x1009`, `..._PREVIEW` | Content-Browser import artifacts, zero referencers |
| Backup assets in Content | `Combat\Backups\BP_EE_Wren_PreTwigFix_20260717.uasset`, `LV_EucalyptusSummit_Backup_PreTerrain.umap` | |
| Legacy Cascade FX | 21 `P_*` systems under `Content/SoulCave/` | Cascade is deprecated in UE 5.8; all are UE4 package v514 |

---

## 6. What is missing

| Missing | Impact | Evidence |
|---|---|---|
| **IK Rigs and IK Retargeters — zero in the entire project** | Koda, Kiri, Echo cannot borrow animation from anyone. All 7 skeletons are separate and unrelated. | [V] class-string scan of all 7,837 `.uasset`, with positive controls proving the scan works |
| **Landscape Layer Info assets — zero in EE content** | Biome painting is **impossible**. `LV_CharacterSelection` has `TargetLayers` structs containing no layer FNames. | [V] verified 3 ways |
| **Waterfall body mesh/asset** | Must be authored. See §14. | [V] |
| **Loading screen** | `TransitionMap=` is empty → every `OpenLevel` is a blocking hitch with a frozen frame. | [V] |
| **Menu/UI Enhanced Input** | No `IMC_Menu`, no confirm/cancel/navigate/join actions. Only Epic template + `Variant_Combat` input exists. Character Select has **no defined controller input path**. | [V] |
| **Gamepad glyph assets** | Only a keyboard/mouse icon pack (100 textures) exists. A controller prompt system must be authored from scratch. | [V] |
| **AnimMontages and BlendSpaces — zero project-wide** | Every attack is a raw AnimSequence. | [V] |
| **Weapon/attack trail VFX — zero** | Only Niagara system in `EE_ProjectFiles` is `NS_BrazierFire`. | [V] |
| **`BP_EE_CharacterSelectManager`** | Does not exist. | [V] |
| **`/Game/EE_ProjectFiles/CharacterSelect/Environment/`** | Entire folder tree from the Phase E3 spec is unbuilt. Only `Blueprints`, `Level`, `Materials`, `Widgets` exist. | [V] |
| **Physics assets** for Atlas, Banjo, Ripper | Absent. | [V] / [L] whether auto-generated |
| **SoundCues for waterfall audio** | `Waterfall04–07` are raw `SoundWave` with no cue wrapper or attenuation. | [V] |
| **Grapple/throw clips** for Ripper and Atlas | Absent. | [V] |
| **Accessibility** — subtitles, colorblind, controller-disconnect handling | Zero matches in `Config/`. | [V] |

---

## 7. What must be deleted later (proposal only — NOT yet actioned)

Quarantine target: `/Game/EE_ProjectFiles/_Review/CharacterSelection/WaterfallFailedAttempts/`

**Level actors to remove from `LV_CharacterSelection`** (actors only — the underlying assets are shared marketplace content and must **not** be deleted):

| Actor | Asset | Status |
|---|---|---|
| `StaticMeshActor_0` (`Water_Echo_Waterfall1`) | `SM_S_Soul_Waterfall1` | Parked at −40000,−40000,8000 |
| `BP_SplineVFX_WaterSplash_C_0` (`Water_Echo_SplineFall`) | `BP_SplineVFX_WaterSplash` | Parked at −42000,−42000,8000 |
| `Emitter_1` (`Water_Echo_Fall2`) | `P_FallingWater2` | Live, unvalidated |
| `Emitter_0` (`Water_Echo_Splash`) | `P_WaterFall` | Live, orphaned |
| `AmbientSound_0` (`Water_Echo_FallSFX`) | `Waterfall04` | Live, orphaned |
| `SkeletalMeshActor_8`, `SkeletalMeshActor_9` | `SK_Banjo`, `SK_Atlas` | Orphan "Temp" duplicates, no AnimBP |

**Assets safe to delete** (zero referencers, project-owned): the 2 orphan `EE_Seq_*Idle` LevelSequences, the 2 empty stub LevelSequences, `Combat\Backups\BP_EE_Wren_PreTwigFix_20260717`, duplicate Echo root textures (~10 MB), stray Kiri/Koda skeletons (`*0_Open_A_UE5`, `*0_T-Pose`), `Wren_Validation.fbm/`, `WrenRedesign.png`.

**Never delete:** anything under `SoulCave/`, `_SplineVFX/`, `MWLandscapeAutoMaterial/`, `A_Surface_Footstep/` — all shared marketplace content, several referenced by `LV_Soul_Cave` and other maps.

---

## 8. What must be moved later (proposal only)

⚠️ **All moves must go through Unreal's Content Browser** (never Windows Explorer), followed by redirector cleanup and reference validation. **Do not rename `LV_CharacterSelection`.**

| Current | Proposed | Referencers | Risk |
|---|---|---|---|
| `WaterZone_0`, `BuoyancyManager_0`, `Landscape2_WaterBrushManager_0` (outliner **root**) | `Water` folder | in-level only | Low — outliner only |
| `TasModel/Animations/` | `TasModel/Anims/` | 40 clips + `ABP_Ripper` | **High** — breaks 40+ refs |
| `WrenKangarooModel/EE_Seq_WrenIdle` | delete or `_Review/` | 0 | None |
| `AtlasEmu/Atlas_Idle_Combat` (stub sequence) | `_Review/` | 0 | None, but resolves a name collision |
| Duplicate `Verdantia`/`Verdantia_Font` in `Framework\Fonts\` **and** `MainMenu\Fonts\` | consolidate to one | `WBP_EE_MatchHUD` uses the Framework copy | Medium — [L] which is authoritative |
| Echo root textures (4 × `tripo_node_*`) | delete duplicates | [L] | Medium |

**Do not reorganize now.** File organization is the lowest-priority phase and the highest reference-breakage risk.

---

## 9. Current warnings and errors (exact text)

**Map Check [V]:** `MapCheck: Map check complete: 0 Error(s), 0 Warning(s), took 0.069ms to complete.` — last run **07:07:38**.
⚠️ **This predates the water actors and cannot be re-triggered via MCP** (no console-exec tool exists). A fresh Map Check must be run in-editor before any save.

**Water / WaterZone / WaterBrush / Niagara / Cascade / Landscape / Spline warnings:** **zero matches** [V]

**Errors present:**

1. `ABP_Echo` compile failure — §4.2
2. `BP_EE_Wren` missing `_v2` dependencies ×4 — §4.3
3. Atlas FBX import errors (**superseded, not a live problem**) — all from a retired `_v01` generation dated 2026-07-19:
```
LogInterchangeEngine: Error: [C:/Users/Trevor/Desktop/Atlas/Anims/ATLAS_Walk_Forward_v01.fbx : '', Unknown]
Cannot fetch FBX animation bake transforms payload because the bake range is invalid.
EnsureFailed: Error: Ensure condition failed: AnimationTransformPayload.Transforms.Num() ==
BakeKeyCountForAnimationPayload [File:...InterchangeAnimSequenceFactory.cpp] [Line: 579]
```
The current Atlas set (2026-07-20) imported cleanly: **56 source FBX ↔ 56 imported assets, zero missing.** [V]
4. `SwitchOnName` unknown exec output "Wren" — §4.7
5. `GetObjectProperties on '.../WrenRedesign' (Texture2D): the following properties could not be read: ImportedSize` — benign, caused by an audit query

---

## 10. Current performance baseline

### ⛔ BLOCKED — frame timing is not obtainable

**No toolset exposes a console-exec.** `stat unit`, `stat gpu`, `stat rhi`, `stat scenerendering` are unreachable via MCP. **Average FPS, 1% lows, game-thread / render-thread / GPU times, draw calls, and triangle counts are NOT MEASURED.** No estimate is offered in their place.

PIE was deliberately **not** run for measurement: it yields no numbers without `stat`, and the level already drifted by 2 actors across earlier Simulate runs (§4.6).

**To unblock:** run in PIE and capture `stat unit`, `stat gpu`, `stat rhi`.

### What was measured [V] — live cvars

| Setting | Live value | Cost |
|---|---|---|
| `t.MaxFPS` | **60** | ✅ matches target |
| `r.DynamicGlobalIlluminationMethod` | **1 = Lumen** | 🔴 high |
| `r.ReflectionMethod` | **1 = Lumen Reflections** | 🔴 high |
| `r.Shadow.Virtual.Enable` | **1 = VSM** | 🔴 high |
| `r.Streaming.PoolSize` | **800 MB** | ⚠️ modest |
| `r.RayTracing` | True | 🔴 high |
| `r.Substrate` | True | ⚠️ affects all material authoring |
| `r.AllowStaticLighting` | **False** | 🔴 fully dynamic |

### Scalability state — captured in W4 [V]

**Every scalability group is at 2 = HIGH** (the engine default is 3 = Epic):
```
sg.ResolutionQuality    = 100      sg.ViewDistanceQuality = 2
sg.AntiAliasingQuality  = 2        sg.ShadowQuality       = 2
sg.GlobalIlluminationQuality = 2   sg.ReflectionQuality   = 2
sg.PostProcessQuality   = 2        sg.TextureQuality      = 2
sg.EffectsQuality       = 2        sg.FoliageQuality      = 2
sg.ShadingQuality       = 2        sg.LandscapeQuality    = 2
```
Two consequences:
1. The editor currently sits at **High**, which matches the "1080p High / 1440p High" validation target — so a baseline captured now is directly comparable.
2. ⚠️ **A packaged build defaults to Epic (3)** unless `GameUserSettings` pins a profile. Shipping performance would therefore be **worse** than anything measured in this session. The front-end should pin a scalability profile deliberately.

**Nothing was changed** — scalability and project settings were read only, per the audit rules.

**Principal finding: the project runs a maximum-cost dynamic lighting stack** — Lumen GI + Lumen Reflections + Virtual Shadow Maps + Ray Tracing + Substrate, with static lighting disabled. On the reference RTX 3060 Ti at 1440p this will dominate frame time far more than any Character Select scene content. **The frame cap is correct; the frame budget is the risk.** This warrants a deliberate decision (e.g. Lumen Reflections → SSR for the front-end, or a front-end scalability profile) rather than late discovery.

### Static scene budget [V]
47 actors · 8 visible skeletal meshes (Echo is null) · 1 landscape (256 components) · 2 legacy Cascade emitters · 1 WaterZone (504 m) · 1 WaterBodyLake · **0 Niagara actors** · **0 post-process volumes**. Scene-side this is light — reinforcing that the renderer configuration, not the content, is where the budget goes.

### Configured frame-rate state [V]
```ini
# Config\DefaultEngine.ini
bSmoothFrameRate=False
[/Script/Engine.GameUserSettings]
FrameRateLimit=60.000000

# Saved\Config\WindowsEditor\GameUserSettings.ini  (local, non-versioned)
bUseVSync=True
FrameRateLimit=60.000000
ResolutionSizeX=1920 / ResolutionSizeY=1080 / FullscreenMode=1
```
`SmoothedFrameRateRange`, `MinDesiredFrameRate`, and `t.MaxFPS` are **absent from `Config/`**; `DefaultDeviceProfiles.ini` and `DefaultScalability.ini` **do not exist**. **No 70/72 cap exists anywhere.** Two caveats: (a) `FrameRateLimit` in `DefaultEngine.ini` is only a seed — the saved `GameUserSettings.ini` wins at runtime, and there is no `t.MaxFPS` config fallback; (b) the **Reflex plugin is enabled**, and Reflex pacing + VSync at display refresh is the only disk-visible candidate for any observed 70–72 FPS ceiling. [L]

---

## 11. Agent E — exact current state

**PAUSED.** No edits since the recovery directive.

**Content assets created by Agent E: NONE.** No `.uasset` was authored. **No custom spline waterfall asset exists** — `BP_EE_SplineWaterfall` was never created, and `/Game/EE_ProjectFiles/CharacterSelect/Environment/Water/` does not exist.

**Assets modified (Stage 2A):**
- `MI_EE_VerdantiaLandscape` — overrode `MW_GrassColorCorrection`, `MW_RockColorCorrection`, `MW_DirtColorCorrection`, `MW_StonesColorCorrection`, `MW_SnowMaskMultiplier`, `MW_SnowWorldPosition`, `MW_UseSnow`. Saved. ⚠️ **shared with Summit** (§4.4a)
- `MTL_MWAM_AutoMaterial_MASTER` — **deleted the `LandscapeGrassOutput` node**, recompiled, saved. ⚠️ **broke Summit grass** (§4.4b)

**Level modified:** `LV_CharacterSelection` saved once with the water actors.

**⚠️ Landscape geometry was altered.** `WaterBodyLake_0` has `bAffectsLandscape = true`, so the Water Brush carves Echo's basin (flattened bed + blended shoreline). The carve is **local** — verified by trace: Echo pad 15.4 m, Banjo 82.0 m, Ripper 28.6 m, Koda 46.3 m, Kiri 100.5 m all unchanged. But the approved Stage-1 heightmap **is** locally modified and requires a ruling. [V]

**Failed waterfall actors still in the map:** 5 (see §7).

---

## 12. Landscape material state

**Chain [V]:**
```
MTL_MWAM_AutoMaterial_MASTER (UMaterial, 175,152 B)
  └─ MTL_MWAM_Landscape_MountainRangeExample (MIC, 30,488 B)
       └─ MI_EE_VerdantiaLandscape (MIC, 11,305 B)  ← assigned as LandscapeMaterial
```

### 🔴 Structural blocker: the material cannot express seven regions

MWAM is a **fully procedural** auto-material. Across the entire pack there is **no `LandscapeLayerBlend` and no `LandscapeLayerWeight`** — exactly one `LandscapeLayerSample` node. Blending is driven by slope, world height, and a variation mask, **not painted weightmaps**. [V]

- **5 global surface slots** (Grass, Dirt, Rock, Stones, Snow) + Water. **Zero per-region control.**
- `MW_UseSnow` is a **global static switch** — frost for Kiri frosts Atlas's outback.
- `MI_EE_VerdantiaLandscape` overrides **no texture parameters** — it inherits stock MWAM textures and only recolours them globally.

### Exact override set — captured in W3 [V]
Of **98 available parameters**, exactly **6** are overridden:

| Parameter | Value |
|---|---|
| `MW_GrassColorCorrection` | (0.72, 0.80, 0.48, 1) |
| `MW_DirtColorCorrection` | (0.55, 0.45, 0.30, 1) |
| `MW_RockColorCorrection` | (1.15, 0.98, 0.78, 1) |
| `MW_StonesColorCorrection` | (1.10, 0.95, 0.74, 1) |
| `MW_SnowMaskMultiplier` | 0 |
| `MW_SnowWorldPosition` | 500000 |

`TextureParameterValues` = **empty**. Parent = `MTL_MWAM_Landscape_MountainRangeExample`.

➡️ **This makes the Summit fix cheap.** Forking a Character-Select-only instance is a **6-value copy** — the entire divergence from the parent is those six numbers. There is no reason to keep mutating a material shared with the playable arena.

**Landscape actor re-verified [V]:** `LandscapeMaterial` = `MI_EE_VerdantiaLandscape`, scale (50, 50, 23), location (−25200, −25200, 5888) — exactly the Stage-1 spec.
**NOT VERIFIED:** instruction count, sampler count, shader complexity, bound target layers — `ComponentSizeQuads` / `SubsectionSizeQuads` / `NumSubsections` are not exposed on the actor (they live on LandscapeInfo).

Seven biomes need roughly 20+ distinct surfaces with regional isolation. **No mechanism exists.**

### 🔴 Zero Layer Infos; the nine biome masks are wired to nothing
All in `Content\EE_ProjectFiles\CharacterSelect\Materials\`, all `Texture2D`, **all with zero referencers** [V]:

`Mask_Koda_EucalyptusSanctuary` (88,083 B) · `Mask_Wren_Grassland` (96,134) · `Mask_Ripper_Woodland` (79,135) · `Mask_Kiri_HighCanopy` (71,825) · `Mask_Echo_Wetland` (82,802) · `Mask_Banjo_UpperCanopy` (60,743) · `Mask_Atlas_Outback` (65,269) · `Mask_Cliffs` (378,979) · `Mask_Water_Wetland` (52,196)

The intent is unmistakable — one mask per fighter plus cliffs and water — but the wiring was never made. Compression appears to be `TC_EditorIcon`, wrong for weight masks (want `TC_Masks`, sRGB off). [I → [L] confirm in texture editor]

⚠️ No source `.png`/`.r16` exists outside `Content/` any more, so re-import has no source to point at.

### Region coverage vs. requirement

| Region | Required | Available | Missing |
|---|---|---|---|
| Koda — Eucalyptus Sanctuary | moss, forest soil, leaf litter, magical green | generic Grass, Dirt | moss, leaf litter, forest soil, green tint slot |
| Wren — Grassland Rise | healthy grass, dry grass, training earth | Grass (one), Dirt | dry-grass variant (no second grass slot exists) |
| Ripper — Woodland Hollow | dark soil, damp earth, leaf litter, dark rock | Dirt, Rock (global tint only) | leaf litter, damp earth, dark rock |
| Kiri — High Canopy | high stone, wind grass, pale rock, frost | Stones, Rock, Grass, Snow | pale rock; **frost is global-only** |
| Echo — Crystal Wetland | saturated soil, wet stone, marsh grass, shoreline | Water params give a shoreline mechanism | marsh grass, wet stone, cool mineral; `MW_UseWater` **not overridden** |
| Banjo — Upper Canopy | forest ground, roots, moss, canopy greens | Dirt, Grass | roots, moss, wood tones |
| Atlas — Outback | ochre, dry gold grass, rust/clay, sandstone | Dirt + Rock, global recolour only | achievable only by recolouring **all seven** regions |

### Useful unwired alternatives [V]
- `Content\DesertValleyMats\` — a real layer-blend landscape master **plus 5 working LayerInfo assets** (closest fit to Atlas)
- `Content\Iceland_Environment\M_AutoLandscape.uasset` — **the only material left in the project containing a `LandscapeGrassOutput` node**

### Config [V]
`Config/` contains **no** `r.VirtualTextures`, `r.Nanite*`, or any landscape/grass setting. RVT is off; `LV_CharacterSelection` contains no `RuntimeVirtualTexture` token. `r.Substrate=True` — the MWAM master is a pre-Substrate pack; compile cleanliness under Substrate is **[L]**.

⚠️ `Content\EE_ProjectFiles\CharacterSelect\` is **untracked by git** (gitignored as of `8b282d8`). The masks, heightmaps, and `MI_EE_VerdantiaLandscape` have **no version-control safety net**. The MWAM pack is LFS-tracked — which is the only reason the grass-output restore in §4.4b is possible.

---

## 13. Water state

**Water plugin is ENABLED — but not declared.** `IsEnabled("Water")` → **true** [V]. However the `.uproject` `Plugins` array contains **no `Water` entry**, and `Water.uplugin` is `"EnabledByDefault": false` + `"IsExperimentalVersion": true`. It is being pulled in **transitively**; dependents are `Buoyancy, ChaosCloth, MeshPartitionWater, Mover, PCGWaterInterop, WaterAdvanced, WaterExtras` [V]. This also explains the stray `BuoyancyManager_0`.

**Risk:** an experimental plugin held up by an undeclared transitive dependency. If whatever pulls it in changes, `WaterBodyLake_0` / `WaterZone_0` / `WaterBrushManager_0` silently drop on load. **If water is kept, `Water` must be added explicitly to the `.uproject`.**

**Working [V]:** `WaterBodyLake_0` at (−9500, 1000, 1100), water level 11 m, scale (1.0, 1.2, 1.0) ≈ 76 × 118 m. `WaterZone_0` `ZoneExtent = 50400 cm = 504 m`, exactly map-sized and centered at origin — correctly scoped, **not** a full-map sim. (Its `get_actor_bounds` reads 80,504 m; that is render/horizon bounds, not the sim extent.) Visual validation: calm stylized surface, shallow→deep gradient, carved shoreline, no floating water, no visible mesh edges.

**Re-verified live in W3 [V]:** lake transform and `ZoneExtent` unchanged, and **`bAffectsLandscape` is still `true`** — the Water Brush is *actively* carving Echo's basin right now. All five failed-attempt actors confirmed present at their recorded positions (2 parked at −40000/−42000, 3 live near Echo). **Mesh pivots, local axes, UV/flow direction and subdivision density remain NOT VERIFIED** — those require opening asset editors, which the audit rules exclude.

**Not built:** river/stream. The east basin is a **terminal bowl** — no natural outflow corridor exists in the craggy heightmap. Forcing a channel would violate "follow the authored low terrain." Open decision.

---

## 14. Waterfall state — **BROKEN, 4 failed attempts, root causes now understood**

### No waterfall body asset exists in this project [V]
Every "waterfall" asset on disk is a fixed-shape UE4.25-era decorative prop or a splash effect.

| Attempt | Asset | Why it failed — mechanically |
|---|---|---|
| 1 — vertical mesh | `SM_S_Soul_Waterfall1` | Top floated in mid-air. It is a **closed sculpted prop**, not a tileable sheet, and the terrain has no vertical cliff. |
| 2 — tilted 50° | same | **Flow direction is baked into UV layout + vertex paint.** Its material blends from `VertexColor` + `VertexNormalWS` and pans through a fixed `TextureCoordinate`. **Rotating the mesh does not rotate the flow.** Never re-attempt orientation fixes on this mesh. |
| 3 — spline VFX | `BP_SplineVFX_WaterSplash` / `NS_Spline_WaterSplash` | **69 sprite renderers, 6 light renderers, ZERO ribbon, ZERO mesh renderers.** Sprites cannot form a continuous sheet. Module stack (`MoveToNearestDistanceFieldSurface_GPU`) snaps particles to the nearest surface and drives a **Z-only projected puddle decal** — it is a horizontal, ground-hugging splash system. At 5.38 MB with 6 dynamic lights it is also the most expensive water asset in the project. |
| 4 — falling-water particle | `P_FallingWater2` | Legacy **Cascade** (deprecated in 5.8), UE4 v514, single CPU sprite emitter, mobile-tier LOD, material reads `ParticleColor`/`DynamicParameter` → produces foam puffs, not a sheet. Placed but never validated. |

### Terrain constraint [V]
The NW rim of Echo's basin is a consistent **~37° slope**, not a cliff. Measured profile (water level 11 m):
```
        X: -6000 -6500 -7000 -7500 -8000 -8500 -9000 -9500 -10000
Y=5500:   9.6  10.7  11.0  11.0  13.8  17.8  21.7  25.7  29.7
Y=6500:  11.0  11.0  12.4  16.1  19.9  23.8  27.7  31.6  35.5
```
A vertical waterfall requires a vertical cliff. **The geometry does not exist**, which is why every vertical/tilted placement read as detached.

### What must be authored
A flat sheet ~1×1 in local space, subdivided **heavily along the fall axis** (~32–64 segments) and lightly across (4–8), **UV V running along the fall axis 0→1** so a Panner scrolls downward, plus a vertex-colour gradient for crest→fall→impact opacity. **`ModelingToolsEditorMode` is enabled** [V], so this can be built inside the editor.

⚠️ The project contains exactly **one** asset referencing `SplineMeshComponent` (`PCG_Spline_Tool/BP_SplineRandomMesh_Tool`, a scatter tool). **There is no precedent, template, or donor mesh for spline deformation here.** [V]

### Recommended reuse — technique, not prefabs

| Stage | Reuse |
|---|---|
| Body material | **`MF_TangentSpaceFlowUsingVertexUVs`** (`SoulCave/Environment/Materials/Water/`, 99,579 B) — a proper two-phase flow-map ping-pong function, the single most valuable water asset in the project. Feed with `T_Cave_FlowMap_N` + `T_WaterStream0002_2_L_alpha2_N`. Translucent, two-sided, DepthFade at rock contact. |
| Crest foam | `T_WaterFoam_02` (1.4 MB) — the only real foam texture |
| Impact / mist | `PEN_WaterMistSplash` + `PEN_Waterdrops` (real Niagara, ~450 KB each). **Not** `NS_Spline_WaterSplash`. |
| Pool foam | `SM_Ripple_Wide` / `SM_Flow_Ripples_01_vpainted` — **horizontally only**, their native orientation |
| Audio | `Waterfall05/06/07` — free (only `04` is in use). **No SoundCue exists for any**; one must be authored with attenuation. |
| **Never place** | `SM_S_Soul_Waterfall1/2`, `BP_SplineVFX_WaterSplash`, `NS_Spline_WaterSplash`, `P_WaterFall`, `P_FallingWater2`, all Cascade `P_*` |

---

## 15. Character showcase state

| Fighter | Actor | Mesh | AnimBP | Mode |
|---|---|---|---|---|
| Banjo | `SkeletalMeshActor_0` | `SK_Banjo` | `ABP_Banjo` | AnimationBlueprint |
| Koda | `SkeletalMeshActor_1` | `RiggedKoda` | `ABP_Koda` | AnimationBlueprint |
| Wren | `SkeletalMeshActor_2` | `WrenKangaroo` | `ABP_Wren` | AnimationBlueprint |
| Ripper | `SkeletalMeshActor_3` | `SK_Ripper` | `ABP_Ripper` | AnimationBlueprint |
| Kiri | `SkeletalMeshActor_4` | `RiggedKiri` | `ABP_Kiri` | AnimationBlueprint |
| **Echo** | `SkeletalMeshActor_5` | **`None`** 🔴 | `ABP_Echo` (won't compile) | AnimationBlueprint |
| Atlas | `SkeletalMeshActor_6` | `SK_Atlas` | `ABP_Atlas` | AnimationBlueprint |
| *orphan* | `SkeletalMeshActor_8` | `SK_Banjo` | **None** | root folder |
| *orphan* | `SkeletalMeshActor_9` | `SK_Atlas` | **None** | root folder |

**Every fighter has `animToPlay: None`** — there is **no per-actor single-animation override anywhere.** [V]

**Scope impact on Phase C1:** the four showcase states (Ambient / Highlighted / Confirmed / Deselected) are achievable for **4 of 7** fighters only. Koda and Kiri can hold a static pose at best (zero clips). **Echo cannot be displayed at all.**

---

## 16. Animation and retargeting state

**Zero IK Rigs. Zero IK Retargeters. Project-wide.** [V] — verified by class-string scan (`IKRigDefinition`, `IKRetargeter`, `RetargetChainSettings`, `IKRigSolver`, `RetargetPose`) across all 7,837 `.uasset` + 33 `.umap`, with positive controls confirming the scan works. All 7 skeletons are separate and unrelated → **no mechanism exists to share animation between characters.**

**Clip counts [V]:** Banjo 69 · Atlas 56 · Wren 41 · Ripper 40 · Koda 0 · Kiri 0 · Echo 0. All 206 clips are `AnimSequence`, each bound to its own character's skeleton (no cross-skeleton contamination). **Zero AnimMontages, zero BlendSpaces project-wide.**

### Wren idle — corrected diagnosis

An earlier hypothesis (mine) held that no bounce idle existed. **That was wrong.** A second hypothesis held that the level plays `Wren_CS_Attention` instead of the AnimBP clip. **That was also wrong** — live properties show `AnimationMode = AnimationBlueprint` with `animToPlay: None`.

**Actual state [V]:** Wren runs `ABP_Wren` → **`Wren_Idle_Boxing`** (818,231 B — well above the ~395 KB baseline, so it carries real keyframe data). The directive itself states *"the current boxing idle is not accepted."*

**`ABP_Wren` AnimGraph, opened live in W3 [V] — 16 nodes:**

| Node | Assigned clip |
|---|---|
| `AnimGraphNode_SequencePlayer_0` | **`Wren_Idle_Boxing`** |
| `AnimGraphNode_SequencePlayer_1` | `Wren_Walk` |
| `AnimGraphNode_SequencePlayer_2` | `Wren_Run` |
| `AnimGraphNode_SequencePlayer_3` | `Wren_Block_Idle` |
| `AnimGraphNode_SequencePlayer_4` | `Wren_Falling_Loop` |

Plus 4 × `BlendListByBool` (driven by 4 `VariableGet` nodes), 1 × `Inertialization`, 1 × `Slot` (DefaultSlot), 1 × `Root` (OutputPose).

This is a **genuine locomotion graph**, not a stub. In Character Select the fighter never moves, so all four booleans stay false and the graph resolves to `Wren_Idle_Boxing`. **The wiring is correct and more capable than previously believed.**

➡️ **This is an animation *content/authoring* problem, not a wiring problem. Nothing in the level needs repointing.** The required work is authoring a kangaroo-boxer bounce (weight shifts through hips/legs, controlled vertical energy, guard that isn't frozen at the face, grounded feet, tail balance) and, for consistency with the other fighters, a `Wren_CS_Idle` — Wren is the **only** animated fighter without a `*_CS_Idle` clip (Atlas, Banjo, Ripper each have one).

**Atlas — claim corrected [V]:** the Edge Energy ultimate **exists** — `Atlas_Edge_CycloneLance_RM.uasset` (229,406 B), plus `Atlas_Sig_EmuKick`. `SM_WindspinePolearm` also imported successfully on a later attempt (750,732 B, Jul 20 14:25) and is referenced by the level. Atlas has 6 light / 6 medium / 6 heavy + full locomotion + presentation clips. No grapple/throw.

**Retarget poses, root-motion flags, bone orientations, socket lists, and AnimBP state-machine contents are all [L].**

---

## 17. UI and controller state

**Widget:** exactly one — `WBP_EE_CharacterSelect`. **No duplicates.** [V] It correctly targets `LV_EucalyptusSummit` (forward) and `LV_MainMenu` (back), and already consumes the brand fonts + `T_UI_Logo_Lockup`.

**Blueprints [V]:** `BP_EE_CharSelectGameMode` ✅ · `BP_EE_CharSelectController` ✅ (abbreviated name) · `BP_EE_CharacterShowcasePoint` ✅ · `BP_EE_CharacterSelectManager` ❌ **missing**

`BP_EE_CharSelectController` references `WBP_EE_CharacterSelect`, `BP_EE_CharacterShowcasePoint`, `Wren_Idle_Boxing`, and — notably — two **Epic Mannequin** clips (`MM_Idle`, `MM_ChargedAttack`), likely leftover placeholder logic. [V] / [L] whether live
`BP_EE_CharSelectGameMode` references only the controller; it does **not** reference a HUD class, Pawn, or the widget. [V]

**🔴 Enhanced Input: no menu/UI input exists.** All 7 Input Actions and 3 Mapping Contexts are Epic template + `Variant_Combat` assets. No `IMC_Menu`, `IA_Navigate`, `IA_Confirm`, `IA_Cancel`, or `IA_Join`. Neither `BP_EE_CharSelectController` nor `BP_EE_MenuController` contains any `EnhancedInput`/`InputAction`/`Gamepad_*` string. Navigation appears to be UMG keyboard focus (`SetKeyboardFocus` present). **[L] confirm the actual mechanism.**

**🟠 Zero gamepad glyph assets.** Only `PCKeyboardMouseIconPack` (100 keyboard/mouse textures). The "small reusable vector prompt system" in the 2D spec has nothing to reuse.

### 🔴 Revision 2 — two runtime errors captured in PIE (W3, A5-live) [V]

This supersedes the Revision-1 claim that CommonUI was "enabled but entirely unused." It is **active at runtime and misconfigured**:

```
LogUIActionRouter: Error: Using CommonUI without a CommonGameViewportClient derived
  game viewport client. CommonUI Input routing will not function correctly.

LogPlayerController: Error: InputMode:UIOnly - Attempting to focus Non-Focusable
  widget SObjectWidget [Widget.cpp(976)]!
```

These are the **mechanical cause of the controller/navigation problem**, and neither was discoverable from disk:

1. **CommonUI's `UIActionRouter` initialises**, but the project sets no `CommonGameViewportClient`, so CommonUI input routing is explicitly non-functional. (Disk was right that no *asset* references `/Script/CommonUI`; it was wrong that the plugin was inert.)
2. The controller enters **`InputMode: UIOnly`** and then attempts to focus a widget that is **Non-Focusable** — so focus never lands, and no navigation input can reach the UI.

### ✅ BOTH FIXED 2026-07-21

**Fix 1 — Non-Focusable widget: DONE and empirically verified.**
`WBP_EE_CharacterSelect` had **`bIsFocusable = false`** on its CDO [V]. Set to `true`, recompiled (value survived compilation), saved — asset written to disk, `is_dirty` back to `false`. Note this property set **did** mark the package dirty, unlike `set_pin_value` (§4.1).
**Verification:** a PIE run before the fix logged the `Attempting to focus Non-Focusable widget` error; a PIE run after the fix **no longer logs it at all.** The error is gone.

**Fix 2 — CommonGameViewportClient: ✅ DONE AND VERIFIED.** After a genuine editor restart the `UIActionRouter` error is **gone** (confirmed by Trevor in the Output Log; I could not confirm from my side because the MCP connection remained bound to the pre-restart instance — see the operational note below).
`[/Script/Engine.Engine]` had no `GameViewportClientClassName`, so the engine default was in use. Added to `Config/DefaultEngine.ini`:
```ini
GameViewportClientClassName=/Script/CommonUI.CommonGameViewportClient
```
The class was verified to resolve before writing (`/Script/CommonUI.Default__CommonGameViewportClient` → `/Script/CommonUI.CommonGameViewportClient`) — a bad class name here would break viewport creation project-wide.
⚠️ **`GameViewportClientClassName` is read at engine startup**, so editing the ini has no effect on a running editor — the fix only appeared after a full process restart.

**🔧 Operational note — stale MCP instance (cost two false "restarted" cycles):** the editor must be launched with **`-ModelContextProtocolPort=8765`** (XAMPP occupies the default 8000). A normally-launched editor exposes no MCP, so the agent connection silently stays bound to the **old, still-running process** — which keeps answering queries and reporting pre-restart state. **Diagnostic:** `GetLogEntries(pattern="Engine is initialized")` returns exactly one entry with the *old* timestamp. If that timestamp predates a change you just made to config, you are talking to a stale instance. Kill stray `UnrealEditor.exe` processes and relaunch with the port flag.

**Related diagnostic still present [V]:** `LogUIActionRouter: Display: Found 0 derived classes when attempting to create action router (CommonUIActionRouterBase)`. This is separate from the viewport client and indicates no project-specific action router exists. Whether it matters depends on how far CommonUI adoption goes — **[L]**, re-assess after restart.

Also verified live: `LogEnhancedInput: Enhanced Input local player subsystem has initialized the user settings!` — the subsystem *does* come up; there simply are no menu mappings for it to route (below). PIE start time 0.454 s.

**Newly observed asset (not previously catalogued):** PIE compiled **`BP_EE_VersusGameMode`** before play — it was dirty. Not in any prior inventory; scope **[L]**.

**⚠️ Per-frame Blueprint waste [V]:** repeated `Accessed None trying to read CallFunc_TryGetPawnOwner_ReturnValue` and `CallFunc_GetMovementComponent_ReturnValue`. The AnimBP EventGraphs assume a **Pawn** owner, but Character Select uses **`SkeletalMeshActor`s**. Harmless for a static idle, but it is real per-evaluation Blueprint cost plus log spam on every fighter — and the only Tick-related cost that could be substantiated without `stat`.

**🟡 Gamepad deadzone `0.250000`** on all four stick axes (`DefaultInput.ini` lines 18–21) — aggressive for menu navigation. `DefaultPlayerInputClass`/`DefaultInputComponentClass` are correctly set to the EnhancedInput variants.

**Reusable branding [V]:** `T_UI_Logo_Lockup`, `EE_logo`; fonts `EE_Font_Title/Header/Body/Button/Small`, `Verdantia_Font`, `Cinzel`, `EdgeSans-Inter`; 65 UI textures under `MainMenu\UI\01_ImportToUnreal\` (bars, buttons, brand) — **including 6 unused `T_UI_Bar_Loading_*` textures.**

---

## 18. Loading-screen state — **MISSING**

**No loading screen exists.** [V]
- No loading/transition/preload widget or Blueprint anywhere in `Content/`.
- `TransitionMap=` is **empty** → every `OpenLevel` is a synchronous blocking load with a frozen final frame.
- No `PreLoadScreen`/`LoadingScreen` plugin or config. The only MoviePlayer config is a **startup movie**, and it is broken:
```ini
[/Script/MoviePlayer.MoviePlayerSettings]
bWaitForMoviesToComplete=False
bMoviesAreSkippable=True
+StartupMovies=PhoenixGold Logo3D
```
`Content\Movies\` does not exist; `Content\EE_ProjectFiles\Videos\` is empty. The only trace is an autosave.
- Loading-bar **art exists and is unreferenced** (6 textures).

---

## 19. File-organization state

**Character Select folders present [V]:** `Blueprints`, `Level`, `Materials`, `Widgets`. **Absent:** `Environment/` (and therefore all of `Landscape/`, `Water/`, `Foliage/`, `Props/`), `Data/`, `UI/`, `Validation/`.

**Violations [V]:**
- `WaterZone_0`, `BuoyancyManager_0`, `Landscape2_WaterBrushManager_0`, and both orphan `SkeletalMeshActor`s sit at **outliner root** instead of a folder
- `TasModel/Animations/` breaks the `Anims/` convention used by all other fighters
- No `Production`/`Review` animation split exists for any character
- Raw source files inside `Content/`: `WrenRedesign.png` (2.1 MB), `Wren_Validation.fbm/` (2 JPGs, 10.5 MB)
- ~10 MB of duplicated Echo textures (root copies ~4× larger than the `EchoPlaty/` copies)
- Stray extra skeletons: `RiggedKiri0_Open_A_UE5`, `RiggedKiri0_T-Pose`, `RiggedKoda0_Open_A_UE5`, `RiggedKoda0_T-Pose`
- Two stub LevelSequences name-colliding with real AnimSequences
- Duplicate font assets in two folders
- `WBP_MainMenu` lacks the `EE_` infix used by every other EE widget

---

## 20. Recommended execution order

Ordered by **unblocking value ÷ risk**, not by the original stage numbering.

### Tier 0 — Stop-the-bleeding (small, high value)
1. ~~Fix the two dead map references~~ — ✅ **DONE 2026-07-21, verified on disk** (§4.1). 3 nodes repointed, both Blueprints compiled + saved, 0 dead refs remain. **The playable flow is restored.**
2. **Rule on the Summit collateral (§4.4)** — restore `MTL_MWAM_AutoMaterial_MASTER` from the LFS blob, and **fork a Character-Select-only material instance** so Summit stops being collateral.
3. ~~Resolve the level drift~~ — **RESOLVED, dropped from the critical path** (§4.6). Only a fresh in-editor **Map Check** before the next save remains.
4. **Declare the `Water` plugin explicitly** in the `.uproject`, or remove the water actors. Do not leave it on a transitive dependency of an experimental plugin.
5. ~~Set a `CommonGameViewportClient`~~ — ✅ **DONE and verified 2026-07-21**; `UIActionRouter` error gone after restart (§17).
6. ~~Make the focused widget Focusable~~ — ✅ **DONE and verified 2026-07-21**; the Non-Focusable error no longer appears in PIE (§17).

### Tier 1 — Unblock measurement
5. **Capture the FPS baseline** (`stat unit` / `stat gpu` / `stat rhi`) and decide the renderer budget (§10). Everything downstream is guesswork without this.

### Tier 2 — Agent E
6. **E1** quarantine the 5 failed waterfall actors → Map Check → save.
7. **E2** waterfall design spec against the real 37° terrain (§14).
8. **E3** author the ribbon mesh + `M_EE_WaterfallBody` + `BP_EE_SplineWaterfall`; acceptance gate; **stop and report.**

### Tier 3 — Landscape
9. **L1** — this is a **rebuild, not an extension** (§12). Decide: new mask-driven biome master (uses the nine existing masks, requires authoring Layer Infos) vs. MWAM as base coat + regional control layered on top. Author Layer Infos either way.

### Tier 4 — Characters
10. **Wren bounce idle** — authoring task, not rewiring (§16). Add `Wren_CS_Idle` for parity.
11. **Echo** — import the mesh or formally defer Echo and stub the actor/ABP to clear the compile error.
12. **C1** showcase states — scope to the 4 viable fighters.
13. **IK Rigs + Retargeters** — prerequisite for Koda/Kiri/Echo ever sharing animation.

### Tier 5 — Front-end
14. **Menu Enhanced Input** (`IMC_Menu` + confirm/cancel/navigate/join) — prerequisite for all controller work. Note `CommonUI` is **already active**, just misconfigured (Tier 0 items 5–6); fixing it is cheaper than building a parallel input path.
15. **2D** camera cycling + compact ≤15% UI.
16. **V1** weapon/attack trails.
17. **F1** frame-rate policy — largely already correct; validate rather than change.
18. **LS1** loading screen (art already exists).

### Tier 6 — Last
19. **O1** file organization — highest reference-breakage risk, lowest urgency. Content Browser moves only.

---

## Standing cautions

1. **Run a fresh in-editor Map Check before the next save.** (The Revision-1 "do not save — level is dirty" caution is withdrawn; the orphan actors were transient PIE residue, §4.6. Map Check cannot be triggered via MCP — no console-exec exists.)
1b. **Do not treat a mid-PIE actor count as authoritative** — PIE/Simulate temporarily inflates enumeration on this map.
2. **Use `grep -a`** for every binary reference check. The default tool lies by omission.
3. **`Content\EE_ProjectFiles\CharacterSelect\` is untracked by git.** No safety net. Back up before destructive work.
4. **Never delete** `SoulCave/`, `_SplineVFX/`, `MWLandscapeAutoMaterial/`, `A_Surface_Footstep/` — shared marketplace content used by other maps.
5. **Verify before trusting any prior "done" claim**, including claims in this report's own history. Three separate assumptions were overturned during this audit.
