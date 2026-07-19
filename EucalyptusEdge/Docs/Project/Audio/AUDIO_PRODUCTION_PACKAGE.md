# EUCALYPTUS EDGE — AUDIO PRODUCTION PACKAGE (Phase 1)

**Authored 2026-07-19.** The turnkey production layer between `MUSIC_DESIGN_BIBLE.md` (identity/spec) and shipped audio. Covers: per-track **orchestration guide**, the **adaptive combat construction** (worked on Eucalyptus Summit), the **export manifest** (WAV masters / stems / loops / stingers), and the **UE 5.8 build** (Sound Cues + MetaSounds on the canonical `EE_MusicSubmix`).

## Scope & the two hard seams (unchanged, stated plainly)
Everything here is authored so the last two steps are mechanical — but those two steps **cannot happen in the doc/agent environment**:
1. **Rendering audio** (orchestral WAV masters/stems/loops/stingers) needs a composer at a DAW with sample libraries or live players. Not producible here.
2. **Binary UE assets** (`.uasset` MetaSounds/Cues) are built in-editor (MCP can't create them; no bridge in a background job).

Delivered now: two editable **MIDI** artifacts + this spec. Priority order per directive: **Title → Main Menu → Character Select → Eucalyptus Summit**, then other arenas. **No trailer music** until the gameplay soundtrack is complete.

MIDI artifacts in this folder:
- `EE_EdgeTheme_Mockup.mid` — theme + Honor Cadence + 7 fanfares (identity sketch).
- `EE_Arena_EucalyptusSummit_Adaptive.mid` — the adaptive combat build below (9 tracks, seamless loop, layers, stings).

---

## 1. Orchestration guide — the four priority tracks

Common law: state the **Edge Cell (A–D–E–F#)** within 10s; D major Lydian↔Mixolydian; nature bed on its own `EE_Ambient` submix, subtle. Dynamics use the whole orchestra as *layers* you can mute/solo into stems.

### P1 · Title Screen (2:30, D 6/8, ~66 feel)
- **0:00–0:45 (Wonder):** celesta + harp harmonics state the Wonder Lift; soft SATB "oo"; high divisi strings (sul tasto); nature bed (wind, distant birds). *pp→p.*
- **0:45–1:30 (Hope):** solo F-horn takes the Edge Cell; cellos + basses enter; light frame drum. *p→mf.*
- **1:30–2:10 (Heroic):** full strings + horns + trumpets on the theme; timpani; choir to "ah"; the Honor Cadence peak. *f.* 
- **2:10–2:30 (settle→loop):** thin to celesta + strings; land on a quiet D(add9) loop tail. 
- **Stems:** Strings, Brass, WW, Choir, Perc, Nature, FX(Edge shimmer), Master.

### P2 · Main Menu (3:00 seamless, D 6/8, ~76 — must never fatigue)
- Continuous low-motion bed: sustained strings + harp ostinato (D–A pedal), fragments of the Edge Cell traded flute↔oboe↔solo violin so it's *implied*, never hammered. No loud brass, no big hits. Choir only as distant color. Long 24-bar phrases; nature bed steady.
- **Loop:** one seamless take; bar-aligned loop point; keep RMS low and even so it survives hundreds of hours.
- **Stems:** Strings, WW, Harp/Aux, Choir(low), Nature, Master.

### P3 · Character Select (1:30–2:00 seamless, E 4/4, ~150 — excitement)
- Edge Cell up-front on trumpets; driving frame drums + wood blocks; pizzicato + staccato strings ostinato; light choir "ah" stabs; woodwind runs between phrases. Confident, fast, "I want to fight." No EDM — keep it orchestral.
- **Stems:** Strings, Brass, WW, Choir, Perc(wood/frame), Master.

### P4 · Eucalyptus Summit (adaptive combat — see §2; D Lydian/Mixo, 152)
Bright heroic; horns lead, strings drive the theme, taikos + timpani propel; piccolo/flute sparkle on rising bars; choir + celesta reserved for the additive layers; nature = wind/leaves under everything.

---

## 2. Adaptive combat construction (worked example: Eucalyptus Summit)

Reference render map for `EE_Arena_EucalyptusSummit_Adaptive.mid` (152 BPM, 4/4, 480 PPQ → 1 bar = 1920 ticks ≈ 1.579 s):

| Segment | Bars | Ticks | ≈ sec | Purpose |
| --- | --- | --- | --- | --- |
| **Intro** | 1–4 | 0–7 680 | 0.0–6.32 | One-shot; horn call + swell → hits Loop A downbeat. |
| **Loop A (Neutral)** | 5–12 | **7 680–23 040** | 6.32–18.95 | The seamless 8-bar combat loop. **LOOP START = 7 680, LOOP END = 23 040.** |
| **Loop B (Pressure)** | 13–16 | 23 040–30 720 | 18.95–25.26 | Intensity variant (eighth taikos, full brass/choir, higher melody). Interchange with A at the bar. |
| **Victory Sting** | 17–18 | 32 640–36 480 | — | Honor Cadence C–G–D; ducks the loop. |
| **Defeat Sting** | 19–20 | 38 400–42 240 | — | Deflated minor, unresolved. |

**Stem/layer tracks in the MIDI** (each renders to its own audio stem):
1 Strings-Hi (melody) · 2 Strings-Lo (pad) · 3 Horns · 4 Woodwinds · 5 Percussion · 6 Bass — the **Loop A core**.
7 Choir = **FINAL ROUND** additive layer · 8 Celesta = **EDGE ENERGY** additive layer (both written over the loop; gated on in-engine).

**Runtime state → mix (crossfade only, never restart):**
| `EMusicState` | Core (1–6) | Choir (FinalRound) | Celesta (EdgeEnergy) | Which loop |
| --- | --- | --- | --- | --- |
| Neutral | on | off | off | Loop A |
| Pressure | on (louder) | off | off | Loop B |
| EdgeReady (meter full) | on | – | **fade in** | A or B |
| FinalRound | on | **fade in** | as meter | A or B |
| Victory / Defeat | duck → sting | — | — | sting one-shot |

**Loop authoring:** render the loop region as its own file (2× and cut on the sample at the bar), embed `smpl`-chunk loop points; render each additive layer as a matching-length loop so it drops in on the bar. A⇄B crossfade ≈ 1 bar; layer fade ≈ 2 bars; sting ≈ immediate with 1-beat duck.

---

## 3. Export manifest (composer → project)

**Format for all:** 48 kHz / 24-bit WAV, embedded loop points where "loop", integrated-LUFS per column. Naming: `EE_<Cat>_<Name>[_<Layer>]_v1.wav`.

### Masters (stereo)
| File | Loop? | ~LUFS |
| --- | --- | --- |
| `EE_Title_Screen_v1.wav` | tail-loop | −18 |
| `EE_Menu_MainLoop_v1.wav` | seamless | −20 |
| `EE_CharSelect_Loop_v1.wav` | seamless | −16 |
| `EE_VersusIntro_v1.wav` | one-shot | −14 |
| `EE_Arena_EucalyptusSummit_Intro_v1.wav` | one-shot | −14 |
| `EE_Arena_EucalyptusSummit_LoopA_v1.wav` | seamless | −14 |
| `EE_Arena_EucalyptusSummit_LoopB_v1.wav` | seamless | −13 |

### Additive layer stems (Summit; loop-matched to LoopA/B)
`EE_Arena_EucalyptusSummit_EdgeLayer_v1.wav` · `..._FinalRoundLayer_v1.wav`

### Instrument stems (per master, for in-engine remix / mastering)
`_Strings`, `_Brass`, `_Percussion`, `_Choir`, `_Nature`, `_FX`, plus `_Master`. (Bible §8 palette; Woodwinds fold into `_Strings`/`_FX` or ship as `_Woodwinds` if desired.)

### UI stingers (short one-shots, no loop)
`EE_Sting_Victory_v1.wav`, `EE_Sting_Defeat_v1.wav`, `EE_Sting_RoundStart_v1.wav`, `EE_Sting_FinalRound_v1.wav`, `EE_Sting_EdgeReady_v1.wav`, `EE_Fanfare_<Fighter>_v1.wav` (×7 + codename secret).

Deliver a per-file sheet: key, BPM, meter, bar count, loop start/end (samples **and** bars), LUFS.

---

## 4. UE 5.8 build (on the canonical submix system)

> Import + SoundWave/SoundClass/SoundCue steps are UE-Python-scriptable in-editor. **MetaSound graphs and Submix creation are manual** (bible §9). Do **not** add a parallel volume system.

**4.1 Folders:** import WAVs to `/Game/EE_ProjectFiles/Audio/Music/{FrontEnd,Arenas/EucalyptusSummit,Fanfares,Stings}`.

**4.2 SoundClass/submix:** assign `EE_Music` (children `EE_Music_FrontEnd` / `_Interactive` / `_Stinger`); add `EE_Ambient`→`EE_AmbientSubmix` for `_Nature`; extend `BP_EE_GameInstance.ApplyAudioSettings` with the new submixes.

**4.3 Reference import + Cue script** (run in-editor **after** the WAVs exist; scriptable portion only — verify against your 5.8 API, adjust paths):
```python
import unreal
BASE = "/Game/EE_ProjectFiles/Audio/Music/Arenas/EucalyptusSummit"
tools = unreal.AssetToolsHelpers.get_asset_tools()
def import_wav(src, dest, looping):
    t = unreal.AssetImportTask()
    t.filename = src; t.destination_path = dest; t.automated = True; t.save = True
    unreal.AssetTools.import_asset_tasks(tools, [t])
    w = unreal.load_asset(dest + "/" + unreal.Paths.get_base_filename(src))
    if w: w.set_editor_property("looping", looping)
    return w
def make_cue(name, wave):
    cue = tools.create_asset(name, BASE, unreal.SoundCue, unreal.SoundCueFactoryNew())
    # wire a WavePlayer node -> output; set sound class; then save
    return cue
# loopA = import_wav(r"D:\render\EE_Arena_EucalyptusSummit_LoopA_v1.wav", BASE, True)
```
**4.4 MetaSound (manual):** one `MSS_Arena_EucalyptusSummit` — WavePlayers for Intro/LoopA/LoopB/Edge/FinalRound with sample-accurate loops, inputs `MusicState`/`EdgeEnergy01`/`bFinalRound`, triggers `Victory`/`Defeat`, quantized internal crossfades → `EE_MusicSubmix`.

**4.5 `BP_EE_MusicDirector`** (subsystem/component): owns the active MetaSound; `SetMusicState()`, `SetEdgeEnergy(float)`, `OnRoundChanged(int,bool)`, `OnMatchEnd(bool,Name)`→fires fanfare. Driven by `BP_EE_VersusGameMode` (BeginPlay→Intro, EDGE meter→EdgeEnergy, round→state, `OnFighterEliminated`→sting+fanfare). Front-end: `SpawnSound2D` components (not `PlaySound2D`) so it crossfades across level travel.

---

## 5. Checklist / who does what
1. **Composer:** render Title + Menu + CharSelect + Summit (Intro/LoopA/LoopB + Edge/FinalRound layers + Victory/Defeat + 7 fanfares) from the two MIDIs and §1–3; deliver §3 manifest.
2. **Editor session (unreal-mcp / manual):** import per §4, build the MetaSound + `BP_EE_MusicDirector`, replace placeholders (`WAV_Menu_Loop`, `CUE_Village_Loop`, `CUE_Battle_Loop`, retire `Trailer_Horns_of_War_Cue`).
3. **PIE verify:** seamless loop, A⇄B crossfade, Edge/FinalRound on real meter/round events, victory→fanfare, 60 FPS held, sliders affect all music.
4. **Then** other arenas (Crystal Caverns → … → Colosseum), then — last — any trailer cut.

Cross-ref: `MUSIC_DESIGN_BIBLE.md`, `CANON.md` § Audio & Music, `PROJECT_STATE.md` (existing audio framework).
