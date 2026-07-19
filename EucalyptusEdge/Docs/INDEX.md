# EUCALYPTUS EDGE — DOCS INDEX (organized 2026-07-17)
All project documentation now lives under `Docs\`. UE folders (Content, Config, Saved…) untouched.

- `CANON.md` — every locked decision. Read first, always.
- `START_HERE.md` — the UI package deployment guide (paths inside refer to this Docs layout).
- `00_StyleBible\` — UI Principles, UI Style Guide (sampled tokens), the four approved master sheets.
- `02_ClaudeCode_UE5\` — PROJECT_AUDIT.md (Session 1: inspection only, known-state synced 2026-07-17), FOR_CLAUDE_CODE_UE5.md brief, handoff_charselect.md (paradigm-synced: UMG overlay for the Dynamic Character Select), **handoff_ui_polish.md (UI polish / accessibility / controller-integration work order — POLISH don't rebuild; filesystem widget audit + execution sequencing, captured 2026-07-18)**, **handoff_wren_animbp.md (ABP_Wren wiring spec — 41 anims confirmed + mapped to state-machine/montage buckets & controller inputs, coverage gaps flagged, captured 2026-07-18)**, VERTICAL_SLICE_MILESTONES.md, layout mock.
- `03_ClaudeDesktop_Blender\` — prop-artist brief, handoff_props.md (five heroes), handoff_ui3d.md (light rig / material law), reference renders.
- `04_Brand_EmblemDecision\` — eight candidate marks, two rounds. Decision pending.
- `Project\` — the living project record: **PROJECT_STATE.md (source of truth)**, SESSION_LOG.md (running production scoreboard, newest first), PHASE1_AUDIT.md (evidence + work logs, §0 = current directives), CLAUDE_DESKTOP_HANDOFF.md, WREN_TWIG_FIX_REPORT_2026-07-17.md (arena deformation root cause, fix, rollback), session briefings, Phase 1 roadmap, weapon-socket & facial-rigging standard, **CONTROLLER_LAYOUT.md (Phase 1 controller standard — resolved 2026-07-18, rulings in CANON § Controls)**, **MUSIC_DESIGN_BIBLE.md (Phase 1 audio identity + full soundtrack/stem/UE-audio spec — locked 2026-07-19, rulings in CANON § Audio & Music)**, legacy STYLE_GUIDE.md, COMPONENTS.md, README_UE_IMPORT.md.

UE-side import folder `01_ImportToUnreal` is not here — its textures belong in `Content\UI\` (see `Project\README_UE_IMPORT.md`).

**Ruling resolved (2026-07-17):** PROJECT_STATE.md (source of truth) requires the secret fighter present in roster data with a configurable secret/unlock flag; CANON.md and handoff_charselect are now synced to that — display stays "???" while locked, and she is never named in public-facing/marketing materials.
