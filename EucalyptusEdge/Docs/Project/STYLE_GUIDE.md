# Eucalyptus Edge — Style Guide

**Version:** 1.1  
**Status:** Canon  
**Last Updated:** July 2026

---

## Purpose

This document defines the permanent visual, UI, combat, animation, camera, and presentation standards for Eucalyptus Edge.

Every asset, Blueprint, material, widget, animation, arena, VFX system, and menu flow should follow these standards.

**If generated content conflicts with this guide, this guide is correct.**

---

## Project Identity

| | |
|---|---|
| Game | Eucalyptus Edge |
| Tagline | Cute Fighters. Serious Skills. |
| Platform | PC |
| Engine | Unreal Engine 5.8 |
| Development | Blueprint-only |
| Genre | 3D weapon-based arena fighter |
| Presentation target | Modern AAA-style clarity and polish |

Primary references:

- Soulcalibur — 3D weapon combat
- Monster Hunter World — living-world presentation
- Super Smash Bros — approachable multiplayer flow
- Tekken 8 — front-end polish and fighter presentation

**Not Mortal Kombat.**

---

## Canonical Active Roster

### Base roster

| Fighter | Role | Weapon | Primary color | Accent |
|---|---|---|---|---|
| Koda | Balanced fighter | Eucalyptus Crystal Staff | Forest Green | Gold, Brown |
| Wren | Mobile bruiser | Verdantia Boxing Gloves | Forest Green | Gold |
| Ripper | Aggressive brawler | Natural Bone Claws / claw gauntlets | Crimson Red | Dark Brown, Steel |
| Kiri | Precision duelist | Boomerang weapon | Royal Blue | Silver |
| Echo | Counter fighter | Ice Crystal Tonfas | Teal | Ice Blue |
| Banjo | Mobile blade fighter | Dual short blades | Emerald Green | Gold |
| Atlas | Reach specialist | Windspine Polearm | Royal Purple | Gold, Teal Crystal |

### Secret unlockable

| Fighter | Role | Weapon | Primary color | Accent |
|---|---|---|---|---|
| Sonia | Agile duelist | Twin Crescent Chakrams | Orange | Gold, White fur |

Sonia is a secret unlockable fighter in the base game and also acts as a teaser for the future regional DLC direction. She should not appear as a normal unlocked roster slot at first launch.

Roster exclusions:

- Mako is permanently removed.
- Bindi is cut.
- Bramble and Tazra are archived.

Do not reintroduce removed characters because an old document or folder still references them.

---

## Visual Philosophy

Verdantia should feel:

- magical
- alive
- hopeful
- ancient
- colorful
- family-friendly
- mystical
- Australian-inspired

Never:

- horror
- grimdark
- military
- modern sci-fi
- zombie-themed
- bloody or graphic
- visually muddy
- dominated by crushed blacks

The player should feel as though they entered a living magical Australian national park.

---

## Color Language

### Verdantia

- Forest Green
- Eucalyptus Green
- Emerald
- Crystal Blue
- Sky Blue
- River Blue
- Teal
- Warm Brown
- Moss
- Sandstone
- Brushed Gold
- Bronze

### Edge Energy

- Bright Cyan
- Soft Turquoise
- white-hot center accents used sparingly

### The Blight

- Purple
- Magenta
- Black Crystal
- corrupted smoke

Never overuse purple outside Blight content.

---

## Character Design Rules

Every active fighter must have:

- a readable silhouette
- a unique weapon silhouette
- a fixed primary color identity
- large expressive eyes
- five-fingered hands
- stylized proportions
- a unique idle pose
- a unique combat stance
- a unique movement style
- a unique victory pose
- a unique defeat reaction

No random palette changes.  
No duplicate fighting styles.  
No generic copied animations as final content.

---

## Weapon Rules

Weapons should feel handcrafted from Verdantia materials:

- wood
- natural fibers
- crystal
- bronze
- brushed gold
- carved stone
- bone where appropriate to the fighter

Never use:

- plastic
- military hardware
- modern firearms
- generic laser weapons
- mass-produced sci-fi styling

---

## Front-End Flow

The front end must be streamlined and controller-first.

Only three major full-screen states:

```text
Main Menu
Character Select
Mode Select
```

Canonical flow:

```text
Main Menu
→ Play
→ Dynamic Character Select
→ Mode Select
→ Arena Select popup
→ Match
```

Do not add unnecessary full-screen menu pages when an overlay, modal, drawer, or popup is clearer.

---

## Main Menu

The Main Menu should be visually simple:

