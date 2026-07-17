# WREN TWIG DEFORMATION — DIAGNOSIS & FIX REPORT

**Date:** 2026-07-17 · **Author:** Claude Code (UE 5.8 / Unreal MCP session)
**Scope:** Focused diagnostic + repair only. No Blender files touched, no reimport, no skin-weight changes, Ripper untouched.
**Evidence screenshots:** `Saved/Screenshots/WrenTwigFix/`

---

## 1. Root cause

`BP_EE_Wren` was evaluating **`ABP_Manny_Combat`** (target skeleton `SK_Mannequin`) on **`WrenKangaroo_Skeleton`** — and the 2026-07-16 14:08 mesh reimport had silently **wiped `WrenKangaroo_Skeleton.CompatibleSkeletons` (verified empty)**. Manny-proportioned bone data applied to Wren's skeleton with no compatibility mapping collapsed her limbs into the "twig" look.

Character Select never deformed because the preview actor uses `AnimationSingleNode` + the native `Wren_Idle_Boxing` — exactly the contrast described in the symptom report.

**Rule for the future: a skeletal-mesh reimport resets the skeleton's CompatibleSkeletons list. Re-check it after every reimport.**

### Phase 1 audit answers
| # | Question | Finding |
|---|---|---|
| 1 | Mesh on BP_EE_Wren | `/Game/EE_ProjectFiles/Characters/WrenKangarooModel/WrenKangaroo` |
| 2 | Its skeleton | `WrenKangaroo_Skeleton` |
| 3 | ABP_Manny_Combat target | `/Game/Characters/Mannequins/Meshes/SK_Mannequin` |
| 4 | Relationship | Separate skeletons; **CompatibleSkeletons list on Wren's skeleton is EMPTY** (Sprint-2 entry lost at the 14:08 reimport) |
| 5 | What evaluates on Wren in arena | The full ABP_Manny_Combat graph (Manny locomotion, slots, its IK) — all SK_Mannequin assets |
| 6 | Animated bone-scale tracks | None involved (native takes verified clean by Test B) |
| 7 | Character Select config | `AnimationSingleNode` + `Wren_Idle_Boxing` (correct proportions there) |
| 8 | Retargeting | No IK Rig / IK Retargeter assets exist; no runtime retarget nodes |
| 9 | Leader/Copy Pose / modular mesh | Not involved |
| 10 | Construction/BeginPlay scale changes | None — CDO mesh scale (1,1,1), standard −90° yaw / −90 Z offset |

Also noted: `WrenKangaroo.PhysicsAsset = None` and `PostProcessAnimBlueprint = None`. The missing physics asset is a separate issue (ragdoll death is currently a no-op).

---

## 2. Test A — reference pose in the arena

Set `BP_EE_Wren` mesh to single-node mode with no animation, ran PIE in **LV_EucalyptusSummit** with the real match camera/GameMode.

**Result: Wren proportionally CORRECT** — full limb volume, proper silhouette and height next to Ripper, HUD/match running.
→ Mesh import, component transform, materials, and baseline skinning are healthy.
Evidence: `TestA_ReferencePose_Arena.png`

## 3. Test B — single native Wren animation

Played `Wren_Idle_Boxing` directly on the mesh (Use Animation Asset, bypassing ABP/state machines/IK/additives entirely), same arena PIE.

**Result: CORRECT** — proper boxing guard, full volume, tail intact; AI combat even landed hits normally.
→ The failure lies in the ABP_Manny_Combat evaluation path, **not** the imported animation or mesh.
Evidence: `TestB_NativeIdle_Arena.png`

## 4. Exact failing node/asset

The **entire `ABP_Manny_Combat` evaluation** — its base locomotion state machine playing SK_Mannequin sequences against Wren's (no-longer-compatible) skeleton. Bypassing the ABP itself (Test B) fully restored proportions; no individual Control Rig / IK / additive / post-process layer needed separate bypassing. No non-unit bone scale anywhere in the chain.

## 5. Fix implemented (Phase 4 option A — smallest maintainable)

