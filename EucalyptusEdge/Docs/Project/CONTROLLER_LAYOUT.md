# EUCALYPTUS EDGE — CONTROLLER LAYOUT (Phase 1 Standard)

**Status:** Draft standard, captured 2026-07-17. Design intent below is authoritative *except* for the items marked **⚠ OPEN QUESTION** — those are unresolved and deliberately deferred (see [Open Questions](#open-questions-to-resolve-before-locking) at the end). Do not treat this as CANON-locked until those close.

Design pillars this scheme serves: **Soulcalibur** weapon combat + free 3D movement, **Dragon Ball Z: Sparking! ZERO** camera/lock-on feel, **Super Smash Bros.** ring-out emphasis. Target hardware: modern Xbox and PlayStation controllers.

---

## Movement

| Input | Action |
| --- | --- |
| Left Stick | 360° Movement |
| Right Stick | Camera Orbit (when unlocked) |
| Click Left Stick (L3) | Lock / Unlock Target |
| Click Right Stick (R3) | Reset Camera Behind Fighter |

Movement is completely analog. Unlike Soulcalibur's fixed 8-way run, players move freely around the arena.

---

## Camera

Blends **DBZ: Sparking! ZERO**, **Soulcalibur VI**, and modern third-person action cameras.

### Locked Target (default combat mode)

The camera:
- keeps both fighters visible
- rotates smoothly
- never snaps
- keeps the horizon level
- zooms slightly based on distance
- never clips into scenery
- maintains cinematic framing

> "Over-the-shoulder cinematic arena camera."

### Unlocked Camera

Free exploration. Right stick controls camera. Useful in Training Mode.

### Camera Rules (Very Important)

Never behave like Tekken's rigid side view or a free-flight Dragon Ball camera. Use a **dynamic arena camera** that always frames the fight clearly:

- Keep both fighters on screen whenever possible.
- Smoothly orbit around the midpoint between fighters.
- Zoom out as fighters separate, zoom in slightly as they close.
- Preserve a stable horizon to avoid disorientation.
- Avoid sudden snaps when players sidestep or circle each other.
- Automatically adjust to arena elevation changes without dramatic pitch changes.
- Prevent clipping through terrain, trees, rocks, and props with camera collision handling.
- During Edge Ultimates, briefly transition to a cinematic shot, then blend seamlessly back to the gameplay camera **without changing player orientation**.

---

## Combat Buttons

### Face Buttons

| Xbox | PlayStation | Action |
| --- | --- | --- |
| X | □ | Light Attack |
| Y | △ | Medium Attack |
| B | ○ | Heavy Attack |
| A | ✕ | Dodge / Evade |

### Shoulder Buttons

| Xbox | PlayStation | Action |
| --- | --- | --- |
| LB | L1 | Block / Guard |
| RB | R1 | Edge Ability Modifier |
| LT | L2 | Lock Target (hold) |
| RT | R2 | Dash / Sprint Burst |

> **⚠ OPEN QUESTION (lock-on inputs):** L3 (toggle) and LT (hold) both lock target. The dual scheme is intentional (SC-style toggle + DBZ-style hold), but the canonical **default** and how the two coexist is not yet decided. See Open Questions.

> **⚠ OPEN QUESTION (pause / menu button):** No Start/Options/Menu button is assigned in Movement/Combat/Shoulders, yet a Pause Menu exists. Which physical button opens pause must be reserved so it is never bound to a gameplay action. See Open Questions.

---

## Dodge

- Tap **A**.
- Directional: Forward, Back, Left, Right.
- Invulnerability depends on **timing**, not distance.

> **⚠ OPEN QUESTION (no forward dodge):** `Forward + Dodge` is reserved for Combat Leap (below), so there is no neutral **forward** dodge — only Back / Left / Right, plus the leap. Intended as a committal-advance tradeoff, but flagged so it is not implemented as an omission. See Open Questions.

---

## Dash

- Hold **RT**.
- Not a permanent sprint. It is a Combat Burst: fast reposition, quick chase, escape spacing.
- Keeps fights tactical instead of turning into constant running.

---

## Jump

This is an arena fighter, not a platform fighter, so **no dedicated jump button**.

- `Forward + Dodge` → **Combat Leap**.
- Specific fighters (e.g. Wren) naturally leap much higher as part of their move set.

---

## Blocking

- Hold **LB**.
- Directional: front block; high/low handled by move properties; chip damage optional.
- Perfect timing → **Perfect Guard**.

---

## Parry

- Tap **LB** during impact.
- Creates **Perfect Parry**. Consumes no Edge Energy. Rewards timing.

> **⚠ OPEN QUESTION (Perfect Guard vs Perfect Parry share LB):** Hold-with-timing (Perfect Guard) and tap-at-impact (Perfect Parry) both live on LB. Their tap-window and hold-onset definitions must not overlap. Timing spec deferred. See Open Questions.

---

## Grab (Future)

- `RB + Light` **or** `RB + Heavy`, depending on character.
- Not universal — character specific.

> **⚠ OPEN QUESTION (RB + Heavy / RB + Light collision):** As written, Grab overlaps the Edge modifier layer entirely — `RB + Light (X)` is already **Edge Light** and `RB + Heavy (B)` is already **Ultimate**. Grab needs its own input. Deferred, no resolution chosen. See Open Questions.

---

## Edge Energy

**RB** acts as a modifier:

| Combo | Result |
| --- | --- |
| RB + X (Light) | Edge Light |
| RB + Y (Medium) | Edge Medium |
| RB + B (Heavy) | Ultimate |
| RB + A (Dodge) | Character Mobility Skill |

This avoids wasting buttons.

---

## Ultimate

- Requires a **full Edge Meter**.
- Press **RB + Heavy** (RB + B).
- Huge cinematic attack.

---

## Training Shortcuts (Training Mode only)

| D-pad | Action |
| --- | --- |
| Up | Reset Positions |
| Left | Slow Motion |
| Right | Frame Step |
| Down | Toggle Hitboxes |

---

## Menus

### Main Menu

| Input | Action |
| --- | --- |
| Left Stick / D-pad | Navigate |
| A | Confirm |
| B | Back |
| Y | Open News / Patch Notes |
| X | Profile |
| LB / RB | Switch Tabs |

### Character Select

| Input | Action |
| --- | --- |
| Left Stick | Move Cursor |
| A | Select Character |
| B | Cancel |
| Y | Random |
| X | Costumes |
| LB | Previous Costume |
| RB | Next Costume |
| LT | Player Card |
| RT | Ready |

### Stage Select

| Input | Action |
| --- | --- |
| Left Stick | Move |
| A | Choose Stage |
| B | Back |
| Y | Random |
| X | Preview Stage |

### Pause Menu

| Input | Action |
| --- | --- |
| Up / Down | Navigate |
| A | Confirm |
| B | Resume |
| X | Controller Mapping |
| Y | Match Details |

### Spectator Camera (later, online)

| Input | Action |
| --- | --- |
| Right Stick | Free Look |
| Triggers | Zoom |

---

## Local Multiplayer

Supports Player 1 (Xbox Controller 1) and Player 2 (Xbox Controller 2). Both controllers can:
- Navigate menus
- Join at character select
- Ready independently
- Swap controller ownership if needed

## Online (Phase 3+)

2 players, peer-to-peer initially or dedicated server later. Lobby, Invite Friend, Private Match, Quick Match, Ranked. Spectator later. Same control scheme and UI as local — **no gameplay differences between local and online**.

---

## HUD

| Region | Contents |
| --- | --- |
| Lower Left | Health, Edge Meter, Character Portrait, Player Name (P1) |
| Lower Right | Same for opponent |
| Top Center | Round Timer |
| Top Left | Round Wins |
| Top Right | Opponent Wins |

---

## Phase 1 Controller Support

**Launch:**
- ✅ Full controller navigation throughout the entire game.
- ✅ Up to **2 local players** (split-input on one machine, no split-screen).
- ✅ Keyboard and mouse used only for development/debugging (not required for players).

**Future:**
- 🌐 Up to **2 online players** with the same control scheme and UI.

---

## Open Questions (to resolve before locking)

These are deferred by decision on 2026-07-17. The layout above is otherwise the working standard.

1. **Grab input collision.** `RB + Light` / `RB + Heavy` for Grab collide with Edge Light and Ultimate respectively; the RB-modifier layer (X/Y/B/A → Edge Light/Medium/Ultimate/Mobility) is already full. Grab needs a non-conflicting home before it ships.
2. **Pause/menu button.** Assign and reserve the physical button (Start/Options/Menu) that opens the Pause Menu, so it is never bound to a gameplay action.
3. **Lock-on default.** Decide the canonical default between L3 (toggle) and LT (hold), and confirm both coexist as intended.
4. **Forward dodge.** Confirm the intentional absence of a neutral forward dodge (Forward + A → Combat Leap) is the desired behavior, and document it as a rule.
5. **Perfect Guard vs Perfect Parry timing.** Define non-overlapping tap-window (Parry) and hold-onset (Guard) windows, since both share LB.

*When these close, promote the resolved decisions into `CANON.md` and remove the ⚠ markers above.*
