# Character Selection — Placement & Camera Pass Report

**Date:** 2026-07-21
**Scope:** Character grounding, facing, showcase anchors, and showcase camera authoring.

**Status: PARTIAL.** Grounding, facing, anchors and camera authoring are complete and verified. **Atlas weapon attachment and PIE validation were NOT performed** — see §8, §11.

Tags: **[V]** verified live · **[L]** requires live audit · **[X]** not done

---

## 1. Canonical level

`/Game/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelection` — not renamed, no `LVI_CS_*` restored, landscape heightmap and material untouched, no water/foliage/props/Niagara added. [V]

Saved to disk; `is_dirty` → false after save. [V]

---

## 2. Overview camera — PRESERVED UNCHANGED [V]

**Actor:** `CSCam_Overview` (internal `CameraActor_7`), tag `CSCam_Overview`

| | Expected | Actual |
|---|---|---|
| X | −20201.170722 | −20201.170722 |
| Y | −13143.564968 | −13143.564968 |
| Z | 6837.495961 | 6837.495961 |
| Pitch | −16.600000 | −16.600000 |
| Yaw | 28.799998 | 28.799998 |
| Roll | 0.0 | 0.0 |
| Scale | 1,1,1 | 1,1,1 |

**Maximum delta across all six values: `0.0`.** Not moved, rotated, deleted, renamed, or replaced. Terrain clearance +724 cm.

---

## 3. Character actor table [V]

All seven are class **`SkeletalMeshActor`** — **not** `Character`. There is therefore **no capsule, no CharacterMovement, no gravity, and no floor detection anywhere in this map.** Several assumptions in the brief (capsule half-height, simulate-physics, gravity state, floor detection) do not apply.

| Fighter | Internal | Mesh | AnimBP | Final location | Yaw | Feet vs ground |
|---|---|---|---|---|---|---|
| Koda | SkeletalMeshActor_1 | `RiggedKoda` | `ABP_Koda` | 3000, 3200, **4150.86** | −72.0 | **0.00 cm** |
| Wren | SkeletalMeshActor_2 | `WrenKangaroo` | `ABP_Wren` | 12600, −1200, **3432.42** | 63.0 | **−0.27 cm** |
| Ripper | SkeletalMeshActor_3 | `SK_Ripper` | `ABP_Ripper` | −7600, −11200, **2861.84** | −27.0 | **−1.31 cm** |
| Kiri | SkeletalMeshActor_4 | `RiggedKiri` | `ABP_Kiri` | 4000, 16100, **8579.40** | −72.0 | **0.00 cm** |
| Echo | SkeletalMeshActor_5 | **NONE** | `ABP_Echo` | −14500, 500, **1425.04** | 18.0 | origin on ground |
| Banjo | SkeletalMeshActor_0 | `SK_Banjo` | `ABP_Banjo` | −14100, 13400, **3979.87** | −117.0 | **0.00 cm** |
| Atlas | SkeletalMeshActor_6 | `SK_Atlas` | `ABP_Atlas` | 3800, −18700, **8324.69** | 108.0 | **0.00 cm** |

All at **pitch 0 / roll 0**, scale 1,1,1 — within the ±2° tilt standard. All within the grounding tolerance (0–2 cm above acceptable; >2 cm penetration = fail).

### ⚠️ Critical methodology finding — trace contamination

**A downward trace at a fighter's XY hits that fighter's own collision, not the terrain.** Early measurements reported Koda as "buried 148 cm" when the trace was reading his own head (4627 ≈ his bounds max 4629).

This affects **every** fighter, not only those with Physics Assets. Two fighters (Atlas, Echo) were briefly displaced off contaminated readings before this was caught; both were corrected.

**All final heights use neighbour-averaged ground** — four traces at ±250 cm around the fighter, averaged. This is the only uncontaminated method available and must be used for any future placement work in this map.

---

## 4. Wren diagnosis [V]

**She was never floating or falling.** Measured state before this pass: feet **19.7 cm below** ground on **1.1° terrain** — slight penetration, not float.

Cause ruled out, definitively:

| Candidate | Verdict |
|---|---|
| Actor placement | ✅ **This was the only real defect** — 19.7 cm penetration, now 0.00 cm |
| Capsule / mesh offset | N/A — no capsule exists (`SkeletalMeshActor`) |
| Root motion | N/A — no CharacterMovement, no root motion consumer |
| Gravity / physics | **Impossible** — no gravity in this map; nothing can fall |
| Retargeting | N/A — **zero IK Rigs / Retargeters exist project-wide** |
| Idle animation content | ⚠️ **Remaining suspect** — see below |
| Loop continuity | **[L]** not measured |

`ABP_Wren` was opened live: it is **not** a stub. 16 nodes — 5 SequencePlayers (`Wren_Idle_Boxing`, `Wren_Walk`, `Wren_Run`, `Wren_Block_Idle`, `Wren_Falling_Loop`), 4 `BlendListByBool`, Inertialization, Slot, OutputPose. In Character Select nothing moves, so all booleans stay false and it resolves to **`Wren_Idle_Boxing`**.