```text
Play
Lore
Options
Credits
Exit
```

Do not include:

- a separate Characters button
- Local Versus as a Main Menu button
- Training as a Main Menu button
- a Character Select popup pretending to be the final Character Select experience

Main Menu presentation may use:

- animated or video background
- subtle dark gradient for readability
- animated logo
- carved wood button column
- sliding Lore, Options, and Credits panels
- quit-confirmation modal
- 20-second idle showcase behavior when practical

The current Main Menu systems should be extended rather than rebuilt without cause.

---

## Dynamic Character Select — Canon

Character Select is a major cinematic presentation screen.

The defining behavior:

> Highlighting a fighter glides the camera through Verdantia to the physical location where that fighter is waiting.

It must not be reduced to:

- a popup over the Main Menu
- a static portrait grid with no world response
- one stationary preview mannequin that swaps meshes
- a sequence of hard cuts with no sense of place

### Showcase behavior

Each roster entry has an in-world showcase point with:

- character actor or placeholder
- camera actor or camera target
- idle loop
- attention response
- confirm animation
- environment identity matching the fighter

Examples:

- Koda — training grove or eucalyptus sanctuary
- Wren — elevated boxing/training platform
- Ripper — rough woodland combat pit
- Kiri — lookout perch or wind platform
- Echo — crystal-water shrine
- Banjo — upper canopy hideout
- Atlas — windswept overlook
- Sonia — hidden tiger sanctuary or secret chamber, locked until her unlock condition is met

### Camera

Character Select camera movement should be:

- slow-cinematic in presentation
- responsive during navigation
- smooth and eased
- approximately 0.6–1.0 seconds for normal highlight transitions
- never shaky
- never disorienting
- capable of interrupting or retargeting cleanly if the player navigates quickly

The camera should make the roster feel embedded in one connected living world.

### Information shown

For the highlighted fighter:

- name
- role/fighting style
- weapon
- signature color
- lock/unlock state
- secret/hidden state
- Player 1 or Player 2 focus
- confirmation state

Keep the information readable and avoid overloading the screen with statistics during Phase 1.

---

## Local Multiplayer Selection

- Player 1 is active by default.
- Player 2 joins with Start/Menu on a second controller.
- Display `Press Start to Join`.
- Each player has independent navigation and confirmation.
- Focus borders and ready states must be unmistakable.
- One device must not accidentally control both players.
- Duplicate fighter selection is a configurable rule.
- Controller support is the priority.
- Mouse support may be available for Player 1.

Once all active players confirm, Continue becomes available and opens Mode Select.

---

## Mode Select

Mode Select appears only after character confirmation.

Phase 1 entries:

```text
Training
Versus CPU
Local Versus
Online Battle
```

Online Battle may be visible but disabled until networking exists.

Arena selection should appear as a popup/overlay instead of a fourth major full-screen front-end screen.

---

## UI Style

Target:

- minimal
- elegant
- animated
- readable
- controller-friendly
- mouse-friendly
- AAA-inspired without unnecessary complexity

Buttons:

- carved wood
- bronze trim
- leaf motifs
- crystal/Edge glow
- 1.05 scale on hover/focus
- subtle pressed depression
- clear disabled state
- visible controller focus

Never use default Unreal button styling in final-facing UI.

---

## Typography

- Verdantia Display: Cinzel
- Edge Sans: Inter
- high contrast
- readable at television distance
- no novelty fonts for body text

Use display type sparingly for headings and fighter names.

---

## Iconography

Icons should be:

- rounded
- friendly
- readable
- nature-inspired

Preferred motifs:

- leaf
- crystal
- wind
- wood
- paw/footprint where appropriate
- weapon silhouette

Avoid sharp military iconography.

---

## Arena Style

Every arena should contain:

- foreground
- midground
- background
- verticality
- ring-out logic
- ambient motion
- environmental storytelling
- readable combat floor
- silhouettes that do not obscure fighters

The current canonical arena roster contains eight arenas.

### Eucalyptus Summit

- ancient mountain sanctuary
- green, gold, stone, wood
- waterfalls, bridges, banners, lanterns, eucalyptus trees, wind, birds

### Crystal Caverns

- underground crystal shrine
- blue, purple, stone, crystal
- fog, glow, reflections, lanterns, bridges

### Bamboo Harbor

- peaceful riverside village
- boats, bamboo, docks, lanterns, lily pads, water

### Frostpine Ridge

- frozen mountain pass
- snow, ice, wind, ancient ruins

### Sunbaked Outback

