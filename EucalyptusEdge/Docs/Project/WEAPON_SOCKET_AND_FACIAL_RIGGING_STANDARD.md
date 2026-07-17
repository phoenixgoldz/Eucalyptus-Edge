# EUCALYPTUS EDGE — WEAPON, SOCKET, AND FACIAL RIGGING STANDARD

**Status:** Canon — **LOCKED at v1.0**  
**Skeleton Version:** 1.0  
**Engine Target:** Unreal Engine 5.8  
**Applies To:** All playable fighters, Blighted variants, DLC fighters, cinematics, character select, victory poses, dialogue, and combat animations.

> **This document is LOCKED.** Once a fighter ships against this standard, changes are made through **version increments** (v1.1, v1.2…), not ad-hoc edits. See §16 (Skeleton Versioning).

**Revision Note (v1.0):**
- Banjo reclassified from *Dual Short Blades* to a single **Whip** (right hand). See §3 and §4.1.
- Added canonical **Roster Height Chart** (§2.5).
- Added **Atlas rig build record** (§3.1) documenting the as-built skeleton.
- Added **Weapon Grip-Pivot Standard** (§4.2).
- Added **Character Scale Rule** (§4.3) — never scale skeletal meshes in UE.
- Added **Root Motion Policy** (§14).
- Added **Facial Expression Library** (§7.1) and **Eye Tracking / EyeAimTarget** (§7.2).
- Added **Expressiveness-Before-Skins production rule** (§15).
- Added **Animation Retargeting Standard** (§13.1).
- Added **Skeleton Versioning** rule (§16).

---

## 1. Core Combat Rig Rule

Eucalyptus Edge uses a Soulcalibur-style 3D arena fighting presentation.

Each fighter has a fixed dominant hand. A weapon does **not** switch hands when the character changes sides of the screen or rotates around the opponent.

The character rotates in world space while preserving:
- dominant hand
- combat stance
- weapon orientation
- animation timing
- hitbox behavior
- socket attachment

Never mirror a weapon to the opposite hand simply because the fighter is standing on the opposite side of the arena.

---

## 2. Standard Socket Naming

Use the same socket names across all compatible humanoid character skeletons.

### Single-Weapon Fighters

```text
hand_r
└── WeaponSocket_R

hand_l
└── SupportHand_IK
```

`WeaponSocket_R` is the main attachment point.

`SupportHand_IK` is an IK target or reference used for two-handed weapons such as staffs, spears, polearms, and glaives.

### Dual-Wield Fighters

```text
hand_r
└── WeaponSocket_R

hand_l
└── WeaponSocket_L
```

### Optional Holster Sockets

```text
spine_03
└── BackWeaponSocket

pelvis
├── HipWeaponSocket_R
└── HipWeaponSocket_L
```

These may be used for intro animations, victory poses, non-combat traversal, or weapon sheathing.

---

## 2.5 Roster Height Chart (Canon)

Fighter heights are intentionally laddered so silhouettes read as distinct **before** weapons are visible. Banjo is the smallest (nimble grappler); Atlas is the tallest (polearm reach).

| Fighter | Height | Approx. | Notes |
|---------|--------|---------|-------|
| Banjo   | 120 cm | 3'11"   | Sugar glider — smallest, quick, agile grappler |
| Koda    | 145 cm | 4'9"    | Koala |
| Ripper  | 150 cm | 4'11"   | Tasmanian devil |
| Kiri    | 160 cm | 5'3"    | Kookaburra |
| Echo    | 165 cm | 5'5"    | Platypus |
| Wren    | 175 cm | 5'9"    | Kangaroo |
| Atlas   | 195 cm | 6'5"    | Emu — tallest, emphasizes polearm reach (as-built height) |

**Note on Atlas height:** Atlas was modeled and exported at **195 cm** (as-built). This is the canonical value; earlier working notes that referenced 190 cm are superseded by this table.

