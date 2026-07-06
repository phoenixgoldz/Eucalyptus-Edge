# Eucalyptus Edge — Style Guide

**Version:** 1.0
**Status:** Canon
**Last Updated:** July 2026

---

## Purpose

This document defines the permanent visual, artistic, UI, combat, and presentation standards for Eucalyptus Edge.

Every asset, Blueprint, material, UI widget, animation, arena, VFX, and gameplay system should follow these standards.

**If there is a conflict between generated content and this guide, THIS GUIDE IS CORRECT.**

---

## Project Identity

| | |
|---|---|
| **Game** | Eucalyptus Edge |
| **Tagline** | Cute Fighters. Serious Skills. |
| **Platform** | PC |
| **Engine** | Unreal Engine 5.8 |
| **Development Style** | Blueprint Only |
| **Genre** | 3D Weapon-Based Arena Fighter |

**Primary Inspiration:**
- Soulcalibur
- Monster Hunter World (presentation quality)
- Super Smash Bros (clean menu flow)
- Tekken 8 (UI polish)

**NOT Mortal Kombat.**

---

## Visual Philosophy

Verdantia should feel:

- Magical
- Alive
- Hopeful
- Ancient
- Family Friendly
- Colorful
- Mystical
- Australian Inspired

Never:

- Dark fantasy
- Horror
- Hyper realistic
- Military
- Sci-fi
- Blood or gore
- Zombie aesthetic

**Players should feel like they entered a living magical national park.**

---

## Verdantia Color Palette

**Primary Greens**
- Forest Green
- Eucalyptus Green
- Emerald

**Primary Blues**
- Crystal Blue
- Sky Blue
- River Blue
- Teal

**Earth Colors**
- Warm Brown
- Tree Bark
- Moss
- Sandstone

**Metals**
- Brushed Gold
- Bronze

**Magic (Edge Energy)**
- Bright Cyan
- Soft Turquoise

**Blight**
- Purple
- Magenta
- Black Crystal

> Never overuse purple outside Blight content.

---

## Character Identity

Every character MUST remain recognizable by:

- silhouette
- weapon
- primary color
- animation style

**Never randomly change colors.**

| Character | Role | Weapon | Primary Color | Accent | Combat / Personality |
|---|---|---|---|---|---|
| **Koda** | Balanced Fighter | Eucalyptus Crystal Staff | Forest Green | Gold, Brown | Heroic, reliable, calm |
| **Wren** | Mobile Bruiser | Verdantia Boxing Gloves | Forest Green | Gold | Fast movement, heavy punches |
| **Ripper** | Aggressive Brawler | Natural Bone Claws | Crimson Red | Dark Brown, Steel | Wild, explosive |
| **Kiri** | Precision Duelist | Boomerang Blaster | Royal Blue | Silver | Accurate, technical |
| **Echo** | Counter Fighter | Crystal Tonfas | Teal | Ice Blue | Defensive, precise |
| **Banjo** | — | Vine Whip | Emerald Green | Gold | Mobility, spacing |
| **Atlas** | — | Windspine Polearm | Royal Purple | Gold, Teal Crystal | Reach, wind |
| **Bindi** | — | — | Cream | Green, Gold | — |
| **Bramble** | Heavy Defender | — | Earth Brown | Moss Green | — |
| **Mako** | — | — | Turquoise | White, Gold | Agile |
| **Tazra** | Blight Character | — | Dark Purple | Magenta, Black | — |

---

## Character Design Rules

Every character:

- Five fingers
- Large expressive eyes
- Stylized proportions
- Readable silhouette
- Unique weapon
- Unique idle pose
- Unique color identity

**No duplicate fighting styles.**

---

## Weapon Rules

Every weapon must feel handcrafted.

**Materials:**
- Wood
- Crystal
- Bronze
- Gold
- Natural fibers

**Never:**
- Plastic
- Modern metal
- Military weapons
- Laser weapons
- Guns

---

## UI Style

**Target Quality:** AAA
**Primary Inspiration:** Monster Hunter World

**Goals:**
- Minimal
- Elegant
- Animated
- Readable
- Controller Friendly
- Mouse Friendly