**Conclusion:** the placement defect is fixed. Any *remaining* visual issue is **animation content in `Wren_Idle_Boxing`** — which the directive already states is not accepted. That is an authoring task, not a placement or retarget task. Per instruction, she was **not** "fixed" by raising the actor beyond true ground contact, and no Level-Blueprint counter-animation was added.

**Not verified [L]:** foot drift across a full loop, loop-start/end discontinuity, tail/hip visual centre. These need animation-editor inspection, not placement work.

---

## 5. Atlas weapon diagnosis — **[X] NOT PERFORMED**

This was **not** addressed in this pass. Known state from the prior audit:

| Item | State |
|---|---|
| Polearm asset | `/Game/EE_ProjectFiles/Characters/AtlasEmu/Weapon/SM_WindspinePolearm` — **exists** (750,732 B, StaticMesh), referenced by the level [V] |
| Weapon component on Atlas | **None** — `Fighter_Atlas` has no weapon component or child actor [V] |
| `WeaponSocket_R` on `hand_r` | **[L] unverified** |
| Attachment rule | **[L]** not configured |
| Support-hand IK (`SupportHand_IK`) | **[L]** unverified; **zero IK Rigs exist project-wide**, so support-hand IK is almost certainly absent |
| Result | **Atlas is not holding his polearm.** Unchanged by this pass. |

Atlas's *placement* is correct (0.00 cm, flat 1.8° ground, 195 cm canon height confirmed by bounds).

---

## 6. Showcase anchor table [V]

Existing `BP_EE_CharacterShowcasePoint` actors serve as anchors; **no new anchor Blueprint was created** (an equivalent canonical actor already exists, per instruction). Anchors for relocated fighters were moved to match.

| Fighter | Anchor actor | Ground transform | Region | Status |
|---|---|---|---|---|
| Koda | `BP_EE_CharacterShowcasePoint_C_0` | 3000, 3200, 4137.8 | Sanctuary | **moved 31.6 m** |
| Wren | `_C_1` | 12600, −1200 | Grassland | unchanged |
| Ripper | `_C_2` | −7600, −11200 | Woodland | unchanged |
| Kiri | `_C_3` | 4000, 16100, 8563.6 | High perch | **moved 22.4 m** |
| Echo | `_C_4` | −14500, 500 | Wetland | unchanged |
| Banjo | `_C_5` | −14100, 13400, 3979.9 | Upper canopy | **moved 36.1 m** |
| Atlas | `_C_6` | 3800, −18700 | Outback | unchanged |

FighterID tags intact, so tag-based selection still resolves. **Anchor yaw is 180 on all seven** and does not match fighter yaw — see §11.

### Why three fighters moved

Koda, Kiri and Banjo were on **~44.5° cliff faces** and airborne (Koda **+20.3 m**, Kiri **+12.9 m**, Banjo **+5.6 m**). A ±40 m search found **no ground under 10°** near Koda or Kiri, and only one sub-5° spot near Banjo.

**This heightmap contains no flat showcase pads at all.** The metadata promised 9–11 m flat radii; actual terrain is uniformly 10–60° alpine rock. Ripper, Atlas, Wren and Echo are well-grounded only by luck of where their XYs landed. Relocation to ~10° ground was approved as the compromise: at 10° the height difference across a character's foot span is ~7 cm (imperceptible) versus ~39 cm at 44° (visibly broken).

**Cost:** Banjo dropped from ~80 m to **39.8 m** elevation, weakening his "upper canopy" altitude. Koda lost ~3 m, Kiri ~13 m.

---

## 7. Camera table [V]

Lens held at **50 mm equivalent** (39.6° horizontal FOV; Atlas 35.0° ≈ 57 mm). All seven reuse existing canonical `CSCam_*` actors — **no suffixed duplicates created**.

| Camera | Location | Pitch | Yaw | FOV | Dist | Backdrop intent | Terrain clearance |
|---|---|---|---|---|---|---|---|
| `CSCam_Koda` | 3000, 3996, 4301.8 | −5.53 | −90.0 | 39.6 | 796 | gentle +7 m rise, natural framing | **+241 cm** |
| `CSCam_Wren` | 11921.1, −1878.9, 3610.4 | −5.50 | 45.0 | 39.6 | 960 | open sunlit rise | **+198 cm** |
| `CSCam_Ripper` | −8181.9, −10618.1, 3032.4 | −5.50 | −45.0 | 39.6 | 823 | +35 m wall, enclosed woodland | **+233 cm** |
| `CSCam_Kiri` | 4000, 16977.9, 8744.1 | −5.50 | −90.0 | 39.6 | 878 | terrain drops → sky, high perch | **+401 cm** |
| `CSCam_Echo` | −15405.3, 500, 1611.2 | −5.50 | 0.0 | 39.6 | 905 | faces wetland basin | **+192 cm** |
| `CSCam_Banjo` | −14565.6, 12934.4, 4115.3 | −5.50 | 45.0 | 39.6 | 658 | +43 m layered depth | **+305 cm** |
| `CSCam_Atlas` | 3800, −19921.7, 8559.3 | −5.50 | 90.0 | 35.0 | 1222 | terrain drops → open horizon | **+197 cm** |
| `CSCam_Overview` | *(preserved, §2)* | −16.60 | 28.80 | — | — | opening vista | +724 cm |

