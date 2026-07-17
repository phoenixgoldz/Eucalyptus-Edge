# EUCALYPTUS EDGE — PHASE 1 ROADMAP & MILESTONE DEFINITION

**Status:** Active production plan  
**Companion to:** Rigging Bible v1.0 (LOCKED), GDD, Style Guide  
**Last updated:** this session

---

## Strategic Insight — Why Wren & Ripper First

Wren and Ripper are the only two fighters whose weapons are **part of the character**, with **no detachable weapon**:

- **Wren** → Verdant boxing gloves (baked or permanently attached)
- **Ripper** → Natural claw gauntlets / claws (permanently attached)

Every other fighter (Koda, Kiri, Atlas, Echo, Banjo, Sonia) is **blocked** on the full weapon-socket + grip-pivot + attachment pipeline (Rigging Bible §4.1–§4.2) being proven in-engine.

Wren and Ripper are **not** blocked on that. This decouples two questions that would otherwise be serialized:
- "Is the core combat loop fun?" (provable now, with Wren + Ripper)
- "Does weapon attachment work end-to-end?" (can proceed in parallel)

**This is the critical path to first playable gameplay footage.**

---

## MILESTONE — Vertical Slice v0.1

**Goal:** Play Wren vs. Ripper from main menu → results screen, consistently.

**Arena:** Eucalyptus Summit

**Fighters:**
- Wren — fully playable (disciplined counter-puncher: fast footwork, boxing combos, counters)
- Ripper — fully playable (wild aggressor: spin attacks, heavy pressure, constant offense)

**Systems in the slice:**
- Character select
- Character intros
- Camera system + lock-on
- Movement
- Light attacks / heavy attacks
- Blocking / dodging
- Hit reactions
- Ring-outs
- Victory / defeat screens
- Basic announcer
- Sound effects + music
- Full HUD — health bars + Edge Energy meter
- First gameplay trailer captured

**Definition of done:** the core combat loop is consistently playable and *fun* start to finish. Everything after v0.1 is roster + content expansion, not proving the game works.

**Design intent — the contrast sells depth:** Wren (calm, disciplined, counter) vs. Ripper (wild, aggressive, pressure) demonstrates build/style diversity in the very first duel.

### Demo Exit Criteria (Quality Gate)

The slice is **complete** only when ALL of the following are true:

- Players can launch directly into a match from the main menu.
- One complete match plays from intro → results with **no crashes**.
- Both fighters have complete **light, medium, heavy, dodge, block, and Edge Energy** abilities.
- Ring-outs function correctly.
- Victory and defeat sequences play correctly.
- Performance is stable on target hardware.
- **The match is fun enough that testers voluntarily ask for another round.**

> The final criterion is the real gate. It is a **behavioral** metric, not a checklist item — it cannot be faked. If testers finish a match and immediately say "let's play again," the core loop is validated. If they don't, that is the signal to **refine combat before expanding the roster**. Do not add fighters past v0.1 until this gate is cleared. Every prior criterion proves the game *works*; this one proves the game is *good*.

### "Poster Match" — Wren vs. Ripper

Wren vs. Ripper is the **face of the Phase 1 prototype** — the readable rivalry that fronts all first-impression material, in the tradition of Ryu vs. Ken, Scorpion vs. Sub-Zero, Mitsurugi vs. Nightmare, Kazuya vs. Jin. The contrast (technical counter-fighter vs. high-risk aggressor) signals "characters have distinct identities" in a single screenshot.

---

## Watch Item — Ripper Rig
Ripper's skeleton was hand-rigged (AccuRIG failed on him). Known weak areas: shoulder/armpit and forearm-twist weights. Canon §3 requires his **spin attacks** to preserve hand assignments and use animation-driven hitboxes — those spins will stress exactly those weight areas. Watch shoulder/forearm deformation during fast rotation; fixable with a weight-paint pass if it pops.

---

## Post-Slice Roster Expansion — System-Validation Framing