---

## Main Menu

**Single `WBP_MainMenu`. Do NOT create many fullscreen widgets.**

Use:

- Video Background
- Dark Gradient
- Animated Logo
- Button Column
- Sliding Panels
- Modal Popups

Play button transitions into Character Select.

---

## Buttons

**Style:**
- Carved wood
- Bronze trim
- Leaf motifs
- Crystal glow

**Hover:**
- Scale 1.05x
- Soft glow
- Edge Energy pulse

**Pressed:**
- Slight depress animation

**Controller Focus:**
- Glow
- Border animation

**Never use default Unreal buttons.**

---

## Typography

- Elegant fantasy
- Readable
- High contrast
- No novelty fonts

**Temporary:** Roboto or approved placeholder.
**Future:** Verdantia custom font.

---

## Iconography

- Rounded
- Friendly
- Readable

**Motifs:** Leaf, Crystal, Wind, Wood, Nature

**No sharp military icons.**

---

## Arena Style

Every arena should tell a story. Never feel empty.

Always include:

- Foreground
- Midground
- Background
- Verticality
- Ring-out locations
- Ambient VFX
- Moving foliage

### Eucalyptus Summit
- **Theme:** Ancient mountain sanctuary
- **Palette:** Greens, Gold, Stone, Wood
- **Features:** Waterfalls, bridges, banners, lanterns, eucalyptus trees, wind, birds

### Crystal Caverns
- **Theme:** Underground crystal shrine
- **Palette:** Blue, Purple, Stone, Crystal
- **Features:** Fog, glow, crystal reflections, lanterns, bridges

### Bamboo Harbor
- **Theme:** Peaceful riverside village
- **Features:** Boats, bamboo, lanterns, docks, lily pads, water

### Frostpine Ridge
- **Theme:** Frozen mountain pass
- **Features:** Snow, ice, wind, ancient ruins

### Moonlit Rainforest
- **Theme:** Dense magical forest
- **Features:** Fireflies, fog, moonlight, vines, water

### Edge Festival
- **Theme:** Verdantia championship arena
- **Mood:** Celebration, honor, magic

---

## Lighting

- Warm sunlight
- Soft bounce lighting
- Readable shadows
- **Never crushed blacks**
- Night scenes should still be readable

---

## Materials

**Always use Material Instances.**

Master Materials should drive:

- Wood
- Stone
- Crystal
- Leaves
- Water
- Metal
- Cloth

---

## Combat Feel

Combat should feel:

- Responsive
- Weighty
- Skill Based
- Readable

**Never floaty. No button mashing. Reward timing.**

---

## Camera Rules

| Context | Camera behavior |
|---|---|
| **Gameplay** | 3D arena, smooth, never shaky |
| **Character Select** | Slow cinematic movement |
| **Main Menu** | Subtle camera drift |
| **Arena Intro** | Cinematic flythrough |
| **Victory** | Hero pose |

---

## Animation Philosophy

Every character:

- Unique idle
- Unique walk
- Unique run
- Unique combat stance
- Unique victory
- Unique defeat

**Weapons should feel heavy. No animation should look copied.**

---

## VFX Style

**Edge Energy:**
- Bright Cyan
- Soft Turquoise

**Nature particles:**
- Leaves
- Wind
- Magic pollen

**Blight:**
- Purple crystals
- Black smoke
- Corruption

**No realistic explosions.**

---

## Audio Style

- Nature ambience: wind, birds, waterfalls
- Wood impacts
- Crystal impacts
- Heroic orchestral themes
- Australian-inspired instrumentation where appropriate

---

## Performance Goals

- 60 FPS minimum
- Nanite enabled where appropriate
- Lumen
- Virtual Shadow Maps
- Efficient Blueprint architecture
- Minimal Tick usage

---

## Quality Standard

Every feature should feel like it belongs in a modern AAA fighting game.

Before implementing any feature ask:

1. Does this feel like Monster Hunter World's presentation quality?
2. Would this fit naturally into Verdantia?
3. Does it preserve the game's family-friendly identity?

**If not, redesign it before implementation.**

---

*END OF STYLE GUIDE*