Heights are for the base skeletal mesh in a neutral standing pose (crest/feathers not counted toward the number). Blighted and DLC variants inherit their base fighter's height unless a variant explicitly documents otherwise.

---

## 3. Canonical Hand Assignments

### Koda — Eucalyptus Crystal Staff
- Dominant hand: Right
- Main attachment: `WeaponSocket_R`
- Left hand: support grip through IK
- Weapon type: two-handed staff
- The left hand may slide along the shaft during attacks.

### Atlas — Windspine Polearm / Crystal Glaive
- Dominant hand: Right
- Main attachment: `WeaponSocket_R`
- Left hand: support grip through IK
- Weapon type: two-handed polearm
- The weapon must be modeled as a separate object.
- Do not fuse the weapon to Atlas's body mesh or hand mesh.

#### 3.1 Atlas Rig Build Record (as-built)
Documented per §13 (Claude must document character-specific rig facts).
- **Source:** Tripo T-pose generation (weapon-free reference `AtlusNoWeapon_FrontTpose.png`), Tripo auto-rig.
- **Mesh:** ~19.7k tris, single material `Mat_Atlas`, 4K base color (normal/roughness/metallic not shipped by this generation — flag for later PBR pass).
- **Height:** 195 cm, T-pose, feet flat at z=0, facing -Y in Blender (imports facing +X in UE).
- **Skeleton:** Tripo 41-bone rig, **renamed to UE5 Mannequin convention** including twist bones (`upperarm_twist_01_l/r`, `calf_twist_02_l/r`, etc.). Non-deforming `root` at origin.
- **Weights:** ≤8 influences/vertex, normalized, 0 unweighted. Tail feathers ride the body (no dedicated tail bones).
- **Weapon:** glaive to be built as separate mesh, socket `WeaponSocket_R` on `hand_r`, left hand via `SupportHand_IK`.
- **Export:** `Atlas_Tpose_Rigged.fbx`, round-trip verified upright; export uses `bake_space_transform = OFF` (armature-safe), `add_leaf_bones = OFF`, `FBX_SCALE_UNITS`, embedded textures.
- **Open items:** facial rig (Phase 1 min set) pending; glaive model + socket pending; optional normal/roughness/metallic bake.

### Kiri — Boomerang Weapon
- Dominant hand: Right
- Main attachment: `WeaponSocket_R`
- During a throw:
  1. Detach from the hand.
  2. Spawn or activate the projectile actor.
  3. Return the projectile.
  4. Reattach to `WeaponSocket_R`.
- Kiri remains right-handed regardless of screen position.

### Echo — Twin Crystal Tonfas
- Right tonfa: `WeaponSocket_R`
- Left tonfa: `WeaponSocket_L`
- Both weapons are separate objects.
- Tonfa handles must align naturally with the forearm.
- Each tonfa needs independent hit detection.

### Banjo — Whip
- Dominant hand: Right
- Main attachment: `WeaponSocket_R`
- Weapon type: single flexible whip
- Banjo is a nimble grappler; the whip is his reach and control tool.
- The whip is a **flexible weapon** — it must not be treated as a rigid socketed prop:
  - model the whip as a separate mesh with a **segmented bone chain** along its length, OR
  - drive it with **physics / Chaos Cloth** in Unreal for trailing motion.
  - The whip's grip/handle pivots at `WeaponSocket_R`; the lash follows through simulation or its bone chain.
- `SupportHand_IK` on `hand_l` may be used for two-handed wind-up or grapple poses, but the whip is single-hand-owned.
- Wing/glide-assisted attacks do not swap weapon ownership; Banjo remains right-handed regardless of screen position.
- No left-hand weapon socket is required for normal combat (single-weapon fighter).

### Sonia — Twin Crescent Chakrams
- Right chakram: `WeaponSocket_R`
- Left chakram: `WeaponSocket_L`
- Each chakram is a separate object.
- Thrown chakrams detach, travel, return, and reattach to their original hand.

