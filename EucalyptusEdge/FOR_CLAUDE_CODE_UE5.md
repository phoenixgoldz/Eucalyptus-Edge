# BRIEF — CLAUDE CODE (UE 5.8 TERMINAL SESSIONS)
You are the senior UE5.8 Blueprint engineer on Eucalyptus Edge (Blueprint-only, Fighter Variant template). Do not redesign; inspect, then implement the spec.

## SESSION 1 — PROJECT AUDIT (inspection only, no coding)
Run `PROJECT_AUDIT.md` end to end. Verify the known-prior-state list, fill every checkbox with evidence, produce the dashboard, and answer the three closing questions. Fixing anything — even trivial things — waits for Session 2, prioritized by the audit.

## SESSION 2 — BUILD UI-M2 (informed by the audit)
Only after the audit report exists. Task: build **UI-M2 — the gold-standard Character Select screen** — and run the doc-sync checklist.

## Read order (all in this package)
1. `..\CANON.md`
2. `PROJECT_AUDIT.md` (Session 1's entire job)
3. `..\00_StyleBible\UI_PRINCIPLES.md` (ten lines — they outrank visual preference)
4. `..\00_StyleBible\UI_STYLE_GUIDE.md` (tokens, motion timings, state law)
5. `handoff_charselect.md` (the full build spec: layout table, WBP tree, DT_Fighters, nav, FX, sound, acceptance checklist)
6. `VERTICAL_SLICE_MILESTONES.md` (context + desktop sync checklist)

## Step 0 — asset import (Session 2, if not already done by Phoenix)
Import `..\01_ImportToUnreal\*` into `Content\UI\`, preserving subfolders. Every texture: Texture Group **UI**, **NoMipmaps**, **UserInterface2D**. FX sprites (`Content\UI\FX\`) feed Niagara.
Path note: older handoffs reference `ui_v45/` for FX sprites — in this package they live at `01_ImportToUnreal\FX\`.

## Step 1 — build UI-M2 exactly per `handoff_charselect.md`
Non-negotiables: canon roster (8 rows, mystery slot NEVER named), P1 default focus Wren / P2 Ripper, full controller navigation with no focus traps, all strings as UMG Text, violet only on locked slots, emissive pulse material per Style Guide §4, ≤4 fireflies.
Definition of done = the acceptance checklist at the bottom of the handoff, ending with the gut test: screenshot beside the arena concept boards must read as the same game.

## Step 2 — doc sync (one-line amendments)
1. `C:\Users\Trevor\Desktop\Eucalyptus-Edge\EucalyptusEdge\handoff.md` → note slice match = **Wren vs. Ripper** (its Wren shape-key FBX re-export work order is unchanged and now top priority).
2. Flag for next GDD revision: matchup line update + Sunbaked Outback rename + Mako removal confirmation.
3. Game repo README audit: remove Mako/Bindi/Bramble/Tazra, add Echo and Atlas, verify no stale matchup or arena names.

## Reporting
End the session with: screenshots of the running screen (mouse, pad-focus, and locked-deny states), the acceptance checklist with pass/fail per item, and a short list of any component textures that need a re-cut (name the exact file — re-cuts are fast).
