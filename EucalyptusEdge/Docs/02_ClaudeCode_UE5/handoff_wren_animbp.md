# HANDOFF — ABP_Wren Animation Wiring Spec

**Captured 2026-07-18.** Companion to `Docs/Project/CONTROLLER_LAYOUT.md` (input → action) and `CANON.md` (§ Controls). Follows the **do-NOT-rebuild** directive: `ABP_Wren` already exists and was worked in commit `eac2a2f` ("Ripper/Wren animation sets + combat feel pass") — **extend its existing graph, do not recreate it.**

---

## 1. Ground truth (filesystem audit)

Path: `/Game/EE_ProjectFiles/Characters/WrenKangarooModel/`

- **Rig complete:** `WrenKangaroo` (SkeletalMesh), `WrenKangaroo_Skeleton`, `WrenKangaroo_PhysicsAsset`, `Wren_MatBase` + textures.
- **`ABP_Wren.uasset`** — the one and only Wren AnimBP (~52 KB, non-trivial; already has base graph). **This is the wiring target.**
- **`Anims/` — 41 AnimSequences present.** Full list mapped in §3.
- **`EE_Seq_WrenIdle`** — existing idle sequence (Character-Select use).
- **Gaps:** **no Anim Montages and no Blend Spaces exist for Wren yet.** The reference pattern is `Variant_Combat/Anims/ABP_Manny_Combat` (+ `AM_ComboAttack`, `AM_ChargedAttack`) over a locomotion blendspace (`Characters/Mannequins/Anims/Unarmed/BS_Idle_Walk_Run`). Mirror that shape.

**Blocker:** in-editor wiring needs the `unreal-mcp` bridge, which is **not connected** this session (only Higgsfield/Canva MCP are up). A `.uasset` is binary and cannot be edited as text. Relaunch the editor with `-ModelContextProtocolPort=8765` (XAMPP owns 8000) to let the wiring pass run. Until then this doc is the plan.

---

## 2. Target architecture (mirror ABP_Manny_Combat)

```
AnimGraph:
  [Locomotion State Machine]  ──►  [ "UpperBody"/"DefaultSlot" (montage slot) ]  ──►  Output Pose
        │                                    ▲
        └─ BS_Wren_Locomotion (Idle→Walk→Run, Speed axis)
                                             │
  Montages (Groups C–F) play into the slot, LAYERED over locomotion.
```

- **Locomotion + Air** live **inside** the state machine (Groups A–B).
- **Everything else** (attacks, defense, reactions, round-flow) is a **montage** played into a slot by gameplay code (`BP_Wren`/combat component), NOT a state-machine state (Groups C–F).
- ABP_Wren's job: drive locomotion from variables + expose a montage slot. It should **not** decide which attack fires — that's the pawn/input layer per the controller layout.

---

## 3. The wiring map — all 41 anims

### Group A — Locomotion (into the state machine / blendspace)
| Anim | Role | Driver |
| --- | --- | --- |
| `Wren_Ready_Stance` | Combat idle (locked-on neutral) — **default state** | Speed≈0 |
| `Wren_Idle_Boxing` | Idle break | idle timer |
| `Wren_Idle_Variant` | Idle break variant | idle timer |
| `Wren_Walk` | Walk loop | low Speed |
| `Wren_Walk_Start` | Walk startup | enter walk |
| `Wren_Run` | Run / Dash loop | high Speed / bDashing |
| `Wren_Run_Start` | Run accel | enter run |
| `Wren_Run_Stop` | Run decel | exit run |
| `Wren_TurnInPlace_L` / `_R` | Turn in place | Speed≈0 & yaw delta |

→ Build **`BS_Wren_Locomotion`** (Idle/Ready → Walk → Run on a Speed axis). Start/Stop as transition states; turns fire on near-zero speed + RootYawOffset.

### Group B — Air (state-machine sub-states, driven by `bIsInAir`)
| `Wren_Launch` | Jump/leap-up + juggle launch | enter air |
| `Wren_Falling_Loop` | Airborne loop | in air |
| `Wren_Land_Hard` | Landing recovery | on land |

### Group C — Attacks (montages → slot; triggered by locked inputs)
| Anim | Move | Controller input (CANON § Controls) |
| --- | --- | --- |
| `Wren_Light_Jab` | Light 1 | **X / □** (combo idx 0) |
| `Wren_Light_Cross` | Light 2 | X / □ (idx 1) |
| `Wren_Light_Hook` | Light 3 | X / □ (idx 2) |
| `Wren_Medium_BodyStraight` | Medium 1 | **Y / △** |
| `Wren_Medium_SpringKnee` | Medium 2 | Y / △ |
| `Wren_Heavy_TailSpring_v2` | Heavy 1 | **B / ○** |
| `Wren_Heavy_TailSpringDoubleKick` | Heavy 2 / finisher | B / ○ |

