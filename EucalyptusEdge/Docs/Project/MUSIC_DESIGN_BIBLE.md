# EUCALYPTUS EDGE — MUSIC DESIGN BIBLE (Phase 1)

**Status:** Phase 1 audio direction standard, authored 2026-07-19. This is the audio equivalent of `CONTROLLER_LAYOUT.md`: the locked identity + the spec a composer renders and an audio programmer implements. Core rulings are promoted to `CANON.md` (§ Audio & Music).

**Role of this doc:** define ONE musical identity so every cue is recognizably *Eucalyptus Edge* within 10 seconds, and specify every Phase 1 track, the dynamic-music/stem system, the per-fighter fanfares, the delivery spec, and the UE 5.8 implementation on the **existing** `EE_MusicSubmix` framework.

**Scope honesty (read once):**
- This document is complete pre-production. The **actual 48k/24-bit orchestral audio must be composed/recorded/rendered by a composer** with orchestral libraries (or licensed players) — it cannot be generated in-engine or by the AI toolchain.
- **UE audio assets (SoundClasses, Submixes, MetaSounds, Cues) cannot be created by MCP tooling** (per PROJECT_STATE: they were hand-duplicated from engine assets). The UE build below is a **manual editor / interactive-session pass**. Everything here is authored so that pass is mechanical.
- **No trailer music.** The current `Trailer_Horns_of_War_Cue` victory placeholder is explicitly replaced by the fanfare system in §7.

---

## 0. Canon alignment (what constrains the music)

