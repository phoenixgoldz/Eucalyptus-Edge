# EE_AmbientMusicV1_Referencers.md — reference audit for `/Game/Ambient_Music_v1`

**Audit 2026-07-19 (Agent 1, read-only). Nothing was modified or deleted.**

## What the asset actually is
`/Game/Ambient_Music_v1` is **not a single asset — it's a pack folder** at `EucalyptusEdge/Content/Ambient_Music_v1/`:
- `Sound_Waves/` — **10 SoundWaves**: `1_Background_1` … `10_Background_10`.
- `Sound_Cues/` — **10 SoundCues**: `1_Background_1_Cue` … `10_Background_10_Cue` (each wraps its matching wave).

A generic ambient-background-loop pack. (`PROJECT_STATE.md` pack audit: *"Ambient_Music_v1 — 187 MB — DELETE — unused music (PathOfAdventure + FreeAtmos cover music)."*)

## Scan method (filesystem — Reference Viewer is authoritative, unavailable here)
Byte-level (`grep -a`, binary-as-text) + text scan across **every** `.uasset` and `.umap` in `Content/` and every `.ini` in `Config/`, searching for:
- the package path `Ambient_Music_v1` (catches hard refs + soft/string refs — UE stores referenced package paths in the import/name tables), and
- the individual asset base-names (`Background_1_Cue`, `Background_5_Cue`, `Background_10_Cue`, `Background_1`).
Folder excluded from the scan of *referencers* so its internal Cue→Wave links don't count.

## Result: **ZERO referencers**
No map, widget, GameMode, GameInstance, Actor, Blueprint, C++, Data Asset, config, Sequencer, Sound Cue, or MetaSound references `Ambient_Music_v1` or any of its 20 assets. The only references to these assets are **internal** (each Cue → its own Wave, inside the pack).

- **Redirectors:** none found (no rename history pointing at it).
- **Config:** no `DefaultEngine.ini`/`DefaultGame.ini` default-sound reference.

## Consequence for the replacement task
**The replacement set is empty — there is nothing in the game to re-point.** Agent 5's "replace every valid use" has no valid uses to replace. `Ambient_Music_v1` is a true orphan and a clean **safe-delete candidate**.

Per the deletion gate, it is still **not** deleted here (and cannot be from this environment): delete only **after** the new music system is built, audible, and committed — and only via **Unreal-safe in-editor delete + Fix Up Redirectors**, never Explorer/force-delete.

> Caveat: only the in-editor **Reference Viewer** is authoritative. This filesystem scan is a strong proxy and agrees with the PROJECT_STATE audit; re-confirm with Reference Viewer in the editor before the final delete (deletion-gate step).