All pitches **−5.5°**, inside the −2° to −10° preference. All clearances positive — **no camera underground**.

Camera transforms were computed, not dragged: `CameraPos = T − (D × dist) + (up × heightOffset)`, with look-at rotation derived from `CameraPos → T`. Target point = ground + 60% of character height.

### ⚠️ Conflict in the brief — resolved in favour of framing

Your suggested distances (e.g. Koda 500–700 cm) at 50 mm produce **61–86% screen height**, well outside your 35–55% framing rule. Distance, lens and framing cannot all be satisfied simultaneously.

**Resolution:** lens (50 mm, stated preference) and framing (**45% screen height**, the actual visual requirement) were held; **distance was allowed to exceed the suggested ranges**, since those were explicitly "starting ranges only." Camera heights all landed *inside* your suggested per-fighter ranges.

### ⚠️ Three cameras were initially underground

Koda (−52 cm), Kiri (−321 cm) and Banjo (−154 cm) were buried on the first authoring pass — increasing distance for correct framing drove them into rising hillsides. Fixed by re-selecting camera direction to the downhill side. Koda required a 16-direction sample at the true camera radius (796 cm), because 25 m/60 m samples did not describe his lumpy local terrain.

---

## 8. PIE validation — **[X] NOT PERFORMED**

None of the following was run:

- Full roster cycle Wren → Ripper → Koda → Kiri → Echo → Banjo → Atlas → Wren
- 10× repeated cycle test
- Three full idle loops per fighter; highlight / deselect / confirm states
- Foot contact through animation
- Atlas weapon persistence
- UI safe-zone check against the live widget
- 1920×1080 and 2560×1440 framing checks
- Map Check, Output Log, Message Log, FPS

**Screen-height figures in §7 are analytical, not measured.** `CaptureViewport` renders at the *editor viewport's* FOV (~90°), **not** the camera actor's FOV, so it cannot validate FOV-dependent framing. Real framing validation requires possessing each camera in PIE.

**Map Check cannot be triggered via MCP** (no console-exec tool exists) and must be run in-editor before further work.

---

## 9. Assets created

**None.** No new Blueprint, anchor class, camera, or content asset was created.

---

## 10. Assets modified

- `/Game/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelection` — the only modified asset. Changes confined to actor transforms (7 fighters, 3 showcase anchors, 7 cameras) and camera `FieldOfView`.

No material, animation, AnimBP, IK asset, widget, controller graph, or landscape asset was touched.

---

## 11. Deferred issues

| # | Issue | Severity |
|---|---|---|
| 1 | **Heightmap has no flat showcase pads.** The durable fix is authoring real pads; all current placement is a compromise around 10–11° ground. Explicitly out of scope per instruction. | **High** |
| 2 | **Atlas weapon attachment not done.** No weapon component; socket/attachment pipeline unverified. | **High** |
| 3 | **Atlas support-hand IK** — zero IK Rigs exist project-wide, so almost certainly absent. | **High** |
| 4 | **Wren idle content** — `Wren_Idle_Boxing` plays correctly; the clip itself is the rejected asset. Authoring task. | **High** |
| 5 | **Wren has no `Wren_CS_Idle`** — the only animated fighter lacking one (Atlas/Banjo/Ripper each have one). | Medium |
| 6 | **Echo has no mesh/skeleton**; `ABP_Echo` fails to compile ("skeleton asset missing"). Placement is a stub. | **High** |
| 7 | **Koda and Kiri have zero animations** — showcase states unachievable for them. | **High** |
| 8 | **Zero IK Rigs / Retargeters project-wide** — Koda/Kiri/Echo cannot borrow animation. | **High** |
| 9 | **Banjo production-model status** — placement is **provisional**; do not build permanent animation assumptions on the current mesh. His elevation also dropped ~40 m. | Medium |
| 10 | **Showcase anchor yaw is 180 on all seven** and does not match fighter yaw. Harmless if anchors are position-only; must be reconciled if anything reads anchor rotation. | Medium |
| 11 | **PIE validation, UI safe zones, resolution checks, Map Check** — all outstanding (§8). | **High** |
| 12 | **Camera transition system not implemented** — no blend/fade logic authored; transitions remain whatever the controller currently does. | Medium |
| 13 | **Weapon trails, Edge Energy attacks, waterfall/environment dependencies** — unchanged, still outstanding. | Low (this pass) |

---

Character placement and showcase camera pass complete. CSCam_Overview preserved at the user-approved transform.
