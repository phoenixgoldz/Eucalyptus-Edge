# EUCALYPTUS EDGE — Session Handoff Briefing
**For: any Claude instance (Claude Desktop w/ Blender MCP, or Claude Code w/ unreal-mcp) · From: the claude.ai project planning session · Date: 2026-07-13**
**⚠ INTERNAL — contains unannounced content (see SPOILER section). Never commit this file, or anything it marks internal, to the public GitHub repo.**

---

## Who you're working with & your role
Phoenix (Trevor Hicks), founder of **PhoenixGold Game Studios**. You are joining as the **senior Unreal Engine technical assistant** on **Eucalyptus Edge** — a family-friendly, weapon-based 3D arena fighter (Soulcalibur-inspired) set in Verdantia, a magical Australia-inspired world. **Unreal Engine 5.8, Blueprint-only**, built on the **Fighter Variant template**. Live Kickstarter; the #1 conversion gap is the absence of real gameplay footage.

**Standing rules — follow these exactly:**
1. Preserve the established vision. **Never redesign anything without asking first.**
2. Documentation is **FROZEN at GDD v2.3** until the first playable slice exists. Do not edit or regenerate design docs; the prototype is now the source of truth.
3. Inspect before editing (read-only first). Work in small steps, save often, and list every asset you create or modify.
4. If anything is ambiguous or a path can't be found, **ask Phoenix — never guess.**
5. Before acting, search/read the current project state: the UE 5.8 project folder, `PHASE1_AUDIT.md` if it exists, and this briefing.

---

## FROZEN CANON (GDD v2.3 — do not alter)

**Phase 1 roster — seven fighters, all Australia-region:**

| Fighter | Species | Weapon / Style | Height | Status |
|---|---|---|---|---|
| Koda | Koala | Eucalyptus Staff — balanced | 160 cm | Starter |
| Wren | Kangaroo | Kicks/gloves — mobile bruiser, ring-out pressure | 180 cm | Starter |
| Kiri | Kookaburra | Boomerang — precision duelist, aerial | 150 cm | Starter |
| Ripper | Tasmanian Devil | Natural claws — aggressive brawler | 158 cm | Starter |
| Banjo | Sugar Glider | Vine Whip Grappler — acrobatic aerial | 140 cm | Unlock: defeat Blighted Banjo (Story) |
| Echo | Platypus | Ice Crystal Tonfas — Crystal Tonfa Specialist, ice kit | 155 cm | Unlock: defeat Blighted Echo (Story) |
| Atlas | Emu | Windspine Polearm | 190 cm | Unlock: defeat Blighted Atlas (Story) |

**Removed / archived:** **Mako — permanently removed from the franchise** (deletion from docs queued for v2.4, post-slice; do not build, reference, or resurrect him). Bindi — cut (model complexity). Bramble (165 cm) & Tazra (152 cm) — archived concepts only.

**Heights are canonical** (heel-to-crown, A/T-pose, centimeters). **Every FBX imports into UE at 1.0 scale** — wrong-sized models get resized once in Blender before export, never scaled in-engine.

