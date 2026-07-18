# EUCALYPTUS EDGE — UI POLISH, ACCESSIBILITY & CONTROLLER INTEGRATION

**Work order for Claude Code (UE5). Captured 2026-07-18. Phase: functional prototype → Steam Early Access quality.**

Directive text below is authoritative. Lines marked **▶ NOTE** are Claude Code's senior annotations (audit facts, sequencing, gotchas) — they do not change the directive, they ground it. Companion doc: [`../Project/CONTROLLER_LAYOUT.md`](../Project/CONTROLLER_LAYOUT.md) (the control scheme this integrates).

---

## Prime Directive: POLISH, DON'T REBUILD

Transition existing UI from functional prototypes to production quality **without recreating any existing Widget Blueprint**. Existing widgets are preserved, cleaned up, extended, and visually polished.

**DO NOT:** create replacement widgets that duplicate existing ones · break Blueprint references · rename existing Widget Blueprints unless absolutely required · delete existing widgets · replace working menu flow.

**INSTEAD:** improve existing widgets · reuse existing animations · extend existing Blueprints · improve layout, styling, transitions, responsiveness, usability.

---

## Step 1 — Widget Audit (filesystem pass done 2026-07-18; in-editor pass PENDING)

> **▶ BLOCKER:** The `unreal-mcp` editor bridge was disconnected when this was captured. The filesystem inventory below is complete for *asset existence*, but parent classes, existing animation tracks, button lists, and property bindings can only be read with the editor open. Launch the editor with the MCP port from memory (`-ModelContextProtocolPort=8765`; XAMPP owns 8000) and complete the in-editor pass before modifying any Blueprint. **Return asset paths + internals before changing anything.**

### Widgets that EXIST → extend, do not rebuild

| Screen | Asset | Path |
| --- | --- | --- |
| Main Menu | `WBP_MainMenu` | `Content/EE_ProjectFiles/MainMenu/Widgets/` |
| Character Select | `WBP_EE_CharacterSelect` | `Content/EE_ProjectFiles/CharacterSelect/Widgets/` |
| HUD | `WBP_EE_MatchHUD` | `Content/EE_ProjectFiles/Combat/Widgets/` |
| Victory / Results | `WBP_EE_Results` | `Content/EE_ProjectFiles/Combat/Widgets/` |
| Settings row (checkbox) | `WBP_EE_Row_Check` | `Content/EE_ProjectFiles/Framework/Widgets/` |
| Settings row (dropdown) | `WBP_EE_Row_Dropdown` | `Content/EE_ProjectFiles/Framework/Widgets/` |
| Settings row (slider) | `WBP_EE_Row_Slider` | `Content/EE_ProjectFiles/Framework/Widgets/` |

> **▶ NOTE:** The three `WBP_EE_Row_*` components are the Accessibility tab's building blocks — every accessibility setting should compose from these, not new bespoke rows.

### Reuse anchors (answer gaps the work order leaves open)

| Need | Existing asset — reuse it | Path |
| --- | --- | --- |
| Settings persistence (remap + a11y) | `BP_EE_SettingsSave` (SaveGame) | `Content/EE_ProjectFiles/Framework/` |
| Audio volume control | `EE_Master`, `EE_MusicSubmix`, `EE_SFXSubmix` | `Content/EE_ProjectFiles/Audio/` |
| Large Text / UI scale typography | `EE_Font_Title/Header/Body/Button/Small` | `Content/EE_ProjectFiles/Framework/Fonts/` |
| Game-wide state | `BP_EE_GameInstance` | `Content/EE_ProjectFiles/Framework/` |
| Match camera (shake/sensitivity a11y) | `BP_EE_MatchCamera`, `BP_EE_MatchPlayerController` | `Content/EE_ProjectFiles/Combat/` |

> **▶ NOTE:** Do **not** author a new save system, submix graph, or font set — extend the above. The Audio tab may need to *add* Voice/Ambient/Menu submixes (only Master/Music/SFX exist today), routed under the existing master.

### Screens that DO NOT yet exist → net-new (this is NOT "rebuilding")

`Options container` · `Pause Menu` · `Mode Select` · `Stage Select` · `Controller Remapping UI`. Only a Pause *button texture* (`T_UI_IconBtn_Pause_*`) and the settings *row* parts exist. Creating these fresh is fully consistent with "don't rebuild" — there is nothing to rebuild.

