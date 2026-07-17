# EUCALYPTUS EDGE — UI PACKAGE v1.1 · START HERE
**v1.1 changelog:** added PROJECT_AUDIT.md — Claude Code Session 1 is inspection only; build starts Session 2.
One package, four destinations. Suggested unzip location:
`C:\Users\Trevor\Desktop\Eucalyptus-Edge\UIPackage\`

## The five steps
1. **Unzip** this folder to the path above.
2. **Import art to Unreal:** copy the *contents* of `01_ImportToUnreal\` into your UE project at `Content\UI\` (or drag-import in the editor). Import settings for every texture: Texture Group **UI**, Mip Gen **NoMipmaps**, Compression **UserInterface2D**. Details: `01_ImportToUnreal\README_UE_IMPORT.md`.
3. **Claude Code (UE terminal):** open Claude Code inside the UE project and point it at `02_ClaudeCode_UE5\FOR_CLAUDE_CODE_UE5.md`. Session 1 runs `PROJECT_AUDIT.md` (inspection only, dashboard + three questions); Session 2 builds UI-M2 per the same brief.
4. **Claude Desktop (Blender, MCP :9876):** point it at `03_ClaudeDesktop_Blender\FOR_CLAUDE_DESKTOP_BLENDER.md`. That is the AAA prop-artist session (five hero assets).
5. **Emblem decision (whenever you're ready):** `04_Brand_EmblemDecision\` holds both candidate rounds. The hero crystal (Blender P1) is modeled from whichever mark you lock.

## Folder map
- `CANON.md` — every lock agreed in this chat. Both Claudes read it first.
- `00_StyleBible\` — UI Principles (why), Style Guide (how, values sampled from the masters), and the four approved master sheets (source of truth).
- `01_ImportToUnreal\` — the Component Library v1.0 (14 components) + FX sprites for Niagara. This is the only folder that goes into the UE project.
- `02_ClaudeCode_UE5\` — brief, Character Select build spec, milestone tracker, layout mock.
- `03_ClaudeDesktop_Blender\` — brief, prop work orders, light-rig/material law, reference renders.
- `04_Brand_EmblemDecision\` — eight candidate marks across two rounds, with size-ladder sheets.