- **Tone:** *Cute Fighters. Serious Skills.* Beautiful, magical, hopeful, heroic, occasionally corrupted by the Blight. **Never** comedy, slapstick, goofy, horror, EDM, dubstep, rock, metal, chiptune, lo-fi, jazz, or Hollywood-trailer bombast.
- **Style:** AAA cinematic orchestral — organic, natural, epic, fast, emotional. Never generic fantasy.
- **Visual law → audio law:** **Violet = Blight only** ⇒ the Blight has a **reserved dissonant signature** used nowhere else (§2.4). **Gold = honor** ⇒ victory uses the Honor Cadence (§2.3). **Edge Energy is subtle, alive, never distracting** ⇒ the Edge layer is a high, quiet shimmer (§6).
- **Canon roster (7 + secret):** Koda, Wren, Ripper, Kiri, Echo, Banjo, Atlas; **Sonia the White Tigress** is the secret unlockable — **never named in public/marketing**; her fanfare ships under a **codename asset filename** (§7).
- **Canon arenas (8):** Eucalyptus Summit, Crystal Caverns, Bamboo Harbor, Frostpine Ridge, Sunbaked Outback, Moonlit Rainforest, Edge Festival Colosseum, Blightroot Hollow. *(Brief's "Red Dune Outpost"/"Crystal Cavern" corrected to canon.)*
- **Existing framework is canonical — extend, never duplicate:** `EE_Master/EE_Music/EE_SFX` SoundClasses, `EE_MusicSubmix/EE_SFXSubmix`, volume via `BP_EE_GameInstance.ApplyAudioSettings`. "Do not introduce a parallel volume system" (handoff_ui_polish).
- **Performance Standard:** 60 FPS locked; combat is frame-rate independent. Music transitions must be event/quantization-driven, never per-frame, and must never hitch combat.

---

## 1. The identity rule (enforceable)

> **Every track must state or clearly imply the Edge Cell (§2.1) within its first 10 seconds**, in some instrumentation. This is the contract that makes the franchise recognizable. A cue that doesn't carry the motif in some form is not an Eucalyptus Edge cue.

Everything below descends from **one master theme, "The Edge Theme."**

---

## 2. The Edge Theme — master musical identity

**Home key: D major** (warm on strings' open D, heroic on horns), colored by **modal mixture** between **Lydian** (raised 4th = magic/wonder) and **Mixolydian** (lowered 7th = ancient/heroic/folk). This Lydian↔Mixolydian shimmer is the signature that keeps it *original*, not generic fantasy.

Scale-degree reference in D: `1=D  2=E  3=F#  4=G  #4=G#(Lydian)  5=A  ♭5=A♭(BLIGHT)  6=B  ♭7=C♮(Mixo)  7=C#`.

### 2.1 The Edge Cell (Motif A — the hook)
Scale degrees **5 – 1 – 2 – 3** → in D: **A – D – E – F#**.
- Pickup **A** (eighth) → leap up a **perfect 5th** to **D** (quarter, downbeat) → step **E** (eighth) → **F#** (dotted, held).
- Character: a reaching-upward, hopeful, heroic gesture landing on the bright **major 3rd**. Short, singable, interval-distinctive (the opening **P5 leap** is the "logo").
- This is the 10-second identity payload. Horns/trumpets state it heroically; celeste/harp state it as wonder; pizzicato states it playfully.

### 2.2 The Wonder Lift (Motif B — the magic tag)
Scale degrees **3 – #4 – 5** → **F# – G# – A** (the **Lydian** raised-4th rising into 5).
- A glowing, lifting resolution. Celeste, harp harmonics, soft choir "oo", high strings. This is the "Verdantia is magical" fingerprint and the seed of the **Edge Energy layer** (§6).

### 2.3 The Honor Cadence (victory / "gold")
**♭VII – IV – I** → **C – G – D** (Mixolydian plagal). Broad, noble, resolved — the sound of earned honor. All victory fanfares and the Results screen cadence on this. **This replaces trailer bombast.**

### 2.4 The Blight Signature (RESERVED — the musical "violet")
Corruption of the theme, used **ONLY** for the Blight (Blightroot Hollow, corrupted story beats). Never in any hopeful/heroic cue.
- **F# → F♮** (major 3rd collapses to minor 3rd).
- **A → A♭**: the **D–A♭ tritone = "the Blight interval."** Reserved. Hearing it must *mean* corruption, exactly as violet does on screen.
- **Detuned drone** a quartertone flat under a low **didgeridoo**; prepared/atonal low brass; timpani/gran casa swells. **Still orchestral — never horror**, never sound-design noise-scapes.

### 2.5 Derivation rules (how everything stays "related")
1. **Meter recasts function.** Menus/title state the theme in lilting **6/8** (adventurous, hopeful); combat recasts the **same pitches** in driving **cut-time 4/4** with taikos (energetic). Same melody, different engine.
2. **Instrumentation carries personality/place**, pitches stay constant (see arenas §5, fanfares §7).
3. **Transpose freely, keep the intervals.** Character Select lifts to **E** for brightness; arenas each take a related key/mode (§5).
4. **The Wonder Lift is the Edge/magic seed** everywhere; the **Honor Cadence is victory** everywhere; the **Blight Signature is corruption** and nothing else.

---

## 3. Instrument palette (per brief, organized for mixing)
- **Strings** (full section; also solo lines), **Brass** (F horns lead the heroism; Cs, Tbns, Bass Tbn, Tuba), **Woodwinds** (picc, fl, ob, cl, bsn), **Choir** (soft SATB, **vowels only, no lyrics**).
- **Percussion:** timpani, taikos, concert bass drum, snare, frame drums, wood blocks, gran casa, cymbals.
- **Nature layer** (very subtle, its **own submix** so it's mixable and ducks under Edge Ultimates): wind, leaves, birds, forest, light rain, waterfalls, streams.
- **Australian inspiration (never cliché):** **didgeridoo only** in Sunbaked Outback and the Blight drone — as a low drone/rhythmic texture, never a novelty lick. Wood percussion in Bamboo Harbor & Character Select. Natural textures throughout.

---

## 4. Front-end tracks (Priorities 1–4)

| # | Track | Length / form | Key · meter · tempo | Direction |
| --- | --- | --- | --- | --- |
| **P1** | **Title Screen** | 2:30, slow build → heroic button, then soft loop point | D · 6/8 · ~66 feel | Wonder/mystery/hope → heroic arrival. Opens on Wonder Lift (celeste + soft choir + nature bed); Edge Cell blooms on solo horn ~0:45; full statement + Honor Cadence at the peak (~2:00); settles to a quiet loop tail. Recognizable in 10s via the celeste Edge Cell. |
| **P2** | **Main Menu** | **3:00 seamless loop**, must never annoy | D · 6/8 · ~76 | Calm confidence, nature, adventure, magic. Edge Cell implied, never hammered — fragmented across flute/harp/strings; long phrases, low percussion, lots of air. Designed for hundreds of hours: no earworm-fatigue hooks, no loud brass, seamless bar-aligned loop. |
| **P3** | **Character Select** | 1:30–2:00 seamless loop | **E** · fast 4/4 (or 12/8) · ~150 | Excitement, energy, confidence. Edge Cell up-front on trumpets, driving frame drums + wood blocks, light choir "ah". "I want to fight NOW." Still organic-orchestral, never EDM. |
| **P4** | **Versus Intro** | **~15s**, one-shot (non-loop) | D · 4/4 · ~90 grand | Big F-horn + trumpet statement of the Edge Cell, taiko + gran casa, cymbal swell → hard downbeat hand-off into arena Intro. Short, powerful, heroic. Ends on the dominant (A) to lead into combat. |

---

## 5. Arena combat tracks (Priorities 5–10 + 2 canon extensions)

All combat tracks: **driving cut-time 4/4**, seamless forever, built as the **dynamic stem set** in §6 (Intro / Loop A / Loop B / Final-Round / Edge / Victory / Defeat). Each states the Edge Cell in its arena color within 10s.

| # | Arena (canon name) | Key · mode · tempo | Palette focus / mood |
| --- | --- | --- | --- |
| **P5** | **Eucalyptus Summit** | D Lydian↔Mixo · 152 | The flagship. Bright heroic full theme; F-horns + strings + taikos; nature = wind/leaves. Hopeful, natural, fast. |
| **P6** | **Crystal Caverns** | F#m → A · 148 | Mystical crystal resonance: celeste, glass/crotales, harp harmonics, the Wonder Lift featured; choir "oo". Fast but shimmering. |
| **P7** | **Moonlit Rainforest** | B Dorian · 144 | Night: muted horns, frame drums, bass clarinet, soft choir, distant birds/rain. Mystical, nocturnal, still fast. |
| **P8** | **Bamboo Harbor** | G major · 150 | Ocean/wind adventure: flutes + strings sweep, wood percussion, gentle waterfalls/streams in the nature bed. Open-air, hopeful. |
| **P9** | **Blightroot Hollow** | D + **Blight Signature (§2.4)** · 160 | Dark, corrupted, aggressive — the theme *poisoned* (F♮, D–A♭ tritone, detuned didg drone, low brass, gran casa). **Orchestral, never horror.** The only track that uses the reserved Blight signature. |
| **P10** | **Sunbaked Outback** *(was "Red Dune Outpost")* | A Mixolydian · 146 | Desert warmth, ancient heroism: low woodwinds, taikos, **didgeridoo (sparingly)** as drone, warm horns. Ancient, heroic. |
| +Ext | **Frostpine Ridge** | E Aeolian/Dorian · 150 | Canon arena (not in brief's priority list). Crisp cold: high strings, glass, flutes, brittle percussion. Heroic, clean. |
| +Ext | **Edge Festival Colosseum** | D major · 156 | Canon championship arena = the **fullest statement of the Edge Theme**: choir-forward, full brass, the Honor Cadence woven in. The "home" track. |

---

## 6. Dynamic music / stem architecture (every combat track)

Export each combat track as these stems/layers, all **bar-aligned to the track's tempo** and **sample-accurate looped**. **Never restart — crossfade only.**

| Layer | Type | Trigger (game state) | Notes |
| --- | --- | --- | --- |
| **Intro** | one-shot, → Loop A | Arena load / after Versus Intro | 4–8 bars; must beat-match into Loop A seamlessly. |
| **Loop A (Neutral)** | seamless loop | Default combat | Baseline intensity. Full theme, moderate drive. |
| **Loop B (Pressure)** | seamless loop | Rising intensity (low HP on either fighter, or time in round) | Same harmony/length as A (interchangeable at the bar); more percussion + brass. A⇄B by **quantized crossfade**. |
| **Final Round Layer** | additive stem | Final/decisive round begins | Extra taikos + horns + choir over A/B. Raises stakes without a restart. |
| **Edge Energy Layer** | additive stem | A fighter's **EDGE meter fills / Ultimate ready** | **Subtle** high shimmer on the Wonder Lift (celeste/glass/choir "oo"), low volume — "alive, never distracting." Fades with the meter (`EdgeEnergy01`). |
| **Victory Sting** | one-shot tag | KO / ring-out win | 3–5s, cadences on the Honor Cadence; ducks/cuts the loop. Hands off to the fighter fanfare (§7). |
| **Defeat Sting** | one-shot tag | KO / ring-out loss | Short, the theme deflated (minor, unresolved). Never comedic. |

**Intensity state machine (enum `EMusicState`):** `Intro → Neutral(LoopA) ⇄ Pressure(LoopB)`, with **additive** `FinalRound` and `EdgeReady` layers, terminating in `Victory` / `Defeat`. All transitions quantized to the bar (or beat for stings). Crossfade times: A⇄B ≈ 1 bar; layer fade-in ≈ 2 bars; sting ≈ immediate with 1-beat duck.

**Seamless-loop requirement:** combat lasts 30s–5min; loops must be inaudible-seam. Composer renders 2× loop and cuts on the sample at the bar; loop markers embedded (§8).

---

## 7. Victory fanfares (per fighter, 3–5s, from the theme)

Each = the **Edge Cell + Honor Cadence**, re-orchestrated for personality. Reuses the theme so every win still says "Eucalyptus Edge."

| Fighter | Personality | Fanfare orchestration |
| --- | --- | --- |
| **Koda** | Calm, noble | Solo F-horn Edge Cell over low strings; broad, unhurried; full Honor Cadence. |
| **Wren** | Fast, confident | Staccato trumpets + snare flourish; quick, bright, upward. |
| **Ripper** | Aggressive | Minor-inflected low brass + taiko hits; snarling but **resolves** (rival, not Blight — no Blight signature). |
| **Kiri** | Elegant | Flute/piccolo + harp glissando + light strings; airborne (kookaburra). |
| **Banjo** | Playful | Pizzicato strings + wood block + bassoon hops; light, bright — **not goofy**. |
| **Echo** | Mystical | Celeste/vibraphone + wordless choir + the Wonder Lift; watery. |
| **Atlas** | Majestic | Full horn section + timpani + choir; grand, regal, slow. |
| **[secret — codename asset]** | (exotic/teaser) | Edge Cell in an exotic mode (orange-and-gold color), hints DLC. **Ship under a codename filename; never name her in public/marketing.** |

---

## 8. Technical delivery spec (composer → project)

- **Format:** 48 kHz / 24-bit **WAV**, stereo masters + stems. (Consider 5.1 later; Phase 1 = stereo.)
- **Loop markers:** embedded `smpl`/`cue` chunks with **sample-accurate loop start/end on bar boundaries**. Provide loop points in the metadata sheet too (samples + bars).
- **Per-track sheet:** title, **key signature, BPM, meter, tempo map** (if variable), bar count, loop points, intensity-layer list, LUFS target.
- **Stems (per brief):** **Strings · Brass · Woodwinds · Percussion · Choir · Nature · FX · Master.** (Combat stems additionally split the §6 layers so the engine can mix them live.)
- **Loudness:** consistent integrated LUFS across a category (menus quieter than combat); leave headroom (no brickwall masters — the engine mixes and ducks).
- **Naming (delivery):** `EE_<Category>_<Name>[_<Layer>]_v<version>.wav`, e.g. `EE_Arena_EucalyptusSummit_LoopB_v1.wav`, `EE_Fanfare_Wren_v1.wav`, `EE_Menu_MainLoop_v1.wav`.

---

## 9. UE 5.8 implementation architecture (build on the existing submix system)

> **Cannot be created via MCP** (no create-asset tool for SoundClass/Submix/MetaSound). This is the manual/interactive-editor build spec. **Do not create a parallel volume system.**

### 9.1 Folders (`/Game/EE_ProjectFiles/Audio/`)
```
Audio/
├─ EE_Master / EE_Music / EE_SFX            (existing SoundClasses — keep)
├─ EE_MusicSubmix / EE_SFXSubmix            (existing Submixes — keep)
├─ EE_AmbientSubmix / EE_VoiceSubmix        (ADD under EE_Master — nature + VO, per ui-polish guidance)
└─ Music/
   ├─ FrontEnd/   (Title, Menu, CharSelect, VersusIntro)
   ├─ Arenas/<ArenaName>/   (Intro, LoopA, LoopB, FinalRound, Edge, Victory, Defeat stems)
   ├─ Fanfares/  (per fighter; secret = codename)
   └─ Stings/    (shared Victory/Defeat cadence, round stingers)
```

### 9.2 SoundClass / submix routing
- Under existing **`EE_Music`** add children: `EE_Music_Interactive` (arena stems), `EE_Music_FrontEnd`, `EE_Music_Stinger`.
- Add **`EE_Ambient`** SoundClass → **`EE_AmbientSubmix`** for the **nature layer**, so players mix nature separately and it ducks under Edge Ultimates.
- Add **`EE_Voice`** → `EE_VoiceSubmix` for future VO/announcer.
- Wire the new submixes into `BP_EE_GameInstance.ApplyAudioSettings` (extend the existing SetSubmixOutputVolume calls — same pattern, new sliders). **Keep the three-line submix approach canonical.**

### 9.3 Interactive music
- **One MetaSound Source per arena** — `MSS_Arena_<Name>` — containing WavePlayers for Intro/LoopA/LoopB/FinalRound/Edge with **sample-accurate loops**, internal **quantized crossfades**, inputs: `MusicState (EMusicState)`, `EdgeEnergy01 (float)`, `bFinalRound (bool)`, and triggers `Victory` / `Defeat`. Route to `EE_MusicSubmix`.
- **`BP_EE_MusicDirector`** (GameInstance subsystem or persistent actor component) owns the active MetaSound and exposes `SetMusicState()`, `SetEdgeEnergy(float)`, `OnRoundChanged(int, bool bFinal)`, `OnMatchEnd(bool bVictory, Name fighter)` → also fires the fighter **Fanfare**. Driven by **`BP_EE_VersusGameMode`** events already in place: BeginPlay→Intro, the EDGE meter→`SetEdgeEnergy`, round changes→`OnRoundChanged`, `OnFighterEliminated`→`OnMatchEnd`.
- **Front-end** tracks: looping MetaSound or Sound Cue via the existing spawn pattern, but **convert `PlaySound2D`→`SpawnSound2D` audio components** (per the noted "orphaned sound" fix) so the Director can crossfade across level travel instead of hard-cutting.
- **Nature beds:** separate looping sources on `EE_Ambient`, ducked by a submix send/priority when `EdgeReady`/Ultimate fires.

### 9.4 Enum
`EMusicState { Intro, Neutral, Pressure, FinalRound, EdgeReady, Victory, Defeat }` (FinalRound/EdgeReady applied as additive layers, not exclusive states).

### 9.5 UE asset naming
`MSS_Arena_<Name>`, `SC_EE_Music_*` (SoundClass), `SM_EE_*Submix`, `A_EE_<Category>_<Name>` (imported wave), `Cue_EE_<Name>`, `BP_EE_MusicDirector`. Replace placeholders: `WAV_Menu_Loop→EE_Menu_MainLoop`, `CUE_Village_Loop→EE_CharSelect`, `CUE_Battle_Loop→MSS_Arena_EucalyptusSummit`, retire `Trailer_Horns_of_War_Cue` in favor of fanfares.

---

## 10. Execution order (who does what)
1. **Composer** renders the **master theme demo** first (Title + Menu + Eucalyptus Summit stem set) so the identity is signed off before the full slate — everything else derives from it.
2. Approve identity → render remaining front-end, arenas (Summit → Colosseum), fanfares, stings.
3. Deliver per §8 (48/24 WAV, loop markers, stems, per-track sheets).
4. **Audio programmer / interactive-editor session** builds §9 (submix children, MetaSound sources, `BP_EE_MusicDirector`), wires to `BP_EE_VersusGameMode`, replaces placeholders. This is the pass **blocked on the unreal-mcp bridge from a background job** (see [[project-ee-wren-animbp]] for the same limitation) — run it from an interactive session.
5. PIE-verify: seamless loops, A⇄B crossfade, Edge/Final layers on real meter/round events, victory→fanfare hand-off, 60 FPS held, volume sliders affect all music.

---

## 11. Cross-refs
- `CANON.md` § Audio & Music — locked identity rulings.
- `CANON.md` § Visual law — "violet = Blight", "gold = honor" (the audio parallels in §2.3–2.4).
- `Docs/Project/PROJECT_STATE.md` — existing `EE_Master/EE_Music/EE_SFX` + submixes, placeholder inventory, "MCP has no create-asset tool for these."
- `Docs/02_ClaudeCode_UE5/handoff_ui_polish.md` — "wire to existing submixes; add Voice/Ambient/Menu; no parallel volume system."
- `Docs/Project/CONTROLLER_LAYOUT.md` — Edge Energy / Ultimate / rounds / ring-out are the game states the dynamic layers react to.