**Core principle:** Each fighter is not "another character" — each is the **first proof that one major gameplay system works.** "Done" for a milestone means that *system* is validated and every future fighter that uses it is de-risked. This is the difference between milestones that reduce risk and milestones that merely add content.

| Milestone | Fighter | System validated | Falsifiable question |
|-----------|---------|------------------|----------------------|
| **A — Combat** | Wren + Ripper | Core combat loop | Is the game fun? (Demo Exit Criteria gate) |
| **B — Weapon System** | Koda | `WeaponSocket_R`, `SupportHand_IK`, two-handed grip, weapon pivots, separate weapon meshes, animation sync | Does the two-handed weapon system work end-to-end? |
| **C — Projectile System** | Kiri | Boomerang detach → travel → recall → reattach; mid-range zoning | Does projectile/return weapon logic work? |
| **D — Reach & Spacing** | Atlas | Polearm reach, tall-silhouette neutral, spacing-based combat | Does long-reach neutral read differently and feel distinct? |
| **E — Dual Weapons** | Echo | Twin tonfas, two active sockets, independent per-weapon hit detection | Does the dual-weapon system work? |
| **F — Flexible Weapons** | Banjo | Whip: bone-chain / Chaos-Cloth lash, simulation-driven hitboxes, grapples, glide attacks | Does flexible-weapon simulation work? |
| **G — Advanced Throw Mechanics** | Sonia | Twin chakrams detach/travel/return; secret unlockable; DLC teaser | Do advanced throw + return mechanics work? |

**Why this order de-risks the project:**
- Koda (B) proves the single two-handed weapon system, so **Atlas (D) becomes low-risk** — the underlying system is already validated; Atlas is a reach/spacing test, not a new-tech test.
- Each milestone answers **one clear technical question** before the next layer of complexity is introduced.
- A failure is diagnosable: if Echo's dual tonfas break, the single-weapon socket is already proven (Koda), so the bug is isolated to the dual-hit-detection layer specifically.

**Development philosophy:** shifted from *"build everything"* to *"prove one thing at a time."* Each fighter validates one system rather than incrementing a roster count.

### The Template Principle (Milestone Completion Rule)

> **A milestone is complete only when its validated system becomes the template for every future implementation of that system.**

This is what makes the milestones *compound* rather than merely *sequence*. A milestone doesn't just solve today's problem — it establishes the reusable standard for everything that follows, so each future fighter using that system is *instantiated* from a proven template rather than re-solved from scratch.

- After **Milestone B**, Koda's weapon Blueprint is the **template** for Atlas and all future two-handed fighters.
- After **Milestone C**, Kiri's boomerang system is the **template** for any returning projectile.
- After **Milestone E**, Echo's dual-weapon architecture is the **template** for every future dual-wield character.
- After **Milestone F**, Banjo's flexible-weapon solution is the **template** for every future whip, chain, rope, or vine weapon.

**Consequence:** each fighter costs progressively *less* to implement, because the hard system work is done once and reused. Atlas is not "build a polearm fighter" — he is "instantiate the proven two-handed template with reach tuning." This is why the order matters and why milestone completion means *template established*, not just *fighter playable*.

---

## Staged Marketing Timeline (Milestones = Content Drops)

Each vertical slice is both a build milestone and a marketing beat. Content releases in stages instead of waiting for the full roster.

| Slice | Adds | Demonstrates | Marketing beat |
|-------|------|--------------|----------------|
| v0.1 | Wren + Ripper | Core combat loop, ring-outs, HUD, Edge Energy | Gameplay reveal trailer, Steam page gameplay, Kickstarter update, dev diary, combat showcase, GIFs/shorts |
| v0.2 | Koda | Two-handed staff, weapon sockets, support-hand IK, longer combos | "First weapon fighter" reveal |
| v0.3 | Kiri | Projectile weapon, boomerang recall, mid-range zoning | "Zoning/projectile" reveal |
| v0.4 | Atlas | Polearm reach, tall silhouette, spacing, different neutral game | "Reach changes everything" reveal |

