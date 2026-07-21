# ANIMBP + CHARACTER-SELECT WIRING SPEC
**Authored 2026-07-20 (Claude Code, UE terminal).** Covers Atlas, Banjo, Ripper, Wren.

---

## 0. Actual ABP state (corrected 2026-07-20)

> ⚠ **Correction to an earlier draft of this doc.** It claimed all three ABPs were empty, based on `BlueprintTools.read_graph_dsl` returning an empty string for every AnimGraph. **That was wrong** — `read_graph_dsl` only serialises K2 (Blueprint) nodes and is blind to AnimGraph nodes. Use `BlueprintTools.find_nodes` instead, which does see them. Never conclude an AnimGraph is empty from `read_graph_dsl`.

Verified with `find_nodes`:

| ABP | AnimGraph nodes | Sequence | State |
|---|---|---|---|
| **ABP_Wren** | Root + SequencePlayer + Slot | `Wren_Idle_Boxing`, looping | ✅ healthy |
| **ABP_Ripper** | Root + SequencePlayer + Slot | was **null** → set to `Ripper_Idle_Aggressive`, looping | ✅ fixed |
| **ABP_Atlas** | **Root only** | — | ⚠ no SequencePlayer, no Slot |
| **ABP_Banjo** | — | — | ⛔ does not exist |

**Wren and Ripper already implement the §2 architecture** (`SequencePlayer → Slot → Output Pose`) — so that *is* the house pattern, and §2 documents it rather than inventing it.

**ABP_Ripper's compile failure** (`"[Compiler] Sequence Player references an unknown Anim Sequence Base"`) was a **null** sequence reference — the node pointed at `Ripper_Ready_Stance`, which went missing as a phantom registry entry; re-importing the asset does **not** reconnect the node. Fixed and recompiled clean.

**ABP_Atlas will not error** — it will silently render a static reference pose, which is the more dangerous failure. It needs a Sequence Player (`Atlas_Idle_Combat`, loop on) and a `DefaultSlot` added by hand.

**MCP cannot author AnimGraph nodes.** `create_node`'s type registry exposes only K2 node types (casts, struct nodes) — no `AnimGraphNode_*`. It *can* however **edit existing anim nodes** via `ObjectTools.set_properties` on the node's `node` struct (that is how ABP_Ripper was repaired):
```
instance: <ABP>.<ABP>:AnimGraph.AnimGraphNode_SequencePlayer_N
values:   {"node": {"sequence": {"refPath": "..."}, "bLoopAnimation": true}}
```

---

## 1. Character Select needs NO AnimBlueprint — do this first

The shipped, PIE-verified Character Select already drives fighters **without** AnimBPs, via single-node animation:

- `BP_EE_CharacterShowcasePoint` holds per-fighter instance-editable **Idle / Attention / Confirm** anim refs plus `bPlayAnims`
- `FlyToFighter(ID)` → `OnHighlighted` → plays the fighter's idle
- `FlyToClose` → `OnConfirmed` → plays the confirm take
- Preview meshes use `AnimationMode = Use Animation Asset`

So the fastest path to a working Character Select is to point the seven `EE_SP_<Name>` showcase points at the right takes. **All loop flags below are already set and saved.**

### Per-fighter assignment table

| Fighter | Idle (loops) | Attention / Highlight | Confirm |
|---|---|---|---|
| **Banjo** | `Banjo_CS_Idle` ✅loop | `Banjo_CS_Highlight` ✅loop | **`Banjo_CS_Confirm_Whip`** |
| **Atlas** | `Atlas_CS_Idle` ✅loop | `Atlas_Ready_Stance` | `Atlas_Intro_SkywardPlant` |
| **Ripper** | `Ripper_CS_Idle` ✅loop | `Ripper_Ready_Stance` ✅loop | `Ripper_Intro_Prowl` |
| **Wren** | `Wren_CS_Attention` ✅loop | `Wren_Ready_Stance` ✅loop | `Wren_Intro_GloveBump` |

**Banjo is the only fighter with purpose-authored CS takes** (Idle / Highlight / Confirm). The other three borrow `Ready_Stance` for attention and an `Intro_*` for the confirm flourish — substitutes, not authored CS beats. If you want parity, that is a Blender work order, not a UE one.

**Use `Banjo_CS_Confirm_Whip`, not `_PreWhip`.** `PreWhip` was authored as the placeholder for when no whip mesh existed ("whip-crack version comes with the whip"). The whip is now imported, so the whip version is the correct one.

### Root-motion check — all four confirm picks are safe
`PROJECT_STATE` records a prior failure where an RM take was used as the lock-in pose and *"root motion lunges the preview out of the close camera frame."* I checked every pick against the applied RM flags:

