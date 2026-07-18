# EUCALYPTUS EDGE — CONTROLLER LAYOUT (Phase 1 Standard)

**Status:** Phase 1 Standard, captured 2026-07-17. The 5 previously-open questions were **resolved 2026-07-18** and their rulings promoted to `CANON.md` (§ Controls). The layout below is authoritative; each resolution is marked **✅ RESOLVED** inline and summarized under [Resolved Decisions](#resolved-decisions-2026-07-18).

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

**Default: auto-locked onto the opponent at round start** (single-target 1v1). Lock is toggled with **L3**; see the lock-on resolution under Shoulder Buttons.

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
| LT | L2 | Lock Target (hold — momentary override; see below) |
| RT | R2 | Dash / Sprint Burst |

> **✅ RESOLVED (lock-on):** Default is **auto-lock onto the opponent at round start** (1v1, single target). **L3 (click) is the canonical toggle** — click to drop to free camera, click again to re-lock; since you are locked for almost the entire match, a toggle beats holding a trigger. **LT (hold) coexists as a momentary override:** while unlocked, hold LT to snap back to locked framing, release to return to free camera — it never fights the L3 toggle state. Whether L3 acts as pure toggle or hold-to-maintain is the **Accessibility → Toggle/Hold** setting (default = toggle), which also applies to Block and Dash.

### System Buttons

| Xbox | PlayStation | Action |
| --- | --- | --- |
| Menu (☰) | Options | **Pause** — opens Pause Menu. **Reserved; never a gameplay action.** |
| View (⧉) | Create / Share | Match Info overlay (hold); in Training, toggle Input Display. Non-critical. |

> **✅ RESOLVED (pause button):** Pause is the platform-standard **Menu / Options** button, reserved so no gameplay action can ever bind to it. **View / Share** is held for a non-critical overlay.

---

## Dodge

- Tap **A**.
- **Directional dodge: Back, Left, Right** (no forward dodge — see rule below).
- **Neutral A (no stick) = spot dodge:** in-place, no travel, i-frames on timing — safe beside ring edges and rewards reads.
- Invulnerability depends on **timing**, not distance.

> **✅ RESOLVED (no forward dodge — by design):** `Forward + A` is the **Combat Leap**, not a dodge, so there is deliberately no forward i-frame dodge. Forward movement is fully covered elsewhere — **Dash (RT)** for grounded pressure, **Combat Leap** for aerial approach — and reserving forward for the leap keeps approaches committal (no cheap i-frame rush-through). **Rule:** dodge is defensive (Back/Left/Right + neutral spot-dodge); forward is always the Leap.

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
- Perfect timing → **Perfect Guard** (LB tap-vs-hold disambiguation defined under Parry).

---

## Parry

- Tap **LB** during impact.
- Creates **Perfect Parry**. Consumes no Edge Energy. Rewards timing.

> **✅ RESOLVED (LB disambiguation — press-edge vs hold):** parry and guard are told apart by **when LB's press-edge lands relative to the incoming hit**, so their windows never overlap. On the frame an attack connects:
> - **Perfect Parry** — a **fresh LB press** whose down-edge lands **≤ 4 frames** before connect (an on-reaction tap; you were *not* already holding block). Full negate, **no Edge cost**, large counter/advantage window.
> - **Perfect Guard** — LB was **pressed/held 5–8 frames** before connect (you committed to guard slightly early and kept holding). Negates chip, small advantage; you stay in block.
> - **Normal Block** — LB held, edge older than 8 frames. Chip (optional) + blockstun.
>
> Because parry requires a **fresh press in the tightest/latest window** and guard requires a **sustained hold**, they are non-overlapping by construction — **you cannot parry from an already-held guard** (holding block never yields free parries; you must commit an active tap). Frame values are first-pass; tune in playtest. All windows are subject to the **Accessibility → input-buffer / toggle-hold** options.

---

## Grab / Throw

Resolved **off** the (full) RB Edge layer onto **Guard + Attack**, mirroring Soulcalibur's A+G throw idiom:

| Input | Result |
| --- | --- |
| **LB + Light** (Guard + X/□) | **Universal Throw** — every fighter has it; beside a ledge it doubles as a **ring-out** tool |
| **LB + Heavy** (Guard + B/○) | **Command Grab** — character-specific (grapplers; may be unbreakable) |
| **LB + direction + Light** | Directional throw (throws toward the held side) |

- **Throw break / tech:** tap **Light** on reaction as a Universal Throw connects to break it (command grabs may be unbreakable per character).
- **Input rule:** LB+Attack registers as a throw only when both land within **~3 frames**; otherwise it reads as guard/parry (LB) then attack. Throwing straight out of a held block is intended (the SC guard-throw flow).

> **✅ RESOLVED (grab collision):** The old `RB + Light` / `RB + Heavy` proposal collided with Edge Light and Ultimate (the RB layer is full). Moved to **Guard (LB) + Attack** — no collision with the RB Edge layer, on-brand with SC's A+G throw, and the universal throw doubles as ring-out pressure (Smash pillar).

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

Opened with **Menu (Xbox) / Options (PS)** — see [System Buttons](#system-buttons).

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

## Resolved Decisions (2026-07-18)

All five prior open questions are closed and promoted to `CANON.md` (§ Controls). Summary:

1. **Grab input collision → Guard + Attack.** `LB + Light` = **Universal Throw** (also a ring-out tool), `LB + Heavy` = character **Command Grab**. Frees the RB Edge layer; on-brand with Soulcalibur's A+G throw. *(details: [Grab / Throw](#grab--throw))*
2. **Pause button → Menu / Options.** Platform-standard, **reserved**, never a gameplay action; View/Share held for a non-critical overlay. *(details: [System Buttons](#system-buttons))*
3. **Lock-on → auto-lock + L3 toggle canonical.** Auto-locked at round start (1v1); **L3 = toggle** (primary); **LT = momentary hold override**; toggle-vs-hold is an Accessibility setting. *(details under Shoulder Buttons)*
4. **Forward dodge → none, by design.** Dodge is Back/Left/Right + neutral spot-dodge; `Forward + A` is the Combat Leap; grounded forward pressure is Dash (RT). *(details: [Dodge](#dodge))*
5. **Guard vs Parry on LB → press-edge vs hold.** Fresh LB press ≤4f pre-hit = **Perfect Parry** (no Edge cost); held 5–8f = **Perfect Guard**; older hold = Normal Block. Cannot parry from a held guard; frame values tunable. *(details: [Parry](#parry))*

Frame windows and throw-break timings are first-pass values to be tuned in playtest; the input *assignments* above are locked.
