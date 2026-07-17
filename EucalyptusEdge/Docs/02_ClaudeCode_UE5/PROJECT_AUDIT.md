# PROJECT_AUDIT.md — EUCALYPTUS EDGE · UE5.8 STATE AUDIT
**Rule of Session 1: INSPECTION ONLY. No fixes, no refactors, no "while I'm here." Log everything, touch nothing.**
Fill a copy named `PROJECT_AUDIT_RESULTS_YYYY-MM-DD.md`; save log excerpts and screenshots to an `Audit\` folder as evidence.

## Tooling notes (Claude Code / unreal-mcp :55557)
- Redirectors: `UnrealEditor-Cmd.exe <project> -run=ResavePackages -fixupredirects -projectonly -unattended` (report only — do not commit fixes this session).
- Blueprint sweep: `-run=CompileAllBlueprints` and capture warnings/errors.
- Missing refs: editor log on map load + Reference Viewer spot checks on the main maps.
- Percentages in the dashboard are the auditor's estimate — one line of justification each.

## Known prior state (SYNCED 2026-07-17 from PHASE1_AUDIT.md §11 + PROJECT_STATE.md — read both FIRST; PROJECT_STATE.md is the source of truth)
- **Vertical Slice v0.1 EXISTS and is PIE-verified end-to-end**: Main Menu → Character Select → Wren/Ripper pick → LV_EucalyptusSummit → match vs AI → KO/ring-out → Results (Rematch / Character Select / Main Menu). New assets under `EE_ProjectFiles/Combat/` and `EE_ProjectFiles/CharacterSelect/`; template untouched (EE children only).
- **Dynamic Character Select is partially built**: per-fighter streamed Level Instances (`LVI_CS_Wren`, `LVI_CS_Ripper`), 5 tagged cameras with cubic view-target blends, highlight→confirm→FIGHT state machine with full Back chain. This is the canonical paradigm — NOT a flat UMG grid.
- **Main Menu (project M1) is done except button sounds**: all buttons wired, quit modal, sliding panels, MP4 video background PIE-verified, full settings framework (BP_EE_GameInstance + SaveGame, 12-row Options panel), Cinzel/Inter font pack, 60 FPS cap.
- **All seven fighters have model folders in-engine** (Koda, Kiri, Echo, Wren rigged sets; Ripper skeletal mesh + skeleton + physics + materials visible; Atlas/Banjo present — re-audit exact assets live).
- **Wren (rev 3, 2026-07-17):** morphs **DELIVERED and in engine** (six confirmed: Jaw_Open, Blink_L/R, EyeLook_L/R, Smile — 6-of-9 key-list reconciliation pending with Blender side); new Wren base/normal materials imported; dodge ×3 + heavy tail-spring takes imported and gameplay-wired (i-frames, F22 impact window). **Native playback gated on one 3-minute manual step: create `ABP_Wren` AnimBP** (UE 5.8 strict-checks skeletons on every montage path; MCP cannot create AnimBPs).
- **Ripper: still blocked on source** — desktop `RipperModel/Ripper_Tas.fbx` is a 4 KB empty export; engine runs on `Ripper_Tas_original_backup`; `Ripper_Idle_Aggressive` has no skeleton. Both fighters' **physics assets were removed in the asset churn — regenerate in-editor**.
- **Missing combat pieces** (template gaps): lock-on, block, dodge wiring, block/get-up/victory anims don't exist in the template. No IK Rig/Retargeter assets yet.
- **Koda:** staff not yet modeled (deferred per canon — Wren vs. Ripper is the slice fight).
- **Performance Standard** (permanent, in PROJECT_STATE.md): 60 FPS locked, frame-rate-independent combat, quality-before-responsiveness reduction order.
- Edge Energy *mechanics* deferred until after the vertical slice (bar art exists in the component library).

---

## 1. Project Health
- [ ] UE5.8 project opens
- [ ] No missing plugins
- [ ] No redirector issues
- [ ] No compile errors
- [ ] No Blueprint compile warnings
- [ ] No missing assets
- [ ] No broken references

## 2. Main Menu
- [ ] Opens correctly
- [ ] Background movie plays
- [ ] Controller works
- [ ] Mouse still supported if intended
- [ ] Navigation correct
- [ ] Buttons functional
- [ ] Settings opens
- [ ] Credits opens
- [ ] Exit works

## 3. Character Select
Current state: [ ] Exists · [ ] Placeholder · [ ] Production ready
Verify:
- [ ] Controller navigation
- [ ] Hover animations
- [ ] Locked slots
- [ ] Portrait updates
- [ ] Name updates
- [ ] Health preview
- [ ] Edge preview
- [ ] Fight button
- [ ] Back button

## 4. Combat
- [ ] Wren loads
- [ ] Ripper loads
- [ ] Animations play
- [ ] Movement
- [ ] Camera
- [ ] Lock-on
- [ ] Light attack
- [ ] Heavy attack
- [ ] Dodge
- [ ] Block
- [ ] Ring Out
- [ ] Win state

## 5. Arena — Eucalyptus Summit
- [ ] Loads
- [ ] Lighting
- [ ] Materials
- [ ] Collision
- [ ] Spawn points
- [ ] Camera bounds

## 6. UI
- [ ] Imported
- [ ] Correct compression (UserInterface2D)
- [ ] No mipmaps
- [ ] Materials compile
- [ ] Emissive works
- [ ] Niagara works

## 7. Characters
| Fighter | Model | Rig | Materials | Animations | Status |
| ------- | ----- | --- | --------- | ---------- | ------ |
| Wren    | ☐     | ☐   | ☐         | ☐          |        |
| Ripper  | ☐     | ☐   | ☐         | ☐          |        |
| Koda    | ☐     | ☐   | ☐         | ☐          |        |
| Kiri    | ☐     | ☐   | ☐         | ☐          |        |
| Banjo   | ☐     | ☐   | ☐         | ☐          |        |
| Echo    | ☐     | ☐   | ☐         | ☐          |        |
| Atlas   | ☐     | ☐   | ☐         | ☐          |        |

## 8. Documentation Audit — reality matches:
- [ ] CANON.md
- [ ] GDD
- [ ] README
- [ ] Style Guide
- [ ] UI Principles
- [ ] Character documentation
- [ ] Arena documentation

## 9. Technical Debt
List by severity — Critical / High / Medium / Low. For each:
```
Issue
Why it matters
Estimated fix time
Dependencies
```

## 10. End-of-session report — dashboard, then exactly three questions
| Category               | Complete |
| ---------------------- | -------: |
| Project Opens          |        ☐ |
| Main Menu              |        % |
| Character Select       |        % |
| UI Library             |        % |
| Combat                 |        % |
| Wren                   |        % |
| Ripper                 |        % |
| Koda                   |        % |
| Arenas                 |        % |
| Audio                  |        % |
| Overall Vertical Slice |        % |

1. **What is the biggest blocker?**
2. **What should we build next?**
3. **What can wait until after the vertical slice?**