> **▶ CONFIRM IN EDITOR:** any of these may already live as a sub-panel/switcher *inside* `WBP_MainMenu` (common UMG pattern). Verify before creating a standalone asset, to avoid the exact duplication the Prime Directive forbids.

---

## Recommended Execution Order (senior sequencing)

The work order lists tasks flat; execute them in dependency order — foundation before polish:

1. **Finish the in-editor audit** (gate — nothing else starts until internals are known).
2. **Enhanced Input remapping foundation + controller profiles** — the spine everything else hangs on.
3. **Settings framework + persistence** — extend `BP_EE_SettingsSave`; wire the accessibility rows to it. Nothing sticks without this.
4. **Accessibility tab** inside the existing Options (compose `WBP_EE_Row_*`).
5. **HUD polish** (`WBP_EE_MatchHUD`).
6. **Character Select polish** (`WBP_EE_CharacterSelect`).
7. **Global controller navigation + animation/perf pass** (all widgets).

Rationale: remapping and persistence are *foundational* — they change data models the polish surfaces read from. Polishing visuals first means reworking them after the input/settings layer lands.

---

## Character Select Polish — extend `WBP_EE_CharacterSelect`

- **Cards:** better spacing · animated hover · stronger highlight glow · Edge-Energy-themed borders · portrait transitions.
- **On select:** camera smoothly moves to fighter · fighter plays idle anim · name animates in · weapon name · fighting style · home region in Verdantia · short description fades in.
- **Ready indicator:** ready stamp · controller assignment · color feedback · character-lock animation.
- **Dynamic background (keep the Verdantia landscape system — do not replace):** improve camera transitions, lighting, Niagara particles, clouds, water, wind, leaves.

> **▶ NOTE:** Idle anims exist to drive this — `EE_Seq_WrenIdle`, `EE_Seq_RipperIdle`, and per-character `ABP_*`. "Home region in Verdantia" strings are new content; source them from roster data, not hardcoded in the widget.
> **▶ CANON GUARDRAIL:** card borders/glow use the chartreuse-emerald `#AED92D` family for hover/energy and gold for honor. **Violet is reserved for Blighted/locked only** — the "???" secret slot stays locked/hidden and is never named (see `CANON.md`).

---

## HUD Polish — extend `WBP_EE_MatchHUD`

- **Health:** better damage animation · smooth interpolation · better gradients.
- **Edge Meter:** smooth fill · glow at full · Ultimate pulse.
- **Player portrait:** better framing · character color accent.
- **Round counter:** better transitions. **Timer:** cleaner typography.
- **Hit sparks:** better Edge-Energy flashes. **Ring Out:** better announcement animation. **KO:** better cinematic presentation.

> **▶ NOTE:** Splash callouts (K.O., RING OUT…) are baked English art per CANON — animate their presentation, don't convert them to UMG text. All *other* HUD strings stay localizable UMG Text.
> **▶ PERF:** health/meter must update **event-driven** (push on damage/energy change), not via per-frame property bindings — see Performance below.

---

## Accessibility — a tab **inside the existing Options** (never a second Options system)

### Controller Remapping + Profiles

Full rebind of **every** gameplay + menu action: Movement · Camera · Lock Target · Light/Medium/Heavy Attack · Block · Parry · Dodge · Dash · Edge Ability · Ultimate · Pause · Menu Confirm/Cancel · Navigation · Character Select · Training shortcuts. Support Xbox, PlayStation, and an architecture ready for **Switch** and **Steam Input**.

**Multiple controller profiles (high-value, ship in Phase 1):** savable presets — "Default", "Southpaw", "Soulcalibur", "Smash-style", plus fully custom. Since the game is controller-first, this gives flexibility without touching core controls and smooths local 2P when players prefer different layouts (each player selects a profile independently).

