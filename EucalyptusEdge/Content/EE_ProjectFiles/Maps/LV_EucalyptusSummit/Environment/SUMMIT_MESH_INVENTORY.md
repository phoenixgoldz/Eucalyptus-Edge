# Eucalyptus Summit — Static Mesh Inventory

Generated **2026-07-21** from the live `LV_EucalyptusSummit` level.
All **95** StaticMeshActors surveyed · **14** distinct meshes · **0** survey errors.

---

## Full inventory

| Mesh | Count | Source path | Role |
|---|---:|---|---|
| **(NONE — no mesh assigned)** | **24** | — | ⚠️ empty actors |
| `SM_MWAM_StoneC` | 10 | `/Game/MWLandscapeAutoMaterial/Meshes/Cover/` | scattered boulder |
| `SM_MWAM_StoneB` | 10 | `/Game/MWLandscapeAutoMaterial/Meshes/Cover/` | scattered boulder |
| `SM_MWAM_StoneD` | 9 | `/Game/MWLandscapeAutoMaterial/Meshes/Cover/` | scattered boulder |
| `SM_MWAM_StoneA` | 9 | `/Game/MWLandscapeAutoMaterial/Meshes/Cover/` | scattered boulder |
| `Fence01` | 14 | ⚠️ `/PCG/GraphTemplates/Meshes/` | arena railings |
| `Stone_Brazier` | 6 | ⚠️ `/Game/EE_ProjectFiles/Maps/LV_FrostpineRidge/` | braziers / lanterns |
| `SM_MWAM_GrassA` | 2 | `/Game/MWLandscapeAutoMaterial/Meshes/Plants/` | grass prop |
| `SM_MWAM_GrassB` | 2 | `/Game/MWLandscapeAutoMaterial/Meshes/Plants/` | grass prop |
| `SM_MWAM_GrassC` | 2 | `/Game/MWLandscapeAutoMaterial/Meshes/Plants/` | grass prop |
| `SM_MWAM_GrassD` | 2 | `/Game/MWLandscapeAutoMaterial/Meshes/Plants/` | grass prop |
| `Right_Festival_Banner` | 2 | ⚠️ `/Game/EE_ProjectFiles/Props/Festival/` | festival banner |
| `Wooden_Bridge` | 2 | ⚠️ `/Game/EE_ProjectFiles/Maps/LV_FrostpineRidge/` | side path |
| **`Main_Platform`** | **1** | `/Game/EE_ProjectFiles/Maps/LV_EucalyptusSummit/Environment/` | ✅ **the arena floor** |

**Totals:** 46 MWAM scatter props · 25 arena-structure meshes · 24 empty actors.

---

## Arena core — matches the concept art

The built arena genuinely exists and maps cleanly onto the concept:

| Concept element | Asset | Count |
|---|---|---|
| "Main circular platform" | `Main_Platform` | 1 |
| "Breakable railings" / ring-out edge | `Fence01` | 14 |
| "Two side paths" | `Wooden_Bridge` | 2 |
| "Hanging lanterns (breakable)" | `Stone_Brazier` | 6 |
| "Festival banners" | `Right_Festival_Banner` | 2 |

---

## Issues

1. **24 StaticMeshActors have no mesh assigned** — 25% of all static mesh actors are empty. Dead or placeholder actors that should be identified and removed.

2. **`Fence01` comes from `/PCG/GraphTemplates/`** — an *engine plugin template*, not project art. It is not owned by the project, will not be versioned with it, and could change or vanish on an engine update. Should be replaced with a project-owned railing asset.

3. **`Stone_Brazier` and `Wooden_Bridge` are borrowed from `LV_FrostpineRidge`.** Cross-arena dependency — editing or moving Frostpine's props will silently alter Summit.

4. **`Right_Festival_Banner` is duplicated** in two locations:
   - `/Game/EE_ProjectFiles/Props/Festival/Right_Festival_Banner`
   - `/Game/EE_ProjectFiles/Maps/Right_Festival_Banner`

5. **No `Left_Festival_Banner`** — only the Right variant exists. The concept shows banners on both sides.

6. **No eucalyptus tree meshes.** The concept frames the arena with two giant eucalyptus trees — the single strongest compositional element — and none are present in the level.

7. **46 MWAM stone/grass props are scattered across the plateau surface.** Their XY layout was authored for the previous flat landscape; they now sit on the walkable arena floor.

---

## Context

All **104** arena actors (95 StaticMeshActor + 6 NiagaraActor + 2 PlayerStart + 1 `BP_EE_MatchCamera_C`) were raised **+171.08 m** on 2026-07-21. They had been buried inside the mountain after the terrain rebuild — positioned for a landscape whose ground plane was z = 0.

**Terrain:** `CinematicSteep` heightmap · Z scale 75 · plateau **171.08 m** at **50.7 m** radius · 504 × 504 m · 1 parent + 64 WP streaming proxies.

**Landscape material:** `MI_EE_VerdantiaLandscape` on parent + all 64 proxies.