By v0.4, viewers understand every fighter plays differently — the roster reads as *deep*, not cosmetic. Each drop reuses the proven pipeline, so new fighters strengthen a tested foundation rather than introducing new risk.

**Footage to capture once v0.1 is playable:** character reveal trailers, gameplay trailers, Steam page videos, Kickstarter updates, GIFs, social clips, dev logs, YouTube Shorts, TikTok clips. No more relying on concept art — real gameplay.

### First Gameplay Trailer — Beat Sheet (60s, buildable with 1 arena + 2 fighters)

| Time | Content |
|------|---------|
| 0–5s | PhoenixGold Games logo → Verdantia logo → Eucalyptus Summit establishing shot |
| 5–10s | Wren walks into the arena; Ripper emerges opposite; character name cards |
| 10–20s | Neutral movement, side-stepping, camera circling (sell the 3D arena) |
| 20–40s | Light combos, heavy attacks, blocks, dodges, parries, Ripper spin attack, Wren counter combo |
| 40–50s | Edge Energy fills; both fighters unleash specials |
| 50–60s | Ring-out finish → victory pose → logo → "Wishlist on Steam" |

Entirely producible from the v0.1 slice — no additional arenas or fighters required.

### Emergent Rivalry
Before the full roster exists, players naturally ask **"who's better?"** — some gravitate to Wren's disciplined boxing, others to Ripper's relentless offense. That build-identity debate is exactly the discussion a healthy fighting game generates, and it starts with just these two.

---

## Immediate Implementation Queue (this week, at desktop)

1. **Atlas orientation validation** — fix Blender→UE5.8 export axis so he imports upright, facing +X, with NO root/Blueprint rotation (Rigging Bible §4.3 + §13.1). Lock the result as the **canonical export preset** for the whole roster.
2. **Banjo** — import corrected FBX → scale 120 cm → rename Tripo bones to Manny convention → re-weight tail to pelvis → wire full PBR → verified export. Then whip: handle at `WeaponSocket_R`, lash via bone chain / Chaos Cloth (§4.1).
3. **Atlas Windspine Polearm** — separate weapon mesh, pivot at right-hand grip (§4.2), attach to `WeaponSocket_R`, left hand via `SupportHand_IK`.
4. **Phase 1 facial rigs** — Wren, Ripper, Koda, Kiri, Atlas, Banjo, Echo (bumps skeleton to v1.1).
5. **Shared IK Retargeter** — build from Manny IK Rig; verify §13.1 checklist across roster.
6. **Combat animation authoring** — begin in UE, starting with Wren + Ripper for the slice.

Priority reality: **Wren + Ripper combat is the near-term focus** — it unblocks the trailer. Weapon-fighter work proceeds in parallel but is not on the v0.1 critical path.

---

## Documentation Policy

Rigging Bible v1.0 is **FROZEN**. Companion documents (Animation Bible, Combat Bible, Character Bible) are authored **only when implementation reaches the systems they describe** — not speculatively up front. This keeps docs aligned with reality.

### Rigging Bible v1.1 backlog (write after Atlas + Banjo validate the pipeline):
- **Control Rig Standard** — what Control Rig owns (foot IK, hand IK, weapon alignment, EyeAimTarget, finger posing, pole vectors, procedural breathing, secondary motion) vs. what's baked into animation. *Needs a real in-engine animation to standardize against.*
- **Animation Notify Standard** — shared notify names: AttackStart, AttackActive, AttackEnd, Footstep, WeaponTrailOn, WeaponTrailOff, EdgeCharge, CameraShake, HitPause, VoiceCue. *Needs a real attack montage to standardize against.*
- **Physics Asset Standard** — capsule sizes, ragdoll limits, cloth collision, weapon collision, tail collision, feather collision. *First real test cases are Banjo's whip and Atlas's feathers.*