→ Recommend `AM_Wren_Light` (sections Jab→Cross→Hook with combo windows), `AM_Wren_Medium`, `AM_Wren_Heavy`. Combo advance = re-press within the montage's combo notify window.

### Group D — Defense (montages + guard hold; mapped to the LOCKED scheme)
| Anim | Role | Input |
| --- | --- | --- |
| `Wren_Block_Idle` | Guard hold pose | **LB held** (`bIsBlocking`) |
| `Wren_Block_Hit_Light` | Light blockstun/chip | on-block (light) |
| `Wren_Block_Hit_Heavy` | Heavy blockstun/chip | on-block (heavy) |
| `Wren_Parry_Slip` | **Perfect Parry** | **LB fresh tap ≤4f** |
| `Wren_Dodge_BackHop` | Dodge back | **Back + A** |
| `Wren_Dodge_Bound_L` | Dodge left | **Left + A** |
| `Wren_Dodge_Bound_R` | Dodge right | **Right + A** |

### Group E — Reactions (montages, damage/state driven)
| `Wren_Hit_High` / `_Mid` / `_Low` | Hitstun by zone | on-hit height |
| `Wren_Knockdown` | Knockdown | launcher / floor |
| `Wren_GetUp_Front` | Wakeup | after knockdown |
| `Wren_GetUp_TailAssist` | Wakeup variant | after knockdown |
| `Wren_RingOut_Reaction` | Ring-out fall (**Smash pillar**) | ring-out trigger |

### Group F — Round flow & flavor (montages, match-state driven)
| `Wren_RoundStart` | Round-start pose-in | round begin |
| `Wren_Intro_GloveBump` | Pre-fight intro | match intro |
| `Wren_Victory` | Win pose | match win |
| `Wren_Defeat` | Loss pose | match loss |
| `Wren_Taunt_ComeOn` | Taunt A | taunt input |
| `Wren_Taunt_GloveThud` | Taunt B | taunt input |
| `Wren_CS_Attention` | Character-Select pose | CS screen (ABP/sequence) |

---

## 4. ⚠ Coverage gaps — inputs in the locked layout with NO matching Wren anim yet

The set is strong for a first pass but does **not** cover the full locked input map. These need art before those inputs are functional:

- **Neutral spot-dodge** (neutral A, in-place i-frames) — CANON requires it; no `Wren_SpotDodge`/neutral-dodge anim. (Interim: reuse `Wren_Parry_Slip` in place.)
- **Combat Leap** (Forward + A) — no dedicated leap; `Wren_Launch` reads as a hit-launch, not a volitional leap. Likely needs its own anim.
- **Dash** (RT burst) — no dash anim; acceptable to reuse `Wren_Run_Start`/`Wren_Run` short burst, but note it.
- **Edge abilities + Ultimate** (RB + X/Y/B/A → Edge Light/Medium/Ultimate/Mobility Skill) — **none present.** Major combat gap.
- **Grab / Throw** (LB+Light universal throw, LB+Heavy command grab, + thrown-victim & throw-break) — **none present.** Needed for the ring-out throw pillar.

---

## 5. Variables ABP_Wren needs (set from `BP_Wren` each frame)
`Speed` (float), `Direction` (float), `bIsInAir`, `bIsBlocking`, `bIsLockedOn` (strafe vs. free), `RootYawOffset`/`TurnYaw`, `bIsDashing`, `ComboIndex`. Montage playback is triggered from gameplay, not the AnimBP.

---

## 6. Wiring session step order (run when the bridge is up)
1. Open `ABP_Wren`; **audit the existing graph from `eac2a2f`** — extend it. Note what the base state machine already references (may still point at Manny placeholders).
2. Create `BS_Wren_Locomotion` (Idle/Ready → Walk → Run); drop into the Locomotion state; verify `Speed` drives it.
3. Add `Walk_Start` / `Run_Start` / `Run_Stop` as start/stop transition states; wire `TurnInPlace_L/R` on near-zero speed.
4. Add Air sub-states `Launch → Falling_Loop → Land_Hard` on `bIsInAir`.
5. Create the Group C–F montages; confirm a **slot node** sits **after** the locomotion pose in the AnimGraph so montages layer over movement.
6. Leave "which input plays which montage" to `BP_Wren`/combat component per `CONTROLLER_LAYOUT.md`.
7. Compile → assign `ABP_Wren` to the `WrenKangaroo` mesh in `BP_Wren` → PIE-test.

---

## 7. Cross-refs
- `Docs/Project/CONTROLLER_LAYOUT.md` — the input scheme these anims serve.
- `CANON.md` § Controls — locked rulings (Light/Medium/Heavy, LB parry/guard, dodge Back/L/R + spot, no forward dodge, Edge on RB, grab on LB+Attack).
- `Docs/02_ClaudeCode_UE5/handoff_ui_polish.md` — sibling UE-implementation handoff (POLISH, don't rebuild).
- Reference AnimBP to mirror: `Content/Variant_Combat/Anims/ABP_Manny_Combat`.
