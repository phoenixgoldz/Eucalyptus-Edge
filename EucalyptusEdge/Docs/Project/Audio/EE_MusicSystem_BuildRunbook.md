# EE_MusicSystem_BuildRunbook.md — in-editor build & replacement plan

**2026-07-19.** Executes the 6-agent music-system plan **in an interactive UE 5.8 session** (the steps below cannot run from a background/no-bridge session: they create/compile binary `.uasset`s, run Reference Viewer, PIE, and package). Agent 1 (audit) is **done** — see `EE_AudioAudit.md`, `EE_AmbientMusicV1_Referencers.md`. Consume those outputs; do not re-guess paths. Compose from `AUDIO_PRODUCTION_PACKAGE.md` + the two MIDIs.

## 0. Path & naming reconciliation (decide first)
The brief asks for `/Game/EucalyptusEdge/Audio/Music/...`; the project already roots audio at **`/Game/EE_ProjectFiles/Audio/`**. **Recommendation:** keep one root — build under **`/Game/EE_ProjectFiles/Audio/Music/{Core,Menu,Arenas,Stingers,Sources,Mixes,MetaSounds,Blueprints,Data}`** to match the existing `EE_Master/EE_Music/EE_SFX` + submixes. **Reuse, don't duplicate:** requested `SC_EE_Music`≈existing **`EE_Music`**; `SM_EE_MasterMusic`≈existing **`EE_MusicSubmix`**. Only add what's missing: `SC_EE_Music_Stingers` (child of `EE_Music`), optional `EE_Ambient`/`EE_Voice`.

## Stage 2 — `BP_EE_MusicDirector` (own: music-director BP only)
- **Make it a `GameInstanceSubsystem`** (`BP_EE_MusicDirector` or `SS_EE_Music`). This is the clean answer to *single instance, persists across map travel, no per-map/per-widget players, local-MP-safe, no duplicate directors* — a subsystem is created once per GameInstance and survives level loads. (If a BP-actor is required instead, spawn it once from `BP_EE_GameInstance` and mark it never-destroy; a subsystem is preferred.)
- Assets: `BPI_EE_MusicInterface` (interface), `E_EE_MusicState` (13 states, §Music States), `E_EE_CombatIntensity` (Neutral/Pressure/…), `ST_EE_MusicTrackDefinition` (State→MetaSound/Cue, loop flag, SoundClass, fade in/out, stinger refs), `DT_EE_MusicTracks` (rows per state).
- Holds **one** active `UAudioComponent`/MetaSound instance; switching state = crossfade params on it, **never** a new `PlaySound2D` (avoids the known "orphaned sound"/double-play). Route through **`EE_Music`** SoundClass → `EE_MusicSubmix`.
- Volume: **call the existing** `BP_EE_GameInstance.ApplyAudioSettings` path; do not rebuild Options.
- **API (Blueprint-callable):** `SetMusicState(E_EE_MusicState)`, `SetCombatIntensity(E_EE_CombatIntensity)`, `SetEdgeEnergyReady(bool)`, `SetFinalRound(bool)`, `PlayVictoryStinger()`, `PlayDefeatStinger()`, `PauseMusic()`, `ResumeMusic()`, `StopMusic()`, `ApplyMusicVolume(float)`, `GetCurrentMusicState()`. Document each in the BP description. **Commit 2.**

## Stage 3 — MetaSounds (own: MetaSound/synthesis assets)
- Build `MS_EE_Title`, `MS_EE_MainMenu`, `MS_EE_CharacterSelect`, `MS_EE_EucalyptusSummit`, `MS_EE_Victory`, `MS_EE_Defeat` (min set). Summit carries Intro / Neutral(LoopA) / Pressure(LoopB) / EdgeEnergy / FinalRound sub-layers with a `MusicState` input + quantized, sample-accurate crossfades.
- **Sources, in the brief's priority order:** project-owned one-shots first (`FreeModularMagicSFX` tonal/shimmer, `SmallSoundKit`, footstep percussion), then **MetaSound oscillators** for pads/drones — layered with envelopes, filtering, stereo movement, controlled variation (no bare single-oscillator melodies). Derive motifs/timing from `EE_EdgeTheme_Mockup.mid` + `EE_Arena_EucalyptusSummit_Adaptive.mid` (the Edge Cell A–D–E–F#, Honor Cadence C–G–D, Blight signature reserved).
- Loop-safe, frame-rate-independent. **Label every asset "Production Prototype v1"** in its description — these are prototypes, not final orchestral masters. **Commit 3.**