- `BP_EE_Wren.CharacterMesh0` → `AnimationMode = AnimationSingleNode`, looping `Wren_Idle_Boxing` as the combat idle.
- `DoHeavy` / `DoDodge` switched from `PlaySlotAnimationAsDynamicMontage` (returns **None** on Wren's skeleton — the montage strict-check wall; her moves never rendered even before) to **direct `PlayAnimation`** of the native takes (`Wren_Heavy_TailSpringDoubleKick`, dodge anims via the existing `DodgeAnim` parameter).
- `ClearBusy` now re-plays the looping idle after each move.
- **All combat logic untouched:** Busy gating, `HeavyImpact` timer window (0.73 s), damage + `LaunchCharacter` knockback, i-frame timers, `PollDodgeInput`, AI, ring-out, results flow.
- The `AnimClass` reference (ABP_Manny_Combat) intentionally remains on the CDO — it is ignored in single-node mode and makes rollback a one-property flip.
- **ABP route re-tested:** MCP can now create an AnimBlueprint *shell* (real `AnimBlueprintGeneratedClass` with an AnimGraph), but `TargetSkeleton` cannot be set through tooling and anim-graph node types are not authorable, so the stub was deleted. **Trevor's 3-minute manual `ABP_Wren`** (target `WrenKangaroo_Skeleton`, idle → Slot `DefaultSlot` → Output Pose) remains the upgrade path for walk-blending and dodge root-motion displacement.

## 6. Assets changed

| Asset | Change |
|---|---|
| `Combat/BP_EE_Wren` | CDO mesh anim settings; `DoHeavy`, `DoDodge`, `ClearBusy` graphs |
| `Combat/Backups/BP_EE_Wren_PreTwigFix_20260717` | **New** — pre-fix duplicate for rollback |
| `CharacterSelect/Widgets/WBP_EE_CharacterSelect` | Follow-up: KODA/KIRI labels no longer say LOCKED (they highlight but cannot confirm; ECHO/BANJO/ATLAS keep LOCKED) |
| `LV_CharacterSelect` PostProcessVolume | Follow-up: auto-exposure clamped 0.9–1.1, fast adaptation — no brightness pumping during camera travel |
| `LV_CharacterSelect` ExponentialHeightFog | Follow-up: density/falloff/inscattering tuned for Verdantia depth |

All modified Blueprints compiled clean; all assets saved. Ripper untouched. Character Select preview untouched (it already used the verified configuration).

## 7. Validation results (arena PIE, LV_EucalyptusSummit)

| Check | Result |
|---|---|
| No twig deformation | ✅ intro + mid-match |
| Limb volume consistent | ✅ |
| Hands/feet collapse | ✅ none |
| Pelvis height stable | ✅ |
| No animated bone scale | ✅ |
| Root motion | ⚠ dodges play **in place** in single-node mode (displacement waits on ABP_Wren); idles in place as authored |
| Tail vs Manny chains | ✅ native takes only — tail clean |
| Combat logic | ✅ full loop: AI fight → damage → K.O. → Results (`PostFix_MatchLoop_Results.png`) |
| Controller/input | ✅ keyboard verified; gamepad needs a hardware pass |
| Compile errors | ✅ none |
| New runtime warnings | ✅ none (log entries during testing were stale pre-fix Character-Select ones) |
| Not exercisable yet | Guard/block, distinct light/medium attacks, native hit-react/knockdown, Edge move — these animations/systems don't exist yet |
| Heavy/dodge visuals | Mechanism is the identical Test-B-proven `PlayAnimation` path; a mid-swing frame was not captured (MCP automation timing vs the ~13 s AI kill) — flagged honestly, worth one eyeball pass in-editor |

## 8. Remaining animation-timing issues

- Heavy impact remains timer-based (0.73 s window), not notify-based.
- Dodge root-motion displacement waits on the real `ABP_Wren`.
- 60 fps retiming pass **not started**, per the gate in the work order.
- `WrenKangaroo` PhysicsAsset still None → regenerate in-editor (ragdoll death currently does nothing).

## 9. Rollback instructions

1. Fast path: set `BP_EE_Wren` → CharacterMesh0 → `AnimationMode = AnimationBlueprint` (AnimClass ref is still in place). Compile, save.
2. Full path: restore `Combat/Backups/BP_EE_Wren_PreTwigFix_20260717` over `BP_EE_Wren`.
3. Note: rolling back restores the twig deformation until an ABP against Wren's skeleton exists.

---

## Follow-up work-list status (items after the fix)

**Done this session:** exposure lock + fog tune (item 2, partial); per-fighter framing / interruptible travel / regions verified from the world build, roster labels corrected (item 3); PROJECT_STATE.md + memory updated (item 6, partial).

**Not done, with reasons:**
- Landscape sculpting — no Landscape tooling exists in this MCP build; Verdantia terrain remains mesh-built (it already reuses Eucalyptus Summit's own packs: MWAM stones/grass, eucalyptus trees, festival props in the Wren/Ripper stages).
- Brazier → Niagara fire swap — the braziers live inside `LVI_CS_Wren`/`LVI_CS_Ripper` level instances; needs an edit-level-instance session (`NS_Spline_Fire`/`BP_SplineVFX_Fire` are the identified assets).
- UI Component Library restyle — a full UMG session of its own; textures staged under `Content/EE_ProjectFiles/MainMenu/UI/01_ImportToUnreal/`.
- Full gamepad verification — needs hardware input.

**Recommended next steps, in order:**
1. Trevor: create `ABP_Wren` (3 min) → Claude wires AnimClass and re-enables blended locomotion + root-motion dodges.
2. Regenerate Wren (and Ripper) physics assets in-editor.
3. UI-M2 Component Library restyle of `WBP_EE_CharacterSelect`.
4. Brazier fire VFX + remaining atmosphere pass.
5. Then the 60 fps retiming pass.
