# EE_EdgeTheme_Mockup.mid — companion notes

**What this is:** a deterministic **MIDI sketch** ("lead sheet in MIDI form") of the core identity from `Docs/Project/MUSIC_DESIGN_BIBLE.md` — the **Edge Theme**, the **Honor Cadence**, and the **7 fighter victory fanfares**. Generated programmatically (`EE_EdgeTheme_Mockup.gen.ps1`), structure-verified as a valid Standard MIDI File.

**What this is NOT:** rendered audio, and not the final orchestration. It is a **starting skeleton** for the composer — melody, harmony, bass, and instrument *intent*. Velocities/articulations are nominal placeholders. **It was authored without auditioning** (no playback in this environment), so treat it as notation to refine, not a mix.

## File facts
- Standard MIDI File, **format 1, 7 tracks, 480 PPQ (ticks/quarter)**.
- Open in any DAW or notation app (Reaper, Cubase, Logic, Studio One, MuseScore…). Assign your orchestral libraries per track.

## Track / channel / instrument map
| Track | Ch | GM voice | Role |
| --- | --- | --- | --- |
| 1 Lead | 1 | French Horn → (per section, see below) | The melody / Edge Cell |
| 2 Strings | 2 | String Ensemble | Harmony pad |
| 3 Bass | 3 | Contrabass | Root motion |
| 4 Choir | 4 | Choir Aahs | Wonder Lift + majestic colour (vowels only) |
| 5 Timpani | 5 | Timpani | Accents (Honor Cadence, Ripper, Atlas) |
| 6 Aux | 6 | Orchestral Harp (→ Bassoon under Banjo) | Glissandi / arps / low hops |

The **Lead** track changes GM program per section to signal orchestration intent: Horn (theme) → Brass (Honor Cadence) → Horn/Trumpet/Trombone/Flute/Pizzicato/Celesta/Brass (the seven fanfares).

## Section timeline (markers are embedded in the file)
| Marker | Ticks | Key · meter · tempo | Content |
| --- | --- | --- | --- |
| The Edge Theme | 0–11 760 | D major · **6/8** · q≈116 | 8-bar theme. States the **Edge Cell (A–D–E–F#)** twice, peaks on D5, features the **Wonder Lift (F#–G#–A, Lydian)** in bar 7, plagal resolve to D. |
| Honor Cadence (Victory) | 12 480–18 240 | D · **4/4** · q≈72 | **♭VII–IV–I = C–G–D**, brass + timpani + choir, melody leaps A4→D5 (the Edge-Cell logo landing on tonic). |
| Fanfare – Koda | 18 720 | 4/4 · q≈108 | Noble French Horn, broad half-notes. |
| Fanfare – Wren | 24 480 | " | Confident staccato Trumpet, up an octave. |
| Fanfare – Ripper | 30 240 | " | Aggressive Trombone + timpani; minor-3rd (F♮) inflection that **resolves to D** (rival, not Blight — no A♭). |
| Fanfare – Kiri | 36 000 | " | Elegant Flute + Harp glissando. |
| Fanfare – Banjo | 41 760 | " | Playful Pizzicato + Bassoon hops. |
| Fanfare – Echo | 47 520 | " | Mystical Celesta + Choir + the Wonder Lift. |
| Fanfare – Atlas | 53 280–57 120 | " | Majestic Brass section + Timpani + Choir. |

## Notes for the composer
- The **6/8 lilt** is carried by the time signature; the **combat 4/4 recast** of the same pitches (per bible §2.5) is *not* in this sketch — it's a derivation to voice at scoring time.
- The **Blight Signature is deliberately absent** (this mock-up is all hopeful/heroic material). Reserve the D–A♭ tritone + detuned didgeridoo for Blightroot Hollow only, per `CANON.md` § Audio & Music.
- The **secret fighter's fanfare is intentionally omitted** — it ships under a codename and she is never named publicly.
- Regenerate/tweak via `EE_EdgeTheme_Mockup.gen.ps1` (pure PowerShell, no dependencies).

Cross-ref: `Docs/Project/MUSIC_DESIGN_BIBLE.md`, `CANON.md` § Audio & Music.