### Wren — Boxing Gloves
- No general-purpose handheld weapon socket is required for normal combat.
- Gloves may be:
  - part of the skeletal mesh, or
  - separate meshes permanently attached to each hand.
- If separate:
  - right glove attaches to `WeaponSocket_R`
  - left glove attaches to `WeaponSocket_L`

### Ripper — Claw Gauntlets / Natural Claws
- No handheld weapon socket is required during normal combat.
- Claws or gauntlets remain permanently associated with the hands.
- If separate meshes:
  - right claw attaches to `WeaponSocket_R`
  - left claw attaches to `WeaponSocket_L`
- Spin attacks must preserve hand assignments and use animation-driven hitboxes.

---

## 4. Weapon Modeling Rules

Every handheld weapon must be modeled as a separate mesh from the character.

Do not permanently combine weapons with:
- hands
- fingers
- forearms
- torso armor
- character body mesh

This allows:
- socket attachment
- weapon swapping
- clean animation
- hitbox control
- VFX attachment
- trails
- projectile behavior
- damage-state materials
- Blighted weapon variants
- cosmetic skins

The weapon origin and pivot should be placed at the primary grip point.

For two-handed weapons, the right hand controls the weapon and the left hand follows through IK.

### 4.1 Flexible Weapons (Whips, Chains, Ribbons)

Flexible weapons — currently **Banjo's whip** — are a special case and must **not** be treated as rigid props:

- The **handle/grip** is a rigid piece pivoting at the owning socket (`WeaponSocket_R` for Banjo).
- The **flexible length** (lash) must be driven by one of:
  - a **segmented bone chain** running the length of the whip (animator- or physics-driven), or
  - **Chaos Cloth / physics simulation** in Unreal Engine 5.8.
- The whip is still a **separate mesh** from the character, following all §4 rules (socketing, VFX, trails, damage-state materials, Blighted variants).
- Hitboxes for flexible weapons must be **animation- or simulation-driven** along the lash, not a single static capsule at the socket.
- The whip remains right-hand-owned regardless of screen side (§1, §5).

### 4.2 Weapon Grip-Pivot Standard (Canon)

Every weapon mesh must have its **origin/pivot placed at a defined point** so it snaps to its socket with **zero manual offset** on import. This is mandatory — do not rely on per-instance transforms in Unreal to correct a mis-placed pivot.

**Base rules by weapon class:**

```text
Single-handed weapons ...... origin at the center of the primary grip
Staffs / Polearms .......... origin at the RIGHT-hand grip (Koda, Atlas)
Whips ...................... origin at the handle center (Banjo)
Boomerangs ................. origin at the center of mass (Kiri)
Tonfas ..................... origin at the grip (Echo)
Chakrams ................... origin at the center (Sonia)
Gloves / Gauntlets ......... origin at the wrist attach point (Wren)
Claws ...................... origin at the wrist/knuckle attach point (Ripper)
```

**Per-character / dual-weapon clarifications:**
- **Atlas / Koda (two-handed):** single weapon, pivot at the right-hand grip. Left hand follows via `SupportHand_IK`; it does not need its own pivot.
- **Echo (dual tonfas):** each tonfa is a separate mesh; each pivots at its own grip. Right → `WeaponSocket_R`, left → `WeaponSocket_L`. Handles align to the forearm.
- **Sonia (dual chakrams):** each chakram pivots at its center. Right → `WeaponSocket_R`, left → `WeaponSocket_L`. Center pivot is required for clean spin/throw rotation.
- **Wren (gloves), Ripper (claws):** if separate meshes, each pivots at its wrist attach point; right → `WeaponSocket_R`, left → `WeaponSocket_L`. If baked into the skeletal mesh, no socket pivot applies.
- **Banjo (whip):** handle pivots at center at `WeaponSocket_R`; the lash extends from the handle via its bone chain / simulation (§4.1).

**Orientation convention:** the weapon's "forward" (blade tip, staff top, whip lash direction) should point down the socket's forward axis in the bind pose, so no rotation offset is needed at attach time. Validate every weapon in-engine per §12 step 15.

