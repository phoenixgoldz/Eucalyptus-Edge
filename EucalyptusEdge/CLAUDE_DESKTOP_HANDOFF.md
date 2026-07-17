# CLAUDE DESKTOP HANDOFF — Blender/Source-Art Work Orders

**From:** Claude Code (UE 5.8 side) · **Date:** 2026-07-17 (rev 3)
**For:** Claude Desktop (Blender / source asset side)
**Read together with:** `WEAPON_SOCKET_AND_FACIAL_RIGGING_STANDARD.md` (LOCKED — do not modify), `PROJECT_STATE.md` (current state + permanent Performance Standard), `STYLE_GUIDE.md` (visual canon).

---

## REV 3 STATUS UPDATE (2026-07-17) — read this first; supersedes rev 2 where they conflict

- **WO1 (Wren morphs) — DELIVERED AND IN ENGINE.** Your 14:07 `WrenKangaroo.fbx` re-export was reimported over the production mesh at 14:08. The production asset now carries **real, named morph targets**: `Jaw_Open`, `Blink_L`, `Blink_R`, `EyeLook_L`, `EyeLook_R`, `Smile` — six confirmed by direct asset inspection. Rev 2 referenced 9 rebuilt keys: if your final export contained more than these six, the extras either carried empty deltas (UE silently discards those on import) or use names outside the expected set — please send the exact shipped key list so we can reconcile 6-of-6 vs 6-of-9. Either way the pipeline is **proven end-to-end now**; keep authoring the rest of the §7 set (brows, frown/snarl, cheek/muzzle compression, visemes) with the identical export settings.
- **Wren material upgrade received:** `Wren_Tex_Base` / `Wren_Normal` / `Wren_MatBase` imported 13:28 and replace the old tripo placeholder material chain (now removed).
- **WO2 — major Wren delivery received and WIRED:** `Wren_Dodge_BackHop`, `Wren_Dodge_Bound_L`, `Wren_Dodge_Bound_R`, `Wren_Heavy_TailSpringDoubleKick`, plus the re-exported `Wren_Idle_Boxing` all imported clean onto the production 129-bone skeleton (no new skeleton — exactly right) and live under `Characters/WrenKangarooModel/Anims/`. Gameplay is wired around them already: heavy fires damage at the F22 impact frame (0.73 s window, tunable), dodges run root motion with i-frames (0.08–0.55 s). Two notes:
  1. **Playback is temporarily gated by a UE-side wall, not your exports** — UE 5.8 strict-checks skeletons on every montage path, so the takes need a native `ABP_Wren` AnimBlueprint (3-minute editor step queued for Trevor). No Blender action; keep delivering.
  2. **Naming ask:** prefix the FBX filenames with the fighter (`Dodge_BackHop.fbx` → `Wren_Dodge_BackHop.fbx`); UE side renamed on import this round.
- **Ripper — still blocked on source (unchanged from rev 2).** Desktop `RipperModel/Ripper_Tas.fbx` is still the 4 KB empty export; UE continues to run on `Ripper_Tas_original_backup`, and `Ripper_Idle_Aggressive` remains skeleton-less. We can see active work in `RipperRetopo.blend` — when the retopo/re-rig is done, export per WO3 + the rev 2 export rules and the UE side will run the 4-step swap (import at original name → CompatibleSkeletons edit → re-point `BP_EE_Ripper` + select preview → rebind the idle).
- **WO4 unchanged** — the template falling state covers airborne fighters meanwhile; bespoke Launch / Falling / Land / Victory takes are still wanted, Wren first.
- **Housekeeping (context, no action):** both characters' physics assets were removed in the asset churn; UE side regenerates them in-editor. Separately, `FOR_CLAUDE_DESKTOP_BLENDER.md` (UI prop-artist package) is a **different track** — this document remains the character/animation work-order channel.

---

## REV 2 STATUS UPDATE (2026-07-16 evening)

