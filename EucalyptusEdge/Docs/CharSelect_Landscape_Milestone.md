# LV_CharacterSelect — Landscape Milestone (Stage 1)

Gated rebuild. **Landscape only** — no cameras/characters/foliage/water/UI/VFX until this passes and the user approves Stage 2.

Source pack: `C:\Users\Trevor\Downloads\EucalyptusEdge_LV_CharacterSelect_Heightmap_Pack\`
Target map: `/Game/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelect`

---

## Agent 2 — Heightmap Validation: **PASS**

| File | Spec | Result |
|---|---|---|
| `EE_LV_CharacterSelect_Heightmap_1009x1009.png` | 1009², 16-bit gray | ✅ 1009×1009, bitDepth 16, colorType 0 |
| `...1009x1009.r16` | 1009×1009×2 = 2,036,162 B, LE RAW16 | ✅ exact byte size |
| Height data | no clip / no banding | ✅ 1 px @0, 1 px @65535 (no clipping); smooth 16-bucket histogram (no banding); full range used |
| 9× `Mask_*_1009x1009.png` | 1009², 8-bit gray | ✅ all 1009×1009, bitDepth 8, colorType 0 |
| `..._PREVIEW.png` | markers | ✅ 7 origin markers, elevations sane (Echo darkest/lowest, Kiri light/high) |

**⚠ Z-scale finding.** Data spans the full 16-bit range. In UE a full-range heightmap at **Z-scale 100 → ~512 m of relief**, ~4.3× the metadata's designed `0–118 m`. To match the design (Kiri ≈99 m above low point), Z-scale should be **≈23–25**. Plan: import per README at Z=100, immediately measure Kiri/Koda height, drop Z-scale to ~25 if towering.

---

## Agent 3 — Landscape Plan

- **Source:** the 16-bit PNG (prefer over .r16; do not import both).
- **Resolution:** 1009×1009 → canonical UE size: **63 quads/section · 1 section/component · 16×16 = 256 components**. Valid, no resampling.
- **XY scale:** `50, 50` cm → 1008×50 = **504 m × 504 m**. ✅
- **Z scale:** start `100`, expect to reduce to **~25** after height check (see finding).
- **Origin:** place landscape so its **center = world (0,0,0)** (corner at −25200,−25200 cm). Region offsets in the metadata are "from landscape center," so this makes region world XY = metadata × 100 (e.g. Kiri (20,151) m → (2000,15100) cm).
- **Material:** assign `/Game/EE_ProjectFiles/CharacterSelect/Materials/MI_EE_VerdantiaLandscape` after import (property set — safe via MCP).
- **World Partition:** recommend **non-WP** for a fixed 504 m presentation space — avoids the distant-actor streaming/culling that plagued the old level. Confirm the new empty map's WP state in-editor.
- **Masks:** 8-bit biome/cliff/water weightmaps. Painting them requires landscape-paint tooling (not exposed via MCP) → treat as planning references + optional later paint layers; not required for milestone pass.

### Region targets (world XY cm from center; height above lowest)
| Fighter | X | Y | ~Height | Flat pad r |
|---|---|---|---|---|
| Koda | 0 | 2200 | 45 m | 10.4 m |
| Wren | 12600 | −1200 | 34 m | 11.1 m |
| Ripper | −7600 | −11200 | 29 m | 10.4 m |
| Kiri | 2000 | 15100 | 99 m | 9.1 m |
| Echo | −14500 | 500 | 14 m | 10.4 m |
| Banjo | −11100 | 11400 | 80 m | 9.1 m |
| Atlas | 3800 | −18700 | 83 m | 11.7 m |

---

## Import procedure (MCP has no landscape-import tool → manual, ~2 min)
1. Restart the editor if hung (launch with `-ModelContextProtocolPort=8765`).
2. Open `LV_CharacterSelect`; confirm it's the live map; Save.
3. Landscape Mode → Manage → **Import from File** → the 16-bit PNG.
4. Section size **63×63**, XY scale **50,50**, Z scale **100** (review), Location centered.
5. Create → Save.

## Post-import verification (I run via MCP once editor is responsive)
- Confirm **exactly one** Landscape actor; confirm empty map otherwise.
- Set `LandscapeMaterial` → `MI_EE_VerdantiaLandscape`.
- `trace_world` Z at each region XY vs. table above; adjust Z-scale if ~4× high.
- Screenshot overview + all 7 regions.
- Read Output Log + Message Log (Map Check) for warnings; record baseline/new/resolved.
- Save → reopen → re-check. Produce the required milestone report.

## Deferred (NOT in Stage 1)
Cameras, characters, showcase actors, pedestals, foliage, trees, grass, rocks, water, Niagara, PCG, splines, lighting polish, post-process, audio, UI, `WBP_CharacterSelect`, GameMode/selection/input logic.

---

# STAGE 1 EXECUTION RESULTS — **PASS (with documented pre-existing warnings)**

Executed on live map `/Game/EE_ProjectFiles/CharacterSelect/Level/LV_CharacterSelection` (renamed from LV_CharacterSelect; old map obsolete).

**Import blocker found + fixed:** the pack's `..._1009x1009.png` was not importable (Unreal rejected it). Rebuilt a bit-exact 16-bit grayscale PNG from the valid RAW16 → `EE_LV_CharacterSelect_Heightmap_1009x1009_FIXED.png` (0 differing pixels vs RAW16), which imported cleanly.

**Landscape config:** actor `Landscape2` (internal `Landscape_1`), exactly one. 1009×1009 · 63 quads/section · 1 sec/comp · 16×16 = 256 components · XY 50cm · **Z 23 (corrected from 100 — full-range data made Z100 = 512m)** · centered on world origin · **504.0×504.0 m, 0–117.8 m** · collision verified · material `MI_EE_VerdantiaLandscape` · appears non-WP (no streaming proxies).

**Region heights (traced vs spec, m):** Koda 44.9/45 · Wren 34.1/34 · Ripper 28.6/29 · Kiri 99.2/99 · Echo 14.3/14 · Banjo 80.2/80 · Atlas 83.2/83 — all within ~0.5 m.

**Warnings:** Map Check 0/0. One transient error set ("Landscape physical material failed to complete before saving", ×37) on the first post-material save → **resolved on re-save, no recurrence.** Pre-existing benign engine "landscape thumbnail material TShadowDepth" warnings at startup (not ours). Save→reopen verified: 1 landscape, correct dims, no lights.

**Assets:** reused `MI_EE_VerdantiaLandscape`. Created on disk (not Content): the FIXED heightmap PNG. No Content-Browser assets created; no duplicates. ⚠ Pre-existing dupes to clean later: earlier texture-import left `EE_LV_CharacterSelect_Heightmap_*` + 9 `Mask_*` Texture2D in `/CharacterSelect/Materials/` (unused by the landscape).

**Deferred (confirmed not done):** cameras, characters, showcases, foliage, water, Niagara, PCG, splines, UI/WBP, audio, lighting polish.

Screenshot: `Saved/Screenshots/Verdantia_CS/Landscape_vista_lit.png` (relief, temp light removed after).

**STOP — awaiting user approval for Stage 2.**