### 4.3 Character Scale Rule (Canon)

> **Never scale a skeletal mesh in Unreal Engine.**

Skeletal meshes must be the **correct real-world size in Blender** and pass through the entire pipeline at scale 1.0. Scaling a skeletal mesh in UE breaks animation retargeting, physics asset proportions, cloth behavior, and collision/hitbox alignment.

Required scale chain for every fighter:

```text
Blender source ............ correct real-world size (see §2.5 height chart)
FBX export ................ 1.0  (FBX_SCALE_UNITS)
UE Import ................. 1.0  (Import Uniform Scale = 1.0)
Character Blueprint ....... 1.0  (mesh component scale 1.0)
```

If a character comes in the wrong size, **fix it in Blender and re-export** — do not correct it with an import scale or a Blueprint scale. Weapons follow the same rule: model at correct size, export at 1.0, attach without scaling.

---

## 5. Facing and Mirroring Rules

Characters may face either direction on screen, but handedness never changes.

Allowed:
- rotate the character root
- rotate the camera
- adjust lock-on orientation
- use turn-in-place animations
- use directional movement blends

Not allowed:
- moving a right-hand weapon to the left hand because the fighter crossed sides
- mirroring sockets during combat
- dynamically changing dominant hand
- flipping attack animations without validating hitboxes and weapon alignment

Animation mirroring may be used internally for production efficiency only when:
- weapon hand remains correct
- attack timing remains unchanged
- collision and hitboxes are revalidated
- the final motion still matches the fighter's canonical handedness

---

## 6. Facial Rigging Decision

All major playable fighters should receive facial rigs.

Facial rigs are important for:
- character select reactions
- introductions
- victory and defeat animations
- taunts
- Edge Energy ultimate close-ups
- story scenes
- combat grunts
- spoken dialogue
- promotional trailers

However, facial rigging should be built in production tiers.

---

## 7. Phase 1 Facial Rig Minimum

For the first playable prototype, each active fighter should have:

### Required
- jaw open and close
- mouth open and close
- blink left
- blink right
- brow raise
- brow lower or angry expression
- eye aim or eye rotation
- basic smile
- basic frown or snarl
- cheek or muzzle compression where applicable

### Minimum Voice Shapes
Create a small viseme set:

```text
REST
AI
E
O
U
FV
L
MBP
WQ
```

This is enough for convincing gameplay dialogue and short cinematics without requiring a film-level facial system.

---

## 7.1 Facial Expression Library (Canon)

Beyond raw visemes, every playable fighter must support a **shared, named expression palette** so designers and animators have a consistent set to call from across menus, intros, story scenes, and combat reactions. Use the same expression names on every character (the *deformation* differs per species; the *name and intent* are shared).

**Minimum expression set (all playable fighters):**

```text
Neutral ...... resting face, combat-ready
Happy ........ positive, open
Determined ... focused, brows set (default combat expression)
Angry ........ aggressive, brow lowered
Surprised .... eyes wide, brows up
Confused ..... asymmetric brow, slight head/eye offset
Hurt ......... pain reaction, eyes squint
Victory ...... win pose expression
Taunt ........ provocation (character-flavored)
Exhausted .... low stamina / heavy breathing
KO ........... knocked out / defeat
```

**Implementation:** each expression is a **morph target / shape key** (per §9), optionally supported by facial bones (jaw, brows, eyes). Expressions may be blended with visemes during dialogue.

**Species / character intensity rules (per §8):**
- **Ripper** — most exaggerated across the whole set; asymmetric mouth shapes, strong snarl on Angry, big Surprised.
- **Atlas** — restrained and noble; Determined/Angry read through brow + feather crest + eyes, not beak deformation. Victory is subtle, not toothy.
- **Beaked fighters (Kiri, Atlas)** — Happy/Angry/Surprised expressed via eyes, brows, and crest; lower beak only for jaw motion, never human-lip shaping.
- **Muzzled fighters (Koda, Wren, Ripper, Banjo, Echo, Sonia)** — muzzle corners and cheeks shape expressions; nose must not collapse; teeth show only on snarl/aggressive states.

