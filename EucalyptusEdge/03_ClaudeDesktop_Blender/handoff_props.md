# EUCALYPTUS EDGE — "FORGED IN VERDANTIA" · AAA PROP ARTIST SESSION
**Supersedes** WO-2…WO-5 of `handoff_ui3d.md`. (Its LIGHT RIG, PALETTE, LIVING-UI SPEC, and EMBLEM RULES sections remain law.)
**Session:** Claude Desktop + Blender MCP (:9876). **Mission statement, verbatim:**
> Stop designing interfaces. Become a AAA prop artist. Build five incredible assets. Reuse them everywhere.

**Law of assembly:** After this session, no UI element is ever drawn again. Every button, bar, frame, and plaque is *kit-bashed* from these five heroes. Quality over quantity — five assets, hours each, not fifty in an afternoon.

---

## P1 · HERO EDGE CRYSTAL (the franchise object — spend the most time here)
*Depends on the mark decision (candidate A / B / C) — the 3D crystal is the dimensional twin of the chosen flat mark.*
- Model: low-poly faceted body matching the chosen silhouette exactly in front ortho view; sharp 0.5mm bevels on every facet edge.
- Interior: 2–3 fracture planes inside the mesh with emission material (#BEFFD2, strength animatable 2→6); Volume Absorption (#0E4A2C, density 4) for depth.
- Shader: Transmission 0.9, IOR 1.55, Roughness 0.04, slight green tint #2AC878; rim via Fresnel → emission 0.3.
- Deliver: 4K hero still (¾ view), front-ortho render matching the flat mark, 360° turntable (48 frames), emissive-only pass, plus a 512px "prompt-icon" render.
- Quality gate: would this hold up full-screen in the reveal trailer? If not, keep sculpting.

## P2 · HERO CARVED EUCALYPTUS PLANK (one beautiful piece of wood)
- 30×20×2.5cm plank, 6mm edge bevel, corners eased by hand (asymmetric).
- Grain: low-contrast procedural rings (Wave + Musgrave distortion, scale tuned so 2–3 cathedral arcs cross the face) driving 0.4mm displacement; 2–3 hand-sculpted scribbly-gum trails, 0.3mm deep.
- Shader: base #45311C→#5C432A, 12% olive #40422A mix, Roughness 0.32, **Clearcoat 0.45** (oiled heirloom finish).
- Deliver: 4K top-down (this becomes the master tileable), 4K beauty angle, close-up macro of one scribbly trail.

## P3 · HERO FORGED GOLD TRIM (one 25cm segment)
- Profile: half-round 8mm bar, ends finished with a simple finial.
- Forge it: sculpt hammer dents (Draw brush, 2–4mm dia, irregular), 3–4 hairline scratches, one engraved border line along the length.
- Shader: #CDA352, Metallic 1, Roughness 0.22; Pointiness→ramp for worn bright edges #F2D482; AO→ramp for recess oxidation #3A2C1A.
- Deliver: 4K straight-on, 4K raking-light (shows the hammering), 90° corner variant.

## P4 · HERO ENGRAVED VINE KIT (six reusable pieces)
Curve-based, two variants each — (a) *carved recess* boolean cutter, (b) *raised gold* inlay:
1. Straight run (tileable) · 2. 90° corner turn · 3. Terminal with leaf bud · 4. Branch fork · 5. Medallion curl · 6. Three-leaf cluster.
- Thickness tapers 100%→45% along each piece; every leaf slightly different (no duplicates).
- Deliver: each piece rendered on a P2 wood swatch, both variants, plus the .blend collection for kit-bashing.

## P5 · HERO CEREMONIAL PLAQUE (the proof)
- Assembled **only** from P1–P4: P2 planks shaped to the arched crest silhouette (ref `T_UI_T4_VictoryPlaque_v2.png`), P3 trim as the inlay, P4 vines as the wrap and energy veins, P1 crystal (broken variant: duplicate, split, 3mm gap, emission plane in the crack) at the crest.
- Deliver: 5600×3040 RGBA render + emissive pass → downscale to 1400×760 drop-in replacement.
- Quality gate: put it beside the character concept art. If it looks like a different game, iterate P1–P4 — not the plaque.

## SESSION ORDER & TIME
P1 (longest) → P2 → P3 → P4 → P5. If the session runs short, ship P1+P2 perfect rather than all five rushed.

## AFTER THE HEROES
Kit-bash sprint (can be a follow-up session): portrait frame, HUD bars, button set — each assembled in under an hour from the library, rendered with the same rig, exported with emissive passes, imported to UE (Texture Group UI, NoMipmaps), living-UI spec applied.
