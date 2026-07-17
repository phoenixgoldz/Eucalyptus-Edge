# EUCALYPTUS EDGE — BLENDER-SIDE BRIEFING (updated 2026-07-16, post deformation-crisis)

Machine: pheonixdesktop · Claude Desktop (MS Store) ↔ Blender MCP :9876 · Blender = Steam 5.2 (E:\SteamLibrary). UE lane = Claude Code. Rigging Bible v1.0 LOCKED.

## STATUS SNAPSHOT
- ATLAS: done + UE-validated (195 cm, +X). Glaive v3 SM_WindspinePolearm.fbx exported (palette-sampled, grip pivot §4.2). Pending: user eyeball, UE import + SupportHand_IK ~(45,0,0), socket alignment.
- WREN: source fully repaired + naturalized. **Blend is truth; production FBX is STALE (see gates).**
- RIPPER: 1.50 m fixed, RipperModel.blend created (first source), promoted; 9 facial keys built (geometric landmarks); **idle exported on the OLD engine → must rebake**; textures NOT in FBX (dead links — need Trevor's Tripo texture folder).

## WREN — CURRENT TRUTH (WrenModel.blend, saved)
175 cm, 129 bones (118 AccuRIG-UE5 + tail_01–07 + 3 ctrl + TailPlant_IK), root origin, canonical bake.
Facial: 9 REAL keys (Neutral, Jaw_Open 50 mm, Blink_L/R, Smile, Angry, Surprise, EyeLook_L/R). 91 AccuRIG placeholders deleted.
Weights REPAIRED this session: twist-bone weights merged into mains (upperarm/lowerarm/thigh/calf ×L/R groups had to be CREATED — AccuRIG skinned limbs 100% to twists, smoothing constraints stripped by FBX), joint bands smoothed, 3× targeted Laplacian over ~2.5 k steep verts. Edge QA: stance frames max 3.47× / 2 outliers (clean); deep-flex frames retain LBS crease stretch (F16/F22 ~5–7× hotspots — eyeball-accepted-or-iterate).
Anims in blend: Wren_Heavy_TailSpringDoubleKick **v13 “STRUT”** (reference-driven: plant close at y 0.42, J-strut tail 13° off vertical at F22, pitch→52° whip, feet strike z 0.96, anticipation F17 / overshoot F23 / landing compression F31 / head acting; drift 0.046, slide 0.000). Wren_Idle_Boxing **v2 NATURAL** (layered harmonics, asymmetric weight shift, spine lag, tail drag −0.55 rad, living head w/ gaze stabilization, breath; seam 0.0000).

## OPEN GATES (Wren)
1. **PRODUCTION MESH RE-EXPORT PENDING** — WrenKangaroo.fbx on disk predates the weight repair AND still carries the 92 placeholder keys. UE thin/spike symptoms persist until re-export + fresh import. Trigger: Trevor slider-tests the 9 keys → clean-bind export (validated settings, Apply Modifiers OFF) → verify keys BY DELTAS + weights spot-check → overwrite + UE reimport.
2. TailSpring export gated on Trevor scrubbing v13 (compare F22 to the kangaroo reference photo). Known tradeoff: vertical power ↔ horizontal reach (feet finish ~y −0.09; root-motion lunge is the range fix if gameplay wants it).
3. Wren_Idle_Boxing.fbx (v2) already exported → **UE must reimport (3rd version)**.
4. After approval: polish + Dodge_BackHop, Dodge_Bound_L/R, GetUp_TailAssist.

## RIPPER — NEXT WORK ORDER
Same full treatment as Wren, in order: (a) rebake Ripper_Idle_Aggressive on the anatomical engine + naturalness layer (current export = old engine, explains his UE head-spike/missing-chunks), (b) weight-seam audit (hand-rigged; edge-QA + Laplacian if steep), (c) 9-key slider test by Trevor, (d) production re-export chain. UE side first needs the fresh-import of Ripper_Tas.fbx (150 cm/28 bones) + material reassignment + physics.

## POSE ENGINE v13 (canonical for all scripted anims)
matrix_basis = (M(parent)@RL[p]⁻¹@RL[n])⁻¹@target, memoized; NO pose readbacks; per-frame bake for planted limbs; analytic 2-bone IK with TRUE joint-head lengths; **aim = anatomical segment** A0[n] = dir(head→farthest-child-head, else bone-Y) via rotation_difference (swing-only, roll preserved — bone-Y axes in AccuRIG/UE rigs are cosmetic and MUST NOT be aimed); FORCE rotation_mode='QUATERNION' pre-bake; tail: bezier, arclength bisected == chain, true-length marching; planted strut = J-curve (ctrl = tip + columnDir·h). Naturalness layer: multi-harmonic loop-safe waves (integer freqs), chain phase lag, living head (yaw drift + counter-roll + gaze counter-pitch), breath 1/loop, anticipation/overshoot/landing-compression beats, WIND arm transition pose.

## QA DOCTRINE (hard-won, non-negotiable)
1. Verts are truth: **edge-stretch ratio** (posed/rest per edge) is the spike metric; bone positions and max-vs-rest displacement both lie.
2. Weight edits: depsgraph does NOT reliably re-tag → **save + reload before trusting any QA after weight changes**. Pose-change liveness (frame_set) does not prove weight-change liveness.
3. Shape keys: absolute coords, shadow the base mesh; transform every key_block on resize/bake; verify keys by MEASURED DELTAS (placeholder slots pass count checks — AccuRIG ships 92 empty ones).
4. FBX verify = mesh extents + skeleton extents + key deltas (+ takes fingerprint: leaf bones, embedded actions).
5. Atomic destructive edits + immediate save; errored MCP calls can partially roll back unsaved edits.
6. Blender FBX importer needs an active object in the scene (shim an Empty before import into empty scenes).
7. Textures may be referenced-not-embedded (Ripper 4.9 MB); //tmp*.fbm links die — pack() recovered images into the blend when found.

## FILES
Wren: Desktop\KangarooModel\{WrenModel.blend ✓, WrenKangaroo.fbx (STALE), Wren_Idle_Boxing.fbx (v2 ✓), WrenKangaroo_accurig_backup.fbx}
Ripper: Desktop\RipperModel\{RipperModel.blend ✓, Ripper_Tas.fbx (150 cm ✓ no morphs-yet), Ripper_Idle_Aggressive.fbx (OLD ENGINE — superseded on rebake), Ripper_Tas_original_backup.fbx (verified 1.58 original), Ripper_Validation.fbx}
Atlas: Desktop\Atlas\{Atlus.blend, Atlas_Tpose_Rigged.fbx ✓, SM_WindspinePolearm.fbx, WindspinePolearm_Concept.png}
Preset: Blender operator preset “EE Character Export” saved by Trevor with canon settings (Selected Objects ON, FBX Units Scale, leaf OFF, Apply Modifiers OFF, Anim OFF).

## COMMS / UE-SIDE QUEUE
UE: fresh-import Ripper (delete old assets; Skeleton None; 150 cm/28 bones; reassign existing material assets; new PhysicsAsset) · reimport Wren_Idle_Boxing v2 · translation-retargeting recipe on both skeletons (all bones “Skeleton”, root+pelvis “Animation”) · take renames (Blender names takes Armature|Scene). Never copy FBX into Content/ — deliver to Desktop source folders.

## ===== RIPPER: OPTION B LOCKED (topology regen) — updated end of session =====
Raw Tripo mesh diagnosed UNREPAIRABLE by weighting: 565 disconnected islands (largest 959 v), 46,298 open boundary edges, 10,718 coincident verts, 90k polys, never retopologized. Heat-map solver fails ("no solution" = non-manifold) AND wipes shape keys on parent_set. Weight-painting a shattered shell is unwinnable — confirmed via non-destructive test branch (now archived at RipperModel\_archive\).

**Production blocker = TOPOLOGY, not weighting.** Do NOT attempt further weight repair on the current mesh.

### RIPPER PIPELINE (awaiting Trevor's Tripo Retopo FBX → RipperModel folder)
1. Receive new Tripo **Retopo** FBX (Retopology ON — the setting Wren's clean mesh had; PBR textures if offered). Distinct name e.g. Ripper_Retopo.fbx.
2. VERIFY TOPOLOGY *before any rig work* (gate): manifold where expected · connected (island count sane, not 100s) · clean normals · reasonable poly count (target retopo ~15–40k, not 90k raw).
3. Resize → 150 cm (canon §2.5).
4. Canonical Blender→UE export standard (data Y-up bake, FBX_SCALE_UNITS, leaf OFF, Apply Modifiers OFF).
5. Rig via proven WREN PIPELINE (now the production template).
6. **Verify deformation BEFORE animation** (edge-stretch QA on shoulders/forearms/hands-claws/hips/knees/ankles/feet/spin — must pass: no unweighted verts, no cross-limb contamination, no missing islands, no catastrophic spikes, UVs/materials usable).
7. Rebuild 9 Phase-1 facial keys on the new mesh (verify by MEASURED DELTAS).
8. ONLY after deformation passes: Aggressive Idle → Light attacks → Heavy spin attack → Edge Ultimate. (Spin must respect §3 hand assignments.)

### Ripper file hygiene notes
- Ripper_Tas.fbx on disk = 4 KB STUB (bad earlier write) — ignore, will be replaced.
- Real safe originals: Ripper_Tas_original_backup.fbx (4.9 MB, verified 1.58 m original), RipperModel.blend (current, has dead heat-map weights on the doomed mesh — will be superseded by the retopo build).
- Ripper_Idle_Aggressive.fbx = old-engine + doomed mesh → discard on rebuild.

## WREN — FINAL STATE (all combat anims exported, production mesh gated)
Exported to KangarooModel\: Wren_Idle_Boxing.fbx (v2 natural, 61f), Wren_Heavy_TailSpringDoubleKick.fbx (**v15 READABLE, 72f/2.4s** — held anticipation F26-30, strike snap F33-36 @70× velocity spike, extension hold F36-44, land F56-60; tail strut 7-13° vertical, hip-drive forward through impact, floor-slide 1.9cm), Dodge_BackHop.fbx (22f, -0.55m root-motion), Dodge_Bound_L.fbx / Dodge_Bound_R.fbx (20f, ±0.50m). All armature-only takes, 129 bones, need UE reimport + rename (Blender names takes Armature|Scene).
STILL GATED: production WrenKangaroo.fbx re-export (stale weights + placeholder keys) waits on Trevor slider-testing the 9 real facial keys. UE side: retargeting recipe (all bones Skeleton, root+pelvis Animation) on Wren skeleton.

## ===== RIPPER RETOPO MESH — PREPPED, AWAITING RIG (Trevor away) =====
New Tripo mesh received into RipperModel\ (imported at 971,897 v / 1.94M faces).
**TOPOLOGY GATE: PASS** — 2 islands (1 body + 3-vert speck), 7 boundary edges, 0 non-manifold. This is a CONNECTED WATERTIGHT MANIFOLD mesh (vs old 565-island shell). Note: it is RAW high-density, not literally a low-poly retopo export, but topology is clean so decimation is safe.

### DONE (non-destructive prep, safe without user eyes):
- Deleted 3-vert speck → 1 island.
- Removed stray old dead-mesh Armature from scene.
- **Decimated COLLAPSE 1.94M → 27,999 faces / 13,986 v** (game-ready, 60fps-safe). Post-decimate re-verified: 1 island, 3 boundary, 0 non-manifold, UV+material preserved.
- Recalc normals outside.
- Resized → **150.0 cm** exact, feet at z=0.
- Canonical orientation bake (data Y-up, +90X object — Wren standard).
- Renamed mesh "Ripper". Saved as CLEAN new source: **RipperModel\RipperRetopo.blend** (13.3 MB). Did NOT bloat/overwrite production RipperModel.blend (which is now 91 MB with the raw mesh — can be discarded).

### AWAITING TREVOR (rig + anim, per his scope "I'll do that when I return"):
1. **CONFIRM FACING** — head-band X −0.25..0.18, Y −0.35..0.10; snout direction needs user eyeball in viewport (front should be −Y like Wren/Atlas). If backwards, one-line flip before rig.
2. Build/attach skeleton. Ripper's OLD skeleton (Ripper_Tas, 28 bones, Manny-named + ball_l/r, hand-rigged) lives in the old backup FBX — can transplant its bone rest data onto the new mesh, OR heat-map auto-weight from it (NOW VALID — clean manifold topology means the heat solver will work this time). Make it NOT deform-broken: verify via edge-stretch stress test (shoulders/forearms/hands-claws/hips/knees/ankles/feet/spin) BEFORE animation — same gate Wren passed.
3. Rebuild 9 Phase-1 facial keys on the new mesh (geometric landmarks; verify by MEASURED DELTAS). New mesh has NO shape keys yet.
4. Canonical FBX export (validated standard).
5. THEN animation, in doc order: Aggressive Idle → Light attacks → Heavy spin attack (respect §3 hand assignments) → Edge Ultimate. Author on the ANATOMICAL POSE ENGINE v13 + naturalness layer (Wren template). NO animation until deformation QA passes.

### Ripper file state
- RipperRetopo.blend = clean prepped mesh (150cm, oriented, decimated, no rig/keys yet). **THIS is the go-forward source.**
- RipperModel.blend (91 MB) = raw-mesh bloat, discard.
- Ripper_Tas_original_backup.fbx (4.9 MB) = OLD doomed mesh + 28-bone skeleton. Keep ONLY for skeleton bone-rest reference.
- Ripper_Tas.fbx (4 KB stub), Ripper_Idle_Aggressive.fbx (old engine+doomed mesh), Ripper_Validation.fbx = all superseded, discard.

## ===== CRITICAL: UE IMPORT FAILURE CLASS — "TWIG / EXPLODED MESH AT REST" =====
SYMPTOM: character imports but shows as a spiky twig / scattered bones in the BP viewport or asset preview, EVEN WITH NO ANIMATION PLAYING (reference pose). Seen on Wren after re-import 2026-07-16.

ROOT CAUSE (verified): NOT the FBX. The production WrenKangaroo.fbx tested CLEAN in Blender — rest-pose deform 0.0000, bind perfect, scale 1.0, 129 bones, no wild rest transforms. The twig is UE-side:
1. **Reusing the OLD Skeleton asset.** Re-importing / importing with the old Skeleton selected re-binds the new mesh to the poisoned old skeleton (built from the pre-fix broken mesh). The Skeleton asset — not the Skeletal Mesh — carries the poison.
2. **Manny Anim Blueprint driving a non-Manny skeleton** without a valid IK Retargeter. ABP_Manny_Combat expects Manny proportions; on Wren's 129-bone kangaroo skeleton with no retarget it explodes the pose.

MANDATORY FIX SEQUENCE (applies to EVERY character — Wren, Ripper, Atlas, all future):
1. DELETE ALL old assets for that character: Skeletal Mesh, **Skeleton asset**, Physics Asset, AND any IK Retargeter/IK Rig referencing them. The Skeleton is the critical one.
2. FRESH import the FBX with **Skeleton = None** (forces a brand-new skeleton from the FBX's own hierarchy). Never pick an existing skeleton for a rebuilt mesh.
3. Import Morph Targets ON, Uniform Scale 1.0, defaults.
4. Open the new Skeletal Mesh ALONE and confirm correct shape in the asset viewer BEFORE any Blueprint/AnimBP.
5. Only then wire anims. For the slice, test raw anim assets directly on the character's own skeleton first. Manny retarget requires a proper IK Retargeter (source Manny → target character) — NOT direct AnimBP reuse.

VERIFICATION HOLE CLOSED: Blender "shoulder-stress QA passed" tests geometry+weights round-trip but does NOT catch UE skeleton-rebinding. Add to doctrine: after any mesh re-export, the UE-side check is "open Skeletal Mesh asset alone, no AnimBP" — if twig there, it's skeleton-asset reuse; if twig only under animation, it's retarget/hemisphere.

## ===== ANIMATION: 60FPS FLYING-FRAME CLASS (separate from the twig) =====
SYMPTOM: at UE 60fps, limbs whip / character briefly vanishes during fast beats (launch, hop, kick). Not visible at Blender 30fps.
CAUSE: authored transitions compress large joint swings (calf 100-170°/frame) into 2-3 keys. UE interpolates the 60fps midpoint through a wild arc. Quaternion hemisphere flips are a SECONDARY contributor (fixed 32 on TailSpring via sign-alignment; idle now 1°/frame clean).
QA METRIC TO ADD (was missing): per-frame quaternion angular delta scan — FAIL any bone >~45-60°/frame. Run on every take before export.
FIX (real, not post-process): re-time fast beats over more frames with eased in-betweens so no step exceeds ~40°/frame. This also resolves "too fast" + "stiff" — same root cause. Post-hoc slerp-resampling was attempted and ABORTED (partially wiped TailSpring curves — min keyframe count dropped 72→2). **TailSpring action in blend is now DAMAGED and must be rebuilt from the authoring engine** (exported v15 FBX on disk is still good/unaffected). Do NOT attempt curve-surgery resampling again; rebuild from code.

## IMMEDIATE STATE (end of session)
- WrenKangaroo.fbx on disk = GOOD (clean bind, weights repaired, 129 bones, 175cm). UE twig = skeleton-asset reuse; fix via mandatory sequence above.
- Wren_Idle_Boxing.fbx, Dodge_*.fbx on disk = good blocks (idle natural; dodges need re-time for 60fps + pacing).
- Wren_Heavy_TailSpringDoubleKick.fbx on disk = good v15; but the ACTION inside WrenModel.blend is damaged (aborted resample) — rebuild from engine next session before any re-export.
- Ripper: RipperRetopo.blend prepped (150cm, decimated 28k, oriented), awaiting rig — will need the SAME UE mandatory-fix-sequence discipline on import.

## ===== CRITICAL DIAGNOSIS: "TWIG IN ARENA" ROOT CAUSE (documented so it never repeats) =====
**Symptom:** Character imports fine; looks correct in Character Select; becomes a thin "twig" (collapsed limbs) ONLY in the battle arena during gameplay (PIE).

**ROOT CAUSE = UE-side animation retarget, NOT the Blender mesh.**
- Character Select displays the mesh on its **reference pose** (no AnimBP) → correct.
- Battle arena runs the character's **Anim Class**. Wren's BP_EE_Wren had Anim Class = **`ABP_Manny_Combat`** (a MANNEQUIN AnimBP). Playing Manny animation on a non-Manny (kangaroo) skeleton drives the bones with Manny's proportions/rest orientations → limbs collapse to slivers = the twig.
- PROOF (Blender-side, this session): re-imported production WrenKangaroo.fbx measured healthy — limb girths 0.176/0.310/0.202, skeleton head-span 1.408 vs mesh 1.750, all 11 Manny-standard bones present, shoulder-stress edge QA 2.15× (clean). Mesh + weights are FINE. Re-exporting the mesh CANNOT fix a twig whose cause is the AnimBP. (This is why repeated Blender re-exports didn't help — wrong lane.)

**THE FIX (UE / Claude Code lane):**
1. PREFERRED: give each fighter its OWN AnimBP that plays its OWN native takes. Wren's four FBX takes (Idle_Boxing, Heavy_TailSpringDoubleKick, Dodge_BackHop, Dodge_Bound_L/R) were authored ON his own 129-bone skeleton → ZERO retarget needed → deform perfectly. Change BP_EE_Wren → Details → Animation → Anim Class from ABP_Manny_Combat to ABP_Wren. Same pattern for Ripper (ABP_Ripper on Ripper_Tas skeleton).
2. IF Manny AnimBP must be shared for combat logic: build an IK Retargeter (Manny source → fighter target), map retarget root + chains, and set per-bone Translation Retargeting: ALL bones = "Skeleton", root + pelvis = "Animation". Without this, translation curves from Manny distort limb lengths.

**PREVENTION RULE (applies to Ripper + every future fighter):** never ship a fighter running a Manny/foreign AnimBP on its own skeleton. Each fighter uses native takes via its own AnimBP, OR a properly configured IK Retargeter. Verify in PIE arena, not just Character Select — the reference pose hides this class of bug.

## ANIMATION 60fps / FLYING-FRAME NOTE (separate, lower priority than the twig)
Per-frame rotation-spike scan found leg/arm bones swinging 100–170°/frame during fast launch/hop beats (TailSpring F31-32/F46-48; dodges F17-19). At 30fps Blender hides it; UE 60fps interpolation between far-apart keys whips the limb ("flying/missing" frames). Quaternion-hemisphere alignment pass fixed sign-flips (idle now 1°/frame) but the big swings are genuine fast transitions needing re-timing (spread over more frames + eased in-betweens) — the same work that fixes "too fast" and "stiff". NOT a corruption; an authoring-density choice.
- **CAUTION LOGGED:** an attempted 2×-density slerp-resample script partially wiped the TailSpring action (some fcurves dropped 72→2 keys). The action in WrenModel.blend is DAMAGED and must be rebuilt from the authoring code (deterministic). The EXPORTED Wren_Heavy_TailSpringDoubleKick.fbx on disk is the intact v15 — unaffected. Do NOT trust the in-blend TailSpring action until rebaked.
- Blender 5.x fcurves: NOT action.fcurves — use action.layers[].strips[].channelbag(slot).fcurves.

## POSE-ENGINE RULE ADDED
Author fast transitions with enough frames that no bone exceeds ~40°/frame (UE 60fps-safe). Add a per-frame quaternion angular-velocity scan to standard QA (>90°/frame = fail). Quaternion-hemisphere alignment (adjacent-key dot>0) is a required post-bake pass before export.