- `Banjo_CS_Confirm_Whip` — not in Banjo's 13 RM takes ✅
- `Atlas_Intro_SkywardPlant` — Atlas's only RM take is `Atlas_Edge_CycloneLance_RM` ✅
- `Ripper_Intro_Prowl` — not in Ripper's 5 RM takes ✅
- `Wren_Intro_GloveBump` — Wren's only RM takes are the 3 dodges ✅

Do **not** substitute `Banjo_Intro_CanopyDrop` (RM, includes a Z −2.00 drop) or any dodge.

---

## 2. Shared AnimBlueprint architecture (for combat — author once, repeat ×4)

Identical for all four fighters. Only the target skeleton and the blendspace speed values differ.

**Asset:** right-click → Animation → Animation Blueprint · Parent `AnimInstance` · Target Skeleton per fighter.

### Variables
| Name | Type | Purpose |
|---|---|---|
| `Speed` | float | ground speed, drives the locomotion blendspace |
| `Direction` | float | −180..180, strafe blending (Atlas/Banjo only — Wren and Ripper have no strafe takes) |
| `bIsInAir` | bool | jump/fall states |
| `bIsBlocking` | bool | block state entry |
| `bIsCrouching` | bool | Banjo only (`Banjo_Crouch`) |

### EventGraph — `Event Blueprint Update Animation`
```
TryGetPawnOwner → IsValid ?
  → GetVelocity → VectorLength                → Speed
  → GetVelocity + GetActorRotation → CalculateDirection → Direction
  → GetMovementComponent → IsFalling          → bIsInAir
```

### AnimGraph
```
State Machine "Locomotion"  →  Slot 'DefaultSlot'  →  Output Pose
```
The **`Slot 'DefaultSlot'` node is mandatory** — without it no montage (attack, dodge, reaction, CS confirm) can play over locomotion. It is the single most important node in the graph.

**Locomotion states:** `Idle` → `Walk/Run` (BlendSpace1D on `Speed`) → `Jump`/`Fall` gated on `bIsInAir` → `Block` gated on `bIsBlocking`.

### Blendspace speed axes (authored, measured — match `MaxWalkSpeed` to these)
| Fighter | Walk | Run | Backward | Strafe | Source |
|---|---|---|---|---|---|
| Atlas | 68.3 cm/s | 179.6 | 66.7 | 73.9 | gate prompt Stage 6 |
| Wren | 85 | 279 | — | — | WREN report |
| Ripper | 100 | 280 | — | — | RIPPER report |
| Banjo | **undocumented** | — | — | — | ⚠ needs measuring |

⚠ **Banjo has no published gait speeds.** Every other fighter's locomotion contract is measured; his is not. Flag to the Blender side before tuning his movement component.

---

## 3. Banjo specifics

**Banjo does NOT need a unique animation graph.** His whip is a separate skeletal mesh riding the *same* 70-bone `SK_Banjo_Skeleton` via Leader Pose — the whip component copies every bone, `lash_01..12` included, and needs no AnimBP of its own. The whip is fully baked (`"No runtime cloth/physics on the whip — all lash motion is baked"`). Use the §2 architecture unchanged.

Add `bIsCrouching` (he has `Banjo_Crouch`, looping) and note he has `Banjo_Glide_Loop` + `Banjo_Jump_Loop` for an aerial sub-state the other three lack.

**Creating `ABP_Banjo` (manual, ~3 min):**
1. Content Browser → `/Game/EE_ProjectFiles/Characters/BanjoModel/Anims/` → right-click → Animation → **Animation Blueprint**
2. Parent Class `AnimInstance` · Target Skeleton **`SK_Banjo_Skeleton`**
3. Name `ABP_Banjo`
4. Author per §2

---

## 4. Current animation flag state (applied + saved 2026-07-20)

| Fighter | Anims | Loops | Root motion | Source of truth |
|---|---|---|---|---|
| Atlas | 56 | 9 | 1 | gate prompt Stage 5 |
| Banjo | 69 | 17 | 13 | `_ue_manifest.json` — exact |
| Ripper | 40 | 7 | 5 | `_ue_manifest.json` — exact |
| Wren | 41 | 8 | 3 | production report + Rigging Bible §14 |

Wren's flags are **inferred**, not manifest-driven — he predates the standardised manifests. Policy confirmed by Phoenix 2026-07-20: `Ready_Stance`, `Idle_Variant`, `CS_Attention` loop; dodges are root motion; walk/run stay in-place; ring-out shove gets root motion **only if it actually moves the capsule in gameplay** (currently authored as a reaction, so left off).

Counts differ per fighter by design — Atlas carries a polearm set, Banjo a flexible-weapon set, Wren and Ripper were produced earlier against a smaller scope. The test is gameplay coverage, not file parity.
