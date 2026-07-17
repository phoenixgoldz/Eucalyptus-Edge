# VERTICAL SLICE — UI MILESTONE TRACK
**Prefix `UI-M#` to avoid collision with the frozen project milestones (M1 Main Menu → M5 Combat Prototype).**
Flow: Splash → Main Menu → Character Select → Arena Intro → Match → Victory / Ring Out.

- **UI-M1 · Component Library** — ✅ DONE (v1.0, 97 files / 14 components + Style Guide + Principles)
- **UI-M2 · Character Select in UE** — **UMG overlay layer for the Dynamic Character Select** (camera-showcase system already partially built — PHASE1_AUDIT §0/§11): nameplates, join panels, previews, ready states, controller nav, sound, particles, localization-ready text; confirm → Mode Select. Spec: `handoff_charselect.md` (paradigm-synced 2026-07-17). **Pre-step: Session 1 runs `PROJECT_AUDIT.md` (inspection only) before any build work.** ← **CURRENT**
- **UI-M3 · Main Menu** — transitions, background movie, input prompts, settings (slider components ready)
- **UI-M4 · HUD** — health, Edge, round timer, K.O., Ring Out, damage flash (Tier-1 quiet rule applies)
- **UI-M5 · Victory Flow** — winner animation, ceremonial plaque, return flow
- **UI-M6 · Complete Vertical Slice** — everything polished together, filmable for Kickstarter

## CANON LOCK (confirmed by Phoenix)
- **First vertical-slice fight:** **Wren vs. Ripper** — both fighters' weapons are already integrated into their models; Wren's pipeline is furthest along; styles contrast well (controlled boxing/mobility vs. aggressive claws/spinning pressure).
- **First arena:** Eucalyptus Summit.
- **Koda:** core fighter, deferred from the first playable fight until the staff, attachment sockets, and weapon animation set are complete.
- **Current milestone:** UI-M2 — Character Select in UE5.8.
- **Documentation:** FROZEN until implementation feedback requires a change.

**Desktop-side sync checklist (next desk session, one-line amendments):**
1. `C:\Users\Trevor\Desktop\Eucalyptus-Edge\EucalyptusEdge\handoff.md` — note slice match = Wren vs. Ripper (its top work order, Wren's shape-key FBX re-export, is unchanged and now even more critical).
2. GDD next revision — update the Combat Prototype matchup line, alongside the already-queued Sunbaked Outback rename and Mako removal confirmation.
3. Game repo README audit (already queued) — verify no stale matchup references.
