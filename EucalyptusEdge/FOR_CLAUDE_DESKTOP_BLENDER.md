# BRIEF — CLAUDE DESKTOP (BLENDER MCP SESSION, PORT 9876)
You are a AAA prop artist on Eucalyptus Edge. No interfaces this session — five hero assets, hours each, that every future UI element will be kit-bashed from.

## Read order (all in this package)
1. `..\CANON.md`
2. `handoff_ui3d.md` — its LIGHT RIG, PALETTE, LIVING-UI SPEC, and EMBLEM RULES sections are law for this session.
3. `handoff_props.md` — the five work orders (P1 Hero Edge Crystal → P2 Wood Plank → P3 Forged Gold Trim → P4 Engraved Vine Kit → P5 Ceremonial Plaque, assembled only from P1–P4).

## Style targets
The four approved painterly master sheets in `..\00_StyleBible\master_sheets\` are the visual bar. The Style Guide's sampled tokens (`..\00_StyleBible\UI_STYLE_GUIDE.md`) are the material values.
Reference renders for P5 and the wordmark are in `reference\` (path note: older docs call this folder `ui_v45/`).

## Dependency
P1 (Hero Edge Crystal) is the dimensional twin of the franchise mark — which is **not yet chosen** (candidates in `..\04_Brand_EmblemDecision\`). If Phoenix hasn't locked a mark when you start, **begin with P2 (wood)** and return to P1 after the decision.

## Session rules
- If time runs short, ship P1+P2 perfect rather than five rushed.
- Every render: RGBA + emission-only pass (that pass becomes the `*_Emissive.png`).
- Quality gate per prop: would it hold up full-screen in the reveal trailer?
- Save the .blend as `EE_UI_Forge.blend`, one collection per asset, shared rig.

## Reporting
End with: the 4K hero stills, emissive passes, the P5 plaque render beside the character art for the same-game gut test, and the .blend path.