- **WO1 (Wren morphs) — root cause CONFIRMED on the UE side, matches your delta audit.** I binary-parsed the production FBX: all 91 blendshape channels are wired correctly but carry float-noise deltas (max 7.15e-07; even the Jul 6 AccuRIG backup only 3.8e-05). UE imported with morphs **enabled** and correctly discarded empty targets — never an import-settings problem. Your 9 rebuilt real keys await **Gate A** (Trevor's slider test); after that, re-export per WO1 below. UE will verify by **measured deltas**, not key count.
- **WO2 partial delivery received and WIRED:** `Wren_Idle_Boxing` imported clean (61 f loop @30 fps) and now drives Wren's Character Select presentation idle **and** the lock-in close-up. Loop seam reads clean in-engine. 
- **Two Ripper deliveries FAILED on import — need re-export:**
  1. `RipperModel/Ripper_Tas.fbx` (mesh reimport, 17:50) → Interchange error *"There was nothing to import from the provided source data"* — usually an empty selection with selection-only export, or no mesh/armature objects in the exported set. The old UE assets were renamed to `Ripper_Tas_original_backup` before the attempt, so UE temporarily lost Ripper entirely; I've re-pointed `BP_EE_Ripper` + the select preview at the backup until a good export lands at the original name.
  2. `Ripper_Idle_Aggressive` (anim) imported but **bound to no skeleton** (asset-check error "This anim sequence asset has no Skeleton") — likely exported without the armature or against a mismatched armature name. Re-export as armature-only take per the export rules in WO2.
- **Interim animation solution live in UE (context, no action needed):** both fighters' skeletons now list the template `SK_Mannequin` as a compatible skeleton and run the template combat AnimBlueprint — so idle/locomotion/attacks play *today*. Native takes remain strictly better (Manny proportions ≠ Wren/Ripper); keep authoring.

## NEW WORK ORDER 4 — Ring-out / knockback set (design locked by Trevor today)

Ring-out presentation now has a defined sequence (hit → launch → falling → camera track → fade → RING OUT → winner pose). Each fighter eventually needs, reusable everywhere:
- **Launch** (hit reaction into airborne, ~0.5 s)
- **Falling** (loop, limbs flailing, readable silhouette)
- **Land** (for non-ring-out knockdowns; pairs with the existing knockdown get-up order)
- **Victory pose** (already in WO2 item 3 — now doubles as the ring-out winner pose)

Same export rules as WO2. Wren first (production skeleton is stable); Ripper after his source check clears.

---

## What happened on the UE side (context)

Your corrected `WrenKangaroo.fbx` (exported 2026-07-16 04:00) was imported clean into UE 5.8, validated, and **promoted as the production Wren mesh**:

| Check | Result |
|---|---|
| Bone count | ✅ 129 |
| Tail chain | ✅ `tail_01`–`tail_07` + `ctrl_tail_root/mid/tip` + `TailPlant_IK` present |
| Bone naming | ✅ Manny convention incl. `ik_hand_*` / `ik_foot_*` |
| Height | ✅ exactly 175 cm, feet at Z = 0 |
| Scale chain | ✅ 1.0 end-to-end, no import rotation, no compensation anywhere |
| Reference pose | ✅ upright, no stretching, faces correctly with the standard −90° component yaw |
| **Morph targets** | ❌ **ZERO imported — the FBX contains no shape keys** (verified through two independent UE import paths) |

`BP_EE_Wren` (combat) and the Character Select preview are already repointed to the new mesh/skeleton/physics asset. The vertical slice (Main Menu → in-world Character Select → Wren vs Ripper match → Results) runs end-to-end on it.

---

## WORK ORDER 1 — Re-export Wren WITH shape keys (highest priority)

The export was otherwise perfect. **Change nothing except getting the facial morph targets into the file.**

Blender FBX export gotchas that silently strip shape keys:
- **Geometry → Apply Modifiers must be OFF** — Blender cannot export shape keys from a mesh with modifiers applied. If Wren's mesh still has an active Armature/Subsurf/etc. modifier at export time with Apply Modifiers checked, all shape keys are dropped without warning.
- Ensure the shape keys live on the **final export mesh object** (not on a hidden duplicate or pre-join copy — joining meshes discards shape keys unless transferred).
- If you use "Bake Animation", shape keys still export as morph targets; that part is fine.

Keep identical to the 2026-07-16 export: 175 cm scale, `FBX_SCALE_UNITS`, orientation settings, `bake_space_transform = OFF`, `add_leaf_bones = OFF`, the 129-bone skeleton (append-only rule — do NOT rename/delete/reorder anything, per Rigging Bible §16).

Required morph set (Rigging Bible §7 / §7.1): jaw open, blink L/R, brow raise/lower, smile, frown/snarl, cheek/muzzle compression, plus the viseme set `REST AI E O U FV L MBP WQ`, plus the shared expression palette where ready. Partial is fine — anything is more than the current zero.

**Delivery:** overwrite `C:\Users\Trevor\Desktop\KangarooModel\WrenKangaroo.fbx`. Do **not** copy FBX files into the UE `Content/` folder — the editor's source-file tracking auto-deletes imported assets when a tracked FBX is removed (this bit us once already). Trevor reimports in-editor from the Desktop path.

---

## WORK ORDER 2 — Animation takes (unblocks real character motion)

UE currently has **no animations that play on Wren's or Ripper's skeletons**. The template Mannequin set needs an editor-side retarget pass (Trevor has a 5-minute manual step queued for that), but **source-authored takes exported with the rigs would be strictly better** and skip retargeting artifacts entirely.

If you can author in Blender, priority order:

1. **Wren — disciplined boxing idle** (loop, ~2 s): guard up, calm weight-shift bob, tail counterbalancing. This is her Character Select presentation idle AND combat idle.
2. **Ripper — aggressive restless idle** (loop, ~1.5 s): hunched, twitchy, claws flexing, head sweeps. Same dual use. (Ripper's Character Select currently uses a placeholder whole-actor bob — no skeletal motion at all.)
3. The template-gap set that cannot be retargeted from Manny because it doesn't exist there: **block pose/loop, knockdown get-up, victory pose, defeat**.
4. Nice-to-have: light jab / heavy swing for Wren; claw swipe / spin for Ripper (spin must respect Rigging Bible §3 — preserve hand assignments).

**Export rules for takes:**
- Bake to the **deform bones** of the existing production skeletons (Wren 129-bone; Ripper `Ripper_Tas_Skeleton`). Control/IK helper bones may be included but animation must be baked down.
- Root motion policy per Rigging Bible §14: idles/locomotion in place; dodges and displacement moves root-motion.
- One take per FBX is cleanest for UE import, named like `Wren_Idle_Boxing.fbx`, `Ripper_Idle_Aggressive.fbx`, delivered next to the character source folders on Desktop.
- 30 fps, loop-clean first/last frames for idles.

---

## WORK ORDER 3 — Ripper source check (when convenient)

Ripper's UE assets predate the Wren correction round. Before authoring his takes, verify his Blender source still matches the shipped `Ripper_Tas` skeleton (hand-rigged; known weak shoulder/forearm-twist weights per the roadmap watch item). If you correct/re-export him, follow the exact Wren procedure above — including shape keys — and flag it so the UE side revalidates bone count/height (150 cm per §2.5) before promotion.

---

## Standards reminders (apply to everything above)

- **Rigging Bible is LOCKED** — append-only skeleton changes, version increments only.
- **Never scale skeletal meshes in UE** — correct size must come from Blender (§4.3).
- **Performance Standard** (now permanent, in PROJECT_STATE.md): 60 FPS locked; animation quality ranks below combat responsiveness and frame pacing — keep idle-loop bone counts and curve density sane.
- Weapons stay separate meshes with grip pivots per §4.2 (not relevant to Wren/Ripper, whose weapons are integrated).

## What the UE side will do on receipt

1. Reimport Wren over the production asset (references survive an in-place reimport from the same source path).
2. Verify morph target list + bone count + height, in-engine per §12 step 15.
3. Import animation takes against the existing skeletons, wire idle/locomotion into the Character Select previews and `BP_EE_Wren`/`BP_EE_Ripper`.
4. Update PROJECT_STATE.md and report gaps.
