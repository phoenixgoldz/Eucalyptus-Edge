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
Selectable: Koda, Wren, Kiri, Ripper. Story-locked: Banjo, Echo, Atlas. Slot 8: the **"???" mystery challenger — intentionally unnamed in ALL data, UI, asset names, and documentation. No exceptions.**
Mako, Bindi, Bramble, and Tazra must not appear in any material, ever.

## Arena naming
"Sunbaked Outback" (not "Red Dune Outpost") and "Edge Festival Colosseum" (not "Grounds") are canonical. The GDD's matchup line, the Sunbaked rename, and the Mako-removal confirmation are queued for the next GDD revision.

## Visual law (from UI_PRINCIPLES.md + Style Guide)
- Decoration hierarchy: HUD < Menu < Character Select < Victory.
- **Violet always means Blighted/locked.** Disabled = desaturated, never violet.
- Hover/energy glow uses the sampled chartreuse-emerald (#AED92D family); gold = honor; every crystal emits Edge Energy; magic is subtle — alive, never distracting.
- All player-facing strings are UMG Text (localizable). Splash callouts (K.O., RING OUT…) are baked art and stay English.

## Documentation state
FROZEN. Changes only when implementation feedback requires them, and every change syncs across: this package, the desktop `handoff.md`, the GDD, and the repo README.