> **▶ ARCHITECTURE NOTE (Enhanced Input):**
> - Build on UE **Enhanced Input** (`InputAction` + `InputMappingContext`). Model each **profile as a saved set of Player-Mappable Key overrides** (or a swappable IMC) persisted in `BP_EE_SettingsSave`.
> - **Gotcha — chorded actions:** the control scheme uses modifier chords heavily (`RB + Face` → Edge Light/Medium/Ultimate/Mobility; `Forward + Dodge` → Combat Leap). UE's Player-Mappable Keys system rebinds simple 1:1 bindings cleanly but **does not natively expose chord/modifier combos to a remap UI**. Plan a custom remap layer for chorded actions, or forbid rebinding the modifier itself and only rebind the base keys. Decide this early — it shapes the whole remap UI.
> - Keep gameplay logic bound to **abstract action names**, never physical buttons — that is what makes Switch/Steam Input backends drop in later, and it prevents Steam Input from double-driving native input.
> - **Cross-link:** the "Toggle / Hold" accessibility option below is the resolution mechanism for `CONTROLLER_LAYOUT.md` Open Question #3 (lock-on toggle vs hold) — make lock/block/dash toggle-or-hold per-action settings.

### Accessibility Options

- **Gameplay:** button remapping · toggle/hold · input-buffer window · vibration on/off + intensity · camera-shake intensity · hit-stop intensity · target-lock assist · camera auto-reset · camera sensitivity · invert camera · dead zones · analog response curve · double-tap timing.
- **Visual:** HUD scale · HUD opacity · UI scale · subtitle size · subtitle background · high-contrast HUD · large-text mode · damage-number size · hit-flash intensity · reduce screen shake · reduce flashing · reduce motion · colorblind modes (Protanopia / Deuteranopia / Tritanopia) · custom color presets · crosshair color (future) · Edge-Meter color override · player outline colors.
- **Audio:** master · music · SFX · voice · ambient · menu · controller speaker (future) · mono audio · dynamic range · subtitle language · subtitle speaker names.
- **Difficulty assist (Training only):** input display · frame data · hitboxes · invulnerability display · combo counter · damage numbers · AI difficulty · training-dummy behavior · frame advance · slow motion.

> **▶ EARLY-ACCESS TIERING:** ship-first baseline (some are console-cert / legal-relevant): **remapping, colorblind modes, reduce flashing, reduce motion, subtitle size, HUD/UI scale, vibration toggle.** Defer: controller speaker, crosshair color, custom color-preset editor. Build the *framework* to hold all of them; populate in tiers.
> **▶ CANON GUARDRAIL:** color-override options (Edge-Meter color, player outlines, custom presets) must keep **violet = Blighted/locked** semantics intact and not collide with the chartreuse-emerald energy language. Colorblind palettes must preserve those *meanings*, not just swap hues.
> **▶ AUDIO:** wire volume sliders to the existing submixes; add Voice/Ambient/Menu submixes under `EE_Master` if missing. Do not introduce a parallel volume system.

---

## Controller Navigation (every menu)

Full controller/keyboardless operation on Xbox, PlayStation, Steam Controller. Proper focus navigation · no dead ends · no hidden focus · automatic wrap · proper sounds · proper transitions. No mouse required (KB/M is dev/debug only).

---

## Animation Polish (improve existing timelines — do not recreate)

Fade · scale · slide · highlight · selection · confirmation · ready · round start · pause · resume · victory · defeat. Reuse and refine timelines already present in each widget.

---

## Performance

Avoid `Tick`. Prefer: event-driven updates · bindings **only where genuinely needed** · widget animations · timers · Invalidation Panels · Retainer Boxes where appropriate. No duplicate widgets / HUD / menu systems.

> **▶ NOTE:** UMG property *bindings* are themselves evaluated every frame (Tick-like) — "avoid Tick" and "use bindings" are in tension. The genuinely performant path is **push/event-driven** updates (health, meter, timer push on change) wrapped in Invalidation Panels; reserve property bindings for values that truly change most frames.

---

## Deliverables

1. Widget audit (asset paths — filesystem pass above; **+ in-editor internals**) 2. Modified-widget list 3. Accessibility implementation 4. Controller remapping + profiles implementation 5. HUD improvements 6. Character Select improvements 7. Performance improvements 8. Any Blueprint references changed 9. Screenshots.

> **▶ DELIVERABLE REALITY:** screenshots are producible in-editor once MCP is reconnected. A **walkthrough video** is not something this agent can render — substitute a scripted capture checklist or a sequence of screenshots per flow. Set expectations accordingly.

**Goal:** players recognize the current interface immediately, but experience it at production quality suitable for Steam Early Access. Polish what exists; do not redesign.
