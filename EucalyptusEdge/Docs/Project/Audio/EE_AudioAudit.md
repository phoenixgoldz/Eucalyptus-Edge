# EE_AudioAudit.md — project audio audit (Agent 1, read-only)

**2026-07-19. Filesystem/git audit — no editor bridge in this session, so binary `.uasset` internals (Blueprint graphs, MetaSound graphs, Cue nodes) were not opened; the in-editor audit still owes a Reference-Viewer confirmation.**

## 1. Existing audio framework — CANONICAL, extend do not duplicate
At `/Game/EE_ProjectFiles/Audio/` (exactly 5 assets):
| Asset | Type | Role |
| --- | --- | --- |
| `EE_Master` | SoundClass | master bus parent |
| `EE_Music` | SoundClass | **all music routes here** |
| `EE_SFX` | SoundClass | SFX |
| `EE_MusicSubmix` | Submix | music submix (volume target) |
| `EE_SFXSubmix` | Submix | sfx submix |

**Volume system (do not rebuild):** `BP_EE_GameInstance.ApplyAudioSettings` → `SetSubmixOutputVolume` on engine `MasterSubmixDefault` + `EE_MusicSubmix` + `EE_SFXSubmix`, read from `BP_EE_SettingsSave` (Master/Music/SFX). Called on Init and Options→Apply. SESSION_LOG: *"Submix system is CANONICAL"* (a parallel `Framework/Audio/` set was built then deleted — do not resurrect it).

## 2. What does NOT exist yet (new work for the build)
- **No** music manager / director, subsystem, or persistent music actor.
- **No** music enums (`E_EE_MusicState`, `E_EE_CombatIntensity`), struct, or DataTable.
- **No** MetaSounds anywhere in the project (0 `MS_*`/`MetaSound` assets).
- **No** `SG_EE_Music` SoundClass-group / stinger class split (only the 3 SoundClasses above).

So the requested `BP_EE_MusicDirector` / `E_EE_*` / `ST_/DT_` / `MS_EE_*` are all **net-new** (build in editor — Stage 2/3).

## 3. Current placeholder music actually in use (the real replacement targets)
`Ambient_Music_v1` is **unused** (see `EE_AmbientMusicV1_Referencers.md`). The music the game *does* play — the placeholders the new system should supersede — is elsewhere and **is** referenced:
| Placeholder | Where used | Pack |
| --- | --- | --- |
| `WAV_Menu_Loop` | `WBP_MainMenu` Construct | PathOfAdventure |
| `CUE_Village_Loop` | Character Select widget | PathOfAdventure |
| `CUE_Battle_Loop` | `BP_EE_VersusGameMode` BeginPlay | PathOfAdventure |
| `Trailer_Horns_of_War_Cue` | `WBP_EE_Results` (victory) | FreeAtmosGameMusic |

> These are the **valid** things the new MusicDirector should take over. `Ambient_Music_v1` is a separate, orphaned pack that just needs deleting once the system is in.

## 4. Reusable, project-owned audio SOURCES (for Stage 3 original prototype)
Audio-bearing packs present in `Content/`:
| Pack | Use as source | Note |
| --- | --- | --- |
| `FreeModularMagicSFX` | **tonal / shimmer / magic one-shots** (Edge-Energy layer, celeste-like textures) | earmarked "Edge Energy SFX source" in PROJECT_STATE |
| `SmallSoundKit` | UI tonal one-shots (stingers, hits) | already used for hover/click |
| `FootstepsMiniPack`, `A_Surface_Footstep` | percussion/impact one-shots | footstep libraries |
| `PathOfAdventure`, `FreeAtmosGameMusic` | ⚠ **finished marketplace music** | usable as scratch only — **not** as the original identity (goal is original, non-marketplace-dependent) |
| MetaSound oscillators/synthesis | tier-3 tonal layers | for original pads/drones per the brief |

**Licensing caveat (STOP-condition relevant):** pack licenses cannot be verified from the filesystem — the Fab/Marketplace library in-editor is authoritative. Before shipping any source in an original cue, confirm its license permits derivative in-game use. Prefer **synthesis + short one-shots** over finished marketplace tracks so the result is original and self-owned.

## 5. Redirectors / duplicates
- No redirectors pointing at `Ambient_Music_v1`.
- Historical note (PROJECT_STATE): a duplicate `Framework/Audio/` SoundClass/Mix set was created and **already deleted**; the `EE_ProjectFiles/Audio` submix set is the single source of truth. No current audio duplicates found on disk.

## 6. Handoff
Build sequence, asset structure, API, integration hooks, and the deletion gate: **`EE_MusicSystem_BuildRunbook.md`**. Orchestration + export + the two reference MIDIs: `AUDIO_PRODUCTION_PACKAGE.md` / `MUSIC_DESIGN_BIBLE.md`.
