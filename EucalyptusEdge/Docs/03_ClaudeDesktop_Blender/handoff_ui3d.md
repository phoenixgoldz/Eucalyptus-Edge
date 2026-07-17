# EUCALYPTUS EDGE — UI 5.0 "FORGED IN VERDANTIA" · 3D SESSION HANDOFF
**Target session:** Claude Desktop + Blender MCP (port 9876), UE 5.8 via Claude Code (unreal-mcp :55557)
**Suggested location:** `C:\Users\Trevor\Desktop\Eucalyptus-Edge\EucalyptusEdge\handoff_ui3d.md`
**Goal:** Rebuild the UI kit as real modeled objects → render → slice → UMG. Score target: 9–9.5/10.

---

## LIGHT RIG (must match the 2D kit so old/new assets can mix)
- Key: Sun, azimuth **47°**, elevation **46°** (direction ≈ (-0.62, -0.66, 0.72)), color **RGB 255/246/220**, strength 3.0
- Fill: Area light opposite side, 0.35 strength, cool-neutral
- World: black, film **Transparent ON**, Cycles, 256 samples + denoise
- Camera: **Orthographic**, facing -Y, one camera per asset collection; ortho scale = asset width

## PALETTE (locked)
| Material | Values |
|---|---|
| Wood base | #45311C → #5C432A, olive undertone blend 12% #40422A |
| Wood finish | Roughness 0.32, **Clearcoat 0.45** (oiled heirloom) |
| Gold | Base #CDA352, Metallic 1.0, Roughness 0.22; edge-wear via Pointiness→ColorRamp to #F2D482; recess oxidation #3A2C1A via AO node |
| Edge Crystal | Transmission 0.85, IOR 1.55, base #2AC878; emission from fracture texture #BEFFD2, strength 2–6 (animatable) |
| Carve glow | Emission #50EB91 strength 1.5 inside grooves |

## WORK ORDERS (priority order)
**WO-1 · Scene** — New `EE_UI_Forge.blend`. Metric units. One collection per asset. Shared light rig + per-asset ortho cam. Compositor: RGBA pass + **Emission-only view layer** (this becomes `*_Emissive.png` automatically).

**WO-2 · Victory Plaque (Tier 4, showpiece)** — Model the plank with the arched crest silhouette (ref: `T_UI_T4_VictoryPlaque_v2.png`). Bevel modifier 8mm on all outer edges (rounded plank). Boolean-cut the carve recesses (vines, veins, scribbly-gum) from curve objects with depth 4–6mm. Gold inlay: curves → bevel 6mm → embed 2mm proud of the wood. Crystal sockets: boolean 4mm recess + collar, shard meshes seated inside; **crest shard is split in two with a 3mm gap — emission plane in the crack**. Set the custom VICTORY wordmark (`T_Wordmark_Victory.png` as reference; model letters as 3mm gold inlay if time allows, else decal).

**WO-3 · Portrait Frame (Tier 3)** — Same treatment; vines as curve booleans grown per side (asymmetry), emblem socket top-center using the **Edge Crystal Emblem** silhouette (`T_Emblem_EdgeCrystal_512.png`).

**WO-4 · HUD bars (Tier 1)** — Keep quiet: rounded plank, single inlay ring, one engraved leaf (health), socketed shard cluster (edge). Model the fill channel as a true recess; render frame with the channel EMPTY (alpha).

**WO-5 · Buttons (Tier 2)** — One mesh, four material/light states via emission strength + fill tint variants; render all four from the same camera.

**WO-6 · Render + slice** — 4× target res per asset (e.g. plaque 5600×3040), PNG RGBA + emissive layer. Downscale in compositor or post to final sizes matching the current kit so UMG swaps are drop-in.

**WO-7 · UE import** — Texture Group UI, NoMipmaps. Replace v4 textures 1:1 (same names).

## LIVING-UI SPEC (Unreal side — Claude Code session)
Sprites ready in `ui_v45/`: `T_FX_Firefly.png`, `T_FX_Pollen.png`, `T_FX_LeafMote.png`.
1. **Crystal pulse** — UMG Image material: `Emissive` texture param × `(0.75 + 0.25 * sin(Time × 1.3))`. Apply to every `*_Emissive` overlay.
2. **Fireflies** — Niagara: spawn 0.15–0.3/s, life 5–8s, curl-noise drift, additive `T_FX_Firefly`, max 4 alive. Menu + character select only.
3. **Vine grow-and-settle** — On menu open, panner-driven mask reveals the carve-glow 0→1 over ~1.8s, then holds at 0.85.
4. **Pollen** — Character select only, 6–10 motes, very low opacity (0.15), slow vertical drift.
5. **Leaf sway** — Victory screen: 2–3 `T_FX_LeafMote` sprites, gentle rotation ±6°, 4s loop.
Rule: **subtle**. If a playtester consciously notices any single effect, halve it.

## EMBLEM USAGE RULES (franchise mark)
- Full-color render: crest positions, splash screens, plaque crowns.
- **Mono stamp** (`_Mono.png`): watermarks, segment ticks, favicons, loading spinner (rotate the glow, not the mark).
- Never stretch; never recolor outside gold/emerald/cream; minimum size 24px; the leaf void must always read.

## CANON REMINDERS FOR THIS SESSION
- Sunbaked Outback (not Red Dune Outpost) in any regenerated docs. Mako/Bindi/Bramble/Tazra do not appear anywhere.
- Violet = Blighted/locked only. Disabled/unavailable = desaturated, never violet.
- No characters in UI chrome; fighter names/labels are UMG text (localization).
