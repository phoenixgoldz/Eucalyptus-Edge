# PROJECT_AUDIT.md — EUCALYPTUS EDGE · UE5.8 STATE AUDIT
**Rule of Session 1: INSPECTION ONLY. No fixes, no refactors, no "while I'm here." Log everything, touch nothing.**
Fill a copy named `PROJECT_AUDIT_RESULTS_YYYY-MM-DD.md`; save log excerpts and screenshots to an `Audit\` folder as evidence.

## Tooling notes (Claude Code / unreal-mcp :55557)
- Redirectors: `UnrealEditor-Cmd.exe <project> -run=ResavePackages -fixupredirects -projectonly -unattended` (report only — do not commit fixes this session).
- Blueprint sweep: `-run=CompileAllBlueprints` and capture warnings/errors.
- Missing refs: editor log on map load + Reference Viewer spot checks on the main maps.
- Percentages in the dashboard are the auditor's estimate — one line of justification each.

## Known prior state (from past sessions — VERIFY, may be stale)
- Main Menu (project M1) was "nearly complete."
- **Wren:** promoted `WrenKangaroo.fbx` passed checks (1.750 m, 129 bones incl. 7-bone tail chain, 92 morphs) but the **shape-key re-export was pending** — this caused the "tiny in level / stretches in PIE" bug. Confirm which FBX is actually in-engine and whether morphs are correct scale.
- **Ripper:** skeletal mesh imported; **textures did not carry through** — session ended mid material recovery.
- **Atlas:** imported upright, +X facing, ~195 cm, zero rotation offsets; `SM_WindspinePolearm` exported; sockets *planned* (`WeaponSocket_R` on hand_r, `SupportHand_IK` on the SM) — verify whether they were actually created.
- **Koda:** staff not yet modeled (deferred per canon — Wren vs. Ripper is the slice fight).
- Kiri / Banjo / Echo: in-engine status unknown — likely not imported.
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