## Stage 4 — gameplay integration (own: event→director bindings only)
Bind through `BPI_EE_MusicInterface`/dispatchers, **event-driven, no Tick polling**, **no** HUD/widget/combat/anim rewrites:
| Event (existing) | Call |
| --- | --- |
| `WBP_MainMenu` Construct | `SetMusicState(MainMenu)` (replaces `WAV_Menu_Loop`) |
| Character Select widget Construct | `SetMusicState(CharacterSelect)` (replaces `CUE_Village_Loop`) |
| `BP_EE_VersusGameMode` BeginPlay | `VersusIntro`→`RoundIntro`→`CombatNeutral` (replaces `CUE_Battle_Loop`) |
| EDGE meter full (combat) | `SetEdgeEnergyReady(true)` |
| Final round begins | `SetFinalRound(true)` |
| `BP_EE_VersusGameMode.OnFighterEliminated` | `PlayVictoryStinger()` / `PlayDefeatStinger()` then `Results` (replaces `Trailer_Horns_of_War_Cue`) |
| Pause open/close | `PauseMusic()` duck / `ResumeMusic()` |
- **Local MP:** only the GameMode (server/host authority) drives music state — never each PlayerController — so P1+P2 cannot spawn two directors. Subsystem already guarantees one instance. **Commit 4.**

## Stage 5 — replacement (own: reference replacement)
- **`Ambient_Music_v1` replacement set is EMPTY** (0 referencers — `EE_AmbientMusicV1_Referencers.md`). Nothing to re-point for it.
- The **valid** replacements are the four in-use placeholders in Stage 4's table → now driven by the MusicDirector. Preserve all **environmental** ambience (wind/leaves/birds/rain/waterfalls) — do **not** touch them because they say "ambient."
- Fix Up Redirectors; re-run the reference scan. **Commit 5.** Produce a replacement report (original ref → new integration → validation).

## Stage 6 — validation (own: validation/perf reports)
Run in editor + PIE + packaged; write `EE_MusicValidationReport.md` + `EE_MusicPerformanceReport.md`:
- one director only (no duplicate players / no two tracks at once); menu track **doesn't restart** opening Options/Credits; CharSelect + Summit cues start correctly; Edge + Final-Round layers activate; victory/defeat stingers play **exactly once**; volume slider + mute work; pause ducking works; music persists/transitions across map travel; P1+P2 don't create two directors.
- No missing-wave / MetaSound-compile / Blueprint-compile / redirector / deleted-ref errors; no per-frame BP polling; 60 FPS unaffected; packaged build OK. **Commit 6** (fixes).

## Stage 7 — DELETION GATE for `/Game/Ambient_Music_v1`
Delete **only** when ALL pass: references replaced (none exist); **Reference Viewer = 0** valid referencers; all BPs + MetaSounds compile; Title/Menu/CharSelect/Summit/Victory/Defeat all work; packaged test succeeds; **source-control checkpoint committed**; new system **audible, not silent**; project opens with **no missing-asset warnings**.
Then: **commit the replacement first (separate)** → **Unreal-safe delete** (Content Browser → Delete, never Explorer/force) → Fix Up Redirectors → re-scan → recompile → launch → test maps → package dev build → **commit the verified deletion separately (Commit 7)**.

## STOP and report (do not improvise) if
AM_v1 turns up referenced by a cooked-only asset; a source's license can't be verified; UE 5.8 MetaSound APIs differ from expectation; a required op needs an unavailable interactive step; the system is silent; playback duplicates; any core BP fails to compile; the packaged build fails; or removing AM_v1 would create a missing reference.

## Commit ledger
1. **Audit — DONE this session** (Agent 1 docs). 2–7 above happen in the editor session; keep them as separate commits; **never combine deletion with implementation.**