- sun-scorched Australian-inspired badlands
- warm sandstone, ochre, red earth, dry grass, weathered wood
- heat shimmer, dust, distant mesas, harsh sunlight
- readable silhouettes and strong contrast despite the warm palette

**Do not use the obsolete names `Red Dune Outpost` or `Sunbreak Outback`.**

### Moonlit Rainforest

- dense magical rainforest
- fireflies, fog, moonlight, vines, water
- night lighting must remain readable

### Edge Festival Colosseum

- Verdantia championship arena
- celebration, honor, crowd energy, banners, lanterns, magical spectacle

### Blightroot Hollow

- corrupted woodland hollow built around enormous twisted roots
- dark bark, sickly vegetation, purple crystal veins, black smoke, Blight spores
- family-friendly danger rather than horror
- purple and magenta must remain localized to Blight corruption
- the combat floor must remain clearly readable against the corruption

Arena canon and implementation state are separate. Missing UE maps or unfinished meshes do not remove an arena from canon.

---

## Lighting

- warm sunlight
- soft bounce
- readable shadows
- neutral daylight where appropriate
- controlled Blight contrast
- no crushed blacks
- night scenes remain readable
- do not tint the entire world orange to simulate warmth

---

## Materials

Use Material Instances.

Master materials should support:

- wood
- stone
- crystal
- leaves
- water
- metal
- cloth
- Blight corruption

---

## First Combat Prototype Pair

The first playable combat validation should use:

```text
Wren vs. Ripper
Eucalyptus Summit
```

This is a production-order decision, not a story or protagonist declaration.

Why this pair comes first:

- Wren's boxing gloves are already part of her model.
- Ripper's claws are already part of his model.
- Neither fighter must wait for separate weapon modeling or socket attachment.
- Their contrasting styles provide a useful early test:
  - Wren: mobile bruiser, movement, pressure, boxing range
  - Ripper: aggressive brawler, close-range pressure, spin-based personality

The first test must still preserve their canonical colors, silhouettes, and personalities.

---

## First Combat Slice

The first combat showcase is:

```text
Wren vs. Ripper
Eucalyptus Summit
```

This pairing is canonical for the first implementation test because both characters already have their weapons integrated into their models.

The first slice should emphasize:
- Wren's mobile boxing pressure
- Ripper's aggressive claw offense
- clear silhouette contrast
- readable hit reactions
- ring-out potential
- controller responsiveness
- family-friendly impact without gore

---

## Combat Feel

Combat should be:

- responsive
- weighty
- skill-based
- readable
- expressive
- timing-focused

Never floaty.  
Never mindless button-mashing.  
Reward spacing, defense, parries, dodges, counters, and character knowledge.

---

## Gameplay Camera

| Context | Behavior |
|---|---|
| Combat | Smooth 3D arena framing with lock-on support |
| Character Select | Cinematic world travel between showcase points |
| Main Menu | Subtle drift or video presentation |
| Arena Intro | Short cinematic flythrough |
| Victory | Hero-focused pose |
| Defeat | Readable, respectful, family-friendly |

Avoid excessive camera shake.

---

## Animation Philosophy

Every fighter should eventually have unique:

- idle
- walk
- run
- combat stance
- light attack
- medium attack
- heavy attack
- block
- dodge
- counter/parry response
- Edge Energy ultimate
- victory
- defeat

Temporary retargeted animations may be used during prototyping, but they are not the final identity.

---

## VFX

### Edge Energy

- cyan
- turquoise
- bright readable core
- nature-energy motion

### Nature

- leaves
- wind
- pollen
- fireflies
- water mist

### Blight

- purple crystal
- magenta veins
- black smoke
- corruption growth

No realistic gore or military explosions.

---

## Audio

- wind
- birds
- waterfalls
- wood impacts
- crystal impacts
- heroic orchestral music
- Australian-inspired instruments where appropriate
- clear UI focus and confirm sounds

---

## Performance

- 60 FPS minimum
- Lumen where appropriate
- Nanite where appropriate
- Virtual Shadow Maps
- efficient Blueprint architecture
- minimal Tick usage
- data-driven systems
- interruptible camera transitions
- no unnecessary duplicate full-screen widgets

---

## Quality Gate

Before implementing any feature, ask:

1. Does it feel like a modern polished fighting game?
2. Does it make Verdantia feel alive?
3. Is it readable with a controller from a normal television distance?
4. Does it preserve the family-friendly identity?
5. Does it follow the canonical roster and flow?
6. Is it data-driven enough to expand without rewriting everything?

If not, redesign before implementation.
