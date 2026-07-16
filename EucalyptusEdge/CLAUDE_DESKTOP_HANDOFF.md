# CLAUDE DESKTOP HANDOFF — Blender/Source-Art Work Orders

**From:** Claude Code (UE 5.8 side) · **Date:** 2026-07-16
**For:** Claude Desktop (Blender / source asset side)
**Read together with:** `WEAPON_SOCKET_AND_FACIAL_RIGGING_STANDARD.md` (LOCKED — do not modify), `PROJECT_STATE.md` (current state + permanent Performance Standard), `STYLE_GUIDE.md` (visual canon).

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