**Arenas (8 canon):** Eucalyptus Summit (Phase 1) · Crystal Caverns (Phase 1) · Moonlit Rainforest (planned) · **Edge Festival Colosseum** (planned — canonical name; the site's "Edge Festival Grounds" is pending rename) · Bamboo Harbor (future) · Frostpine Ridge (future) · Blightroot Hollow (future, concept art needed) · **Sunbaked Outback** (future, concept art needed — "Land of endurance and unyielding spirit"; formerly Red Dune Outpost, and it is **Sunbaked**, not "Sunbreak").

**Core systems canon:** Edge Energy (meter built by attacking/blocking/dodging/combos/surviving → specials & ultimates) — **deferred until after the slice**. The Blight (purify Blighted champions to unlock them). Ring-out victories. Family-friendly, no blood/gore. Color language: green = life/Edge, violet = loss/Blight.

### 🔒 SPOILER — internal only, never public
**Sonia** — secret unlockable fighter. **White Tiger, 175 cm.** She exists to tease **DLC 1: an India-inspired region** (more fighters/arenas from that region alongside her). She must **never** appear in the public repo, README, official site, or Kickstarter. The GitHub repo (`phoenixgoldz/Eucalyptus-Edge`) **is public** — keep her storyboards and all DLC material out of it. The GDD (any version) also stays out of the public repo because its Appendix A contains her.

---

## Current status (do not redo)
Done: UE 5.8 project created on the Fighter Variant template · main menu level built with animated MP4 background and redesigned layout · most character models imported as FBX at consistent scale · arena concepts finalized · GDD v2.3 frozen · README replacement drafted · Reveal Cinematic patched to v1.1 (Echo = tonfas, Atlas = polearm, "Atlus"→"Atlas") · Kickstarter live · site largely updated.

Pending public cleanup (Phoenix's queue, not yours unless asked): commit the new README · rename `AtlusRedesign.png`→`AtlasRedesign.png` (+ site img src) · site: "Grounds"→"Colosseum", add Sunbaked Outback hotspot/card · replace cinematic v1 with v1.1 in `Docs/`.

---

## Environment map (this machine: "pheonixdesktop")
- **Claude Desktop (Microsoft Store/MSIX build)** drives **Blender 5.1** via `ahujasid/blender-mcp` (`uvx blender-mcp` client + addon socket server on `localhost:9876`). The addon must be **started manually each Blender session** via the N-panel → BlenderMCP tab unless auto-start was configured. Config lives at the **non-standard Store path**: `C:\Users\Trevor\AppData\Local\Packages\Claude_pzs8sxrjxfjjc\LocalCache\Roaming\Claude\` (env block includes `DISABLE_TELEMETRY: "true"`). Do **not** run `uvx blender-mcp` manually in PowerShell — it blocks Desktop's own server. If the connection misbehaves: check the log at the Store path, match addon ↔ pip package versions, and fully restart both apps (stale socket threads were a repeat offender).
- **Two Blender installs exist** (Steam on `E:\SteamLibrary` + standalone blender.org, both 5.1, sharing one config dir). Unit settings are **per-file** — use a template `.blend` with the settings below rather than trusting defaults.
- **Claude Code** (CLI at `C:\Users\Trevor\.local\bin\claude.exe`, on PATH) drives **UE 5.8** via self-hosted `chongdashu/unreal-mcp` on **TCP 55557**. Setup kit with slash commands (`/unreal-engine-mcp-setup`, `/build`) lives at `C:\Users\Trevor\Downloads\claude-unreal-mcp\`. Launch Claude Code **from the UE project root**.
- **MCP disconnect procedure:** save the project → close Unreal → restart the MCP server → reopen Unreal → verify the connection **before** resuming any prompt.

---

## TONIGHT'S WORKFLOW — do this, in order

### A. Blender (Claude Desktop + Blender MCP)
Verify the addon socket first with a trivial command, then for **Ripper (158), Atlas (190), Banjo (140), Wren (180)**:
1. Scene Properties → Units: **Metric**, Unit Scale **0.01**, Length **Centimeters** (1 BU = 1 UE cm). Set up once in a template `.blend`.
2. Resize each fighter to canonical height **before rigging** — never rescale a finished rig.
3. `Ctrl+A` → **Apply All Transforms** (scale must read 1.0).
4. Character faces **−Y** in Blender (forward = +X in Unreal).
5. Export FBX: Scale **1.00**, Apply Scalings = **FBX Units Scale**; Armature: **Add Leaf Bones OFF**, Only Deform Bones ON; **Selected Objects** only (mesh + armature).
- **Ripper × AccuRig** is a known fight (stocky/short-limbed proportions): one welded skin, clean A/T-pose, tail/props detached, drag joint markers manually (hips/shoulders). If it still fails → fall back to a Blender rig + UE IK Retargeter, and send Phoenix's screenshot to the claude.ai project chat first.

### B. Unreal (manual)
Import the four FBX at **Import Uniform Scale 1.0**, Convert Scene ON. Sanity check: **Atlas ≈ 190 cm** in viewport bounds (if 1.9 or 19,000, the unit step was skipped). Verify skeletons. If correct, never touch scales again.

### C. Claude Code (unreal-mcp)
1. Run **Prompt A** (below) → generates `PHASE1_AUDIT.md`. Read-only; safe anytime.
2. Review the audit for surprises.
3. **Git commit checkpoint** — mandatory before any Blueprint edits.
4. Run **Prompt B** (below) → finish the Main Menu (M1).

### D. Report back
Upload `PHASE1_AUDIT.md` (and the AccuRig screenshot if needed) to the **claude.ai Eucalyptus Edge project chat**, where the audit gets turned into the template-modification plan (free 3D movement, lock-on camera, ring-out volumes) and the M2–M5 build order: Character Select → Mode Select → Eucalyptus Summit → **Koda vs. Ripper playable** → first gameplay capture. Only Koda's **Eucalyptus Staff** needs modeling for the slice — Ripper fights with claws.

---

## APPENDIX — Prompt A (read-only audit)
```
You are auditing my Unreal Engine 5.8 project "Eucalyptus Edge" — Blueprint-only, built on the Fighter Variant template — using the unreal-mcp tools (server on TCP 55557). This is a READ-ONLY audit: do not create, modify, rename, or delete anything. If the MCP connection fails or tools are missing, stop and tell me — do not guess or answer from memory.

1. Enumerate all assets under /Game. Group Blueprints by: GameModes & GameStates; Characters/Pawns; ActorComponents; UMG Widgets; Animation Blueprints, Montages & Blend Spaces; Levels/Maps; Enhanced Input (Mapping Contexts + Input Actions); DataTables/Data Assets; Niagara systems. Note which folders belong to the Fighter Variant template versus custom work.

2. Open the default GameMode and the playable fighter Blueprint(s). List components, key variables, and event-graph entry points (BeginPlay, input handlers, damage/hit events).

3. Describe how the template implements: movement (is it plane-constrained? what camera rig?), attacks (montage-driven? hit detection method?), blocking, dodging, health/damage, round or match flow, and HUD. Flag the two assumptions we must break for a 3D arena fighter: any movement-plane constraint, and the absence of ring-out volumes.

4. Search asset names and variables for: MainMenu, CharacterSelect, ModeSelect, Edge, Meter, RingOut, KO, Victory, Round, Lore, Credits, Options.

5. List imported skeletal meshes, their Skeleton assets, and any IK Rig / IK Retargeter assets. Flag which of the seven roster fighters (Koda, Kiri, Wren, Ripper, Banjo, Echo, Atlas) have meshes in-project — Ripper, Atlas, Banjo, and Wren FBX are pending import.

6. Write PHASE1_AUDIT.md in the project root: a table mapping every M1–M5 line item below to Done / Partial / Missing / Template-provided, with exact asset paths as evidence.
   M1 Main Menu: Play, Lore, Options, Credits, Exit wiring; widget animations; controller navigation; transitions; button sounds; input locking; focus handling.
   M2 Character Select: screen exists; roster data source; P2 join; portraits; ready-up.
   M3 Mode Select: Training; Local Versus; disabled Online entry.
   M4 Eucalyptus Summit level.
   M5 Combat: movement; camera; lock-on; health; light attack; heavy attack; block; dodge; ring-out; win screen.

7. Finish with a "shortest path to playable" list: the five smallest changes that make Koda vs. Ripper playable end-to-end in Eucalyptus Summit.
```

## APPENDIX — Prompt B (Milestone 1: Main Menu — run after audit + git checkpoint)
```
Using the unreal-mcp tools on my UE 5.8 Blueprint-only project "Eucalyptus Edge", complete Milestone 1: the Main Menu. Ground every step in what PHASE1_AUDIT.md and the live project actually contain — inspect before editing. Rules: never rename or delete existing assets; create anything new under /Game/EucalyptusEdge/UI/; work in small steps and save after each one; if something is ambiguous, ask me instead of guessing.

Tasks, in order:
1. Wire the five buttons. Play -> open the Character Select level/widget if one exists, otherwise create a placeholder CharacterSelect widget (title + "Back") and wire to that. Lore, Options, Credits -> open their panels; create simple placeholder panels if missing (each with a Back button returning focus to the menu). Exit -> Quit Game (with a small confirm dialog).
2. Focus handling: on menu open, set input mode UI Only, and set keyboard/gamepad focus to the Play button. Ensure Back/B returns to the main column from any panel.
3. Controller navigation: verify up/down navigation order Play -> Lore -> Options -> Credits -> Exit, and explicit navigation rules so focus never escapes the widget.
4. Input locking: during any widget transition animation, disable all menu buttons; re-enable when the transition completes. No double-activation.
5. Widget animations & transitions: add subtle hover/focus scale or glow animations per button, and fade/slide transitions between the main column and each panel. Keep timings short (0.15–0.3s).
6. Button sounds: hook hover and confirm sounds. If no audio assets exist, create placeholder Sound Cues / MetaSounds with clearly-named TEMP_ prefixes so they're easy to replace.
7. Verify the animated MP4 background still plays behind everything and survives panel transitions.
8. Finish by listing every asset created or modified, and update PHASE1_AUDIT.md's M1 rows to their new status.
```