---

## 7.2 Eye Tracking — `EyeAimTarget` (Canon)

Every playable fighter's facial rig must expose an **`EyeAimTarget`** control (eye-aim bones or a look-at control driving both eyes) so the eyes can track a target independently of head motion. Small eye movement adds significant life to stylized characters at very low cost.

```text
EyeAimTarget

Used by:
• Character Select      (eyes follow cursor / react to selection)
• Dialogue              (eye contact, glances)
• Victory Animations
• Story Scenes
• Lock-on Closeups      (eyes toward opponent / camera)
```

Requirements:
- Both eyes driven by a single aim target (with a per-eye limit so they don't diverge unnaturally).
- Eyelids should track large vertical eye movement slightly (lids follow the pupil) where the rig supports it.
- `EyeAimTarget` is part of the **Phase 1 facial rig** (it satisfies the "eye aim or eye rotation" requirement in §7).

---

## 8. Species-Specific Facial Requirements

### Beaked Fighters — Kiri and Atlas
- upper beak remains mostly rigid
- lower beak/jaw provides speech motion
- cheek and eye expressions carry emotion
- brows or feather crests provide silhouette-based expression
- throat and neck feathers may compress slightly during strong vocalizations
- do not deform the beak like human lips

### Muzzled Fighters — Koda, Wren, Ripper, Banjo, Echo, Sonia
- jaw opens from the correct anatomical hinge
- lips or muzzle corners shape vowels and emotion
- nose should not collapse during speech
- snarls should expose teeth only when appropriate
- cheeks and brows should support emotion without becoming overly human

### Ripper
Ripper needs exaggerated:
- jaw opening
- cheek stretch
- snarl
- eye squint
- brow compression
- asymmetrical mouth shapes

His expressions should support his wild, chaotic personality and rapid vocal delivery.

### Atlas
Atlas should appear controlled, noble, and focused.
Prioritize:
- precise eye movement
- stern brow shapes
- subtle lower-beak movement
- feather crest response
- restrained victory expressions

---

## 9. Recommended Facial Rig Method

Use a hybrid approach:

### Bones
Use facial bones for:
- jaw
- eyes
- eyelids
- brows
- beak or muzzle controls
- feather crest controls where required

### Morph Targets / Shape Keys
Use morph targets for:
- visemes
- smiles
- frowns
- snarls
- cheek compression
- muzzle deformation
- species-specific expressions

This combination works well in Unreal Engine and avoids forcing every expression through bones alone.

---

## 10. Unreal Engine Facial Setup

Recommended UE5.8 structure:

```text
Character Skeletal Mesh
├── Body Skeleton
├── Facial Bones
├── Morph Targets
├── Animation Blueprint
├── Control Rig
└── Dialogue / Viseme Driver
```

Use:
- Animation Blueprints for combat and body motion
- Control Rig for polish, IK, and facial adjustment
- Morph Targets for visemes and expression poses
- curves in animation assets for facial timing
- optional audio-driven lip sync later

Do not make MetaHuman compatibility a Phase 1 requirement. These characters are stylized animals and need custom facial behavior.

---

## 11. Voice and Lip-Sync Production Rule

Record final dialogue only after:
- character personality is locked
- pronunciation is approved
- voice direction is documented
- facial visemes exist
- mouth and jaw deformation tests pass

For temporary development:
- placeholder voice lines are allowed
- combat grunts may use simple jaw-open curves
- full lip sync is not required for every battle line
- story scenes and close-ups receive the highest-quality sync

---

## 12. Rigging Order Per Character

Use this sequence:

1. Finalize clean body mesh.
2. Remove or separate all weapons.
3. Confirm five-finger hand topology where required.
4. Create body skeleton compatible with the project animation standard.
5. Skin the body.
6. Add hand sockets.
7. Add weapon mesh and align its grip pivot.
8. Add support-hand IK for two-handed weapons.
9. Add facial bones.
10. Create required facial morph targets.
11. Test basic locomotion.
12. Test light, medium, heavy, block, dodge, and ultimate poses.
13. Test facial expressions during movement.
14. Import into Unreal Engine 5.8.
15. Validate socket alignment and hitboxes in-engine.

---

## 13. Claude Implementation Instruction

Claude must treat this document as canonical.

When Claude rigs or prepares a fighter:

- preserve the fighter's assigned dominant hand
- never swap hands based on screen position
- create the required weapon sockets
- keep handheld weapons as separate meshes
- use right-hand control plus left-hand IK for two-handed weapons
- create independent sockets for dual weapons
- include a Phase 1 facial rig
- include the minimum viseme set
- preserve species-appropriate facial anatomy
- validate all results inside Unreal Engine 5.8

Claude must not make permanent character-specific changes to the shared skeleton without documenting them.

---

## 13.1 Animation Retargeting Standard (Canon)

All playable fighters must remain compatible with the project's shared animation framework so Unreal Engine 5.8 Mannequin (Manny/Quinn) animations can be reused via the IK Retargeter. This is the backbone of the roster's animation strategy — a fighter that fails these requirements cannot share the common animation set.

**Requirements (every fighter must satisfy all):**
- UE5 Manny-compatible bone **hierarchy**
- Bone **names** follow the project naming convention (§2, Manny convention incl. twist bones)
- **Root bone at world origin** (0,0,0), non-deforming
- **Forward axis consistent** across all characters (imports upright, facing +X — no per-character rotation offset; see §4.3 and the Blender→UE export settings)
- **Feet aligned to the ground plane** (z = 0) in the bind/retarget pose
- **Hand sockets in identical hierarchy** (`WeaponSocket_R`/`_L`, `SupportHand_IK` in the same relative positions on every skeleton)
- **Twist bones preserved** (upper/lower arm and thigh/calf twists retained and named per convention)
- **Retarget Pose saved** for every character (A-pose or T-pose reference stored on the asset)
- **IK Rig asset created** per character
- **IK Retargeter asset created** (from the Manny IK Rig to the character's IK Rig)

**Validation checklist (run in-engine per §12 step 15):**
Retarget and confirm clean deformation + correct root travel for:
- Idle
- Walk
- Run
- Jump
- Dodge
- Heavy attack
- Block
- Victory pose

A character is not "retarget-complete" until every animation in this checklist plays correctly with feet planted, no bone popping, and root motion (where applicable per §14) traveling in the correct direction.

---

## 14. Root Motion Policy (Canon)

Eucalyptus Edge is a Soulcalibur-style arena fighter, so **root motion vs. in-place motion must be decided per animation up front** — mixing conventions across the roster later causes desync between movement, collision, and ring-out logic.

**Default policy:**

| Animation       | Root Motion | Notes |
|-----------------|-------------|-------|
| Idle            | No          | In-place |
| Walk            | No          | Driven by movement component |
| Run             | No          | Driven by movement component |
| Dodge           | Yes         | Precise displacement matters |
| Backstep        | Yes         | Precise displacement matters |
| Ring-out shove  | Yes         | Must push opponent a defined distance |
| Ultimate        | Yes         | Cinematic, fixed travel |
| Light combo     | No          | In-place, movement-driven |
| Heavy finisher  | **Prototype** *(subject to gameplay validation)* | See note below |

**Rules:**
- Locomotion (idle/walk/run) is always **in-place**, driven by the movement component — never root motion.
- Precise-displacement actions (dodge, backstep, ring-out shove, ultimate) use **full root motion** so distance is animation-authored and consistent across the cast.
- **"Heavy finisher → Prototype" is subject to gameplay validation.** Its root-motion behavior is not yet locked; validate it in playtesting before finalizing. The *implementation method* (root-motion curves, montage sections, notify-gated blends, etc.) is a technical-animation concern and belongs in the **Animation Bible**, not this gameplay standard.
- Every fighter must use the **same** root-motion decision for the **same** animation type. A move that is root-motion on one character must be root-motion on all.
- Root motion and in-place attacks must both be validated against ring-out and hitbox behavior before shipping.

---

## 15. Production Rule — Expressiveness Before Skins (Canon)

> **Every playable character must be fully expressive before adding alternate skins.**

Cosmetic variants (alternate skins, Blighted variants, DLC costumes) must only be created **after** the base character is a complete, tested rig. This ensures every skin inherits a finished rig instead of multiplying unfinished work across variants.

Required completion order per character:

```text
1. Finish the base mesh.
2. Finish the skeleton.
3. Finish sockets (weapon + support/IK).
4. Finish the facial rig (Phase 1 min set, expression library, EyeAimTarget).
5. Finish animations (locomotion, combat set, reactions).
6. ONLY THEN create cosmetic variants / alternate skins.
```

Do not begin cosmetic variants for a fighter until steps 1–5 are validated in Unreal Engine 5.8 (§12 step 15). A skin built on an unfinished rig will have to be redone every time the base rig changes.

---

## 16. Skeleton Versioning (Canon)

The shared fighter skeleton is versioned. The current version is:

```text
Skeleton Version 1.0
```

**Immutability rule — once a playable fighter ships against a skeleton version:**
- **Never rename** bones.
- **Never delete** bones.
- **Never reorder** bones.

Renaming, deleting, or reordering bones breaks every existing animation, retarget asset, and physics/cloth setup built against that skeleton.

**When new bones become necessary:**
- **Append only** — add new bones without disturbing existing ones.
- **Increment the skeleton version.**
- Document what each version added.

**Version history:**

```text
v1.0  Core body skeleton (Manny-compatible hierarchy, twist bones,
      hand sockets, root at origin). CURRENT.
v1.1  (reserved) Facial bones — jaw, eyes, eyelids, brows, EyeAimTarget.
v1.2  (reserved) Feather / crest controls where required (e.g. Atlas, Kiri).
```

New skeleton versions must remain **backward-compatible** with prior animations (append-only guarantees this). A fighter records which skeleton version it was built against in its rig build record (see §3.1 for the pattern).

---

## 17. Canon Status

This file overrides conflicting older notes concerning:
- weapon hand switching
- weapon fusion to character meshes
- socket naming
- support-hand behavior
- facial-rig requirements
- prototype facial-animation scope
- **Banjo's weapon loadout** (now a single Whip, not dual short blades — see §3, §4.1)
- **roster heights** (now defined canonically in §2.5)
- **weapon grip-pivot placement** (now defined in §4.2)
- **character scaling** (never scale skeletal meshes in UE — §4.3)
- **root motion vs. in-place motion** (now defined per animation in §14)
- **facial expression palette and eye tracking** (now defined in §7.1 / §7.2)
- **skin/variant production order** (expressiveness before skins — §15)
- **animation retargeting requirements** (now defined in §13.1)
- **skeleton bone stability / versioning** (append-only, versioned — §16)

Any future fighter added to Eucalyptus Edge must receive a documented:
- dominant hand
- weapon socket assignment
- weapon attachment rule
- facial anatomy plan
- minimum expression set
- skeleton version built against (§16)

**Companion documents (planned):** This Rigging Bible pairs with three further reference docs to be authored separately — an **Animation Bible** (attacks, combo/blend/montage/notify/hit-frame data, root-motion implementation), a **Combat Bible** (damage, Edge Energy, ring-outs, stun/block/parry, i-frames, combo rules), and a **Character Bible** (one section per fighter: personality, height, colors, weapon, voice, moveset, expressions, unlock conditions, animation references). Together with the existing GDD and Style Guide, these form the core reference set for *Eucalyptus Edge*.
