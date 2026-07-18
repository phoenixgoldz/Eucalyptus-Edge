# EUCALYPTUS EDGE — CANON LOCKS (as of this package)
Both Claude sessions read this before anything else. These override any conflicting older text.

## Vertical slice
- **First playable fight: Wren vs. Ripper.** First arena: **Eucalyptus Summit**.
- Koda remains a core starting fighter but is **deferred from the first playable fight** until his staff, attachment sockets, and weapon animation set are complete.
- Character Select defaults: P1 focus = Wren, P2 focus = Ripper; Fight! saves selections and loads Eucalyptus Summit.

## Milestones
- **UI track:** UI-M1 Component Library ✅ → **UI-M2 Character Select in UE5.8 (CURRENT)** → UI-M3 Main Menu → UI-M4 HUD → UI-M5 Victory Flow → UI-M6 Complete Vertical Slice.
- The `UI-M#` prefix exists to avoid collision with the frozen full-project milestones (M1 Main Menu → M5 Combat Prototype). Never mix the two numbering systems.

## Roster (Character Select grid, exactly eight slots)
Selectable: Koda, Wren, Kiri, Ripper. Story-locked: Banjo, Echo, Atlas. Slot 8 (**RULING SYNCED 2026-07-17 from PROJECT_STATE.md, which supersedes the earlier "never named in data" line**): **Sonia the White Tigress** — present in roster data as a secret entry with a configurable unlock flag (Twin Crescent Chakrams, white fur, orange-and-gold accents); the UI displays **"???"** and keeps the slot hidden/locked until her unlock condition is met. She is **never named in any public-facing or marketing material**; prefer codename asset filenames where practical to limit datamining.
Mako, Bindi, Bramble, and Tazra must not appear in any material, ever.

## Arena naming
"Sunbaked Outback" (not "Red Dune Outpost") and "Edge Festival Colosseum" (not "Grounds") are canonical. The GDD's matchup line, the Sunbaked rename, and the Mako-removal confirmation are queued for the next GDD revision.

## Visual law (from UI_PRINCIPLES.md + Style Guide)
- Decoration hierarchy: HUD < Menu < Character Select < Victory.
- **Violet always means Blighted/locked.** Disabled = desaturated, never violet.
- Hover/energy glow uses the sampled chartreuse-emerald (#AED92D family); gold = honor; every crystal emits Edge Energy; magic is subtle — alive, never distracting.
- All player-facing strings are UMG Text (localizable). Splash callouts (K.O., RING OUT…) are baked art and stay English.

## Controls (Phase 1 — resolved 2026-07-18; full spec `Docs/Project/CONTROLLER_LAYOUT.md`)
- **Face:** X/□ Light · Y/△ Medium · B/○ Heavy · A/✕ Dodge. **RB = Edge modifier** (RB+X/Y/B/A = Edge Light / Edge Medium / Ultimate / Mobility Skill; Ultimate needs a full meter).
- **Grab = Guard + Attack**, never on the RB layer: **LB+Light = universal throw** (doubles as a ring-out tool), **LB+Heavy = character command grab**.
- **Pause = Menu (Xbox) / Options (PS)** — reserved; no gameplay action may ever bind to it.
- **Lock-on:** auto-locked at round start (1v1); **L3 = canonical toggle**; LT = momentary hold override; toggle-vs-hold is an Accessibility setting.
- **Dodge** = Back/Left/Right + neutral spot-dodge; **no forward dodge** (Forward+A = Combat Leap; grounded forward = Dash/RT). No dedicated jump button.
- **LB tap-vs-hold:** fresh LB press ≤4f before a hit = **Perfect Parry** (no Edge cost); held 5–8f = **Perfect Guard**; older hold = Normal Block. Cannot parry from a held guard. Frame values tunable; input assignments locked.
- Controller-first; full remapping + saved **profiles** (Default / Southpaw / Soulcalibur / Smash-style / custom) — see `Docs/02_ClaudeCode_UE5/handoff_ui_polish.md`.

## Documentation state
FROZEN. Changes only when implementation feedback requires them, and every change syncs across: this package, the desktop `handoff.md`, the GDD, and the repo README.
