# Ripper.Heavy.TorqueRush - Move Data Spec (staged 2026-07-17)

MCP cannot create a UStruct. To finish the data-driven move definition, create ONE
row struct in-editor, then import the CSV below into a DataTable at
/Game/EE_ProjectFiles/Combat/Data/DT_Ripper_Moves.

## Step 1 - Create struct FEEMoveData (subclass of TableRowBase)
Content Browser > Blueprints > Structure. Fields (name : type):

- InputType         : Name        (Heavy)
- StartupTime       : float  s    (Coil end / Launch start)
- DirectionLockFrame: int          (frame @30fps where facing locks)
- MaxStartupSteerDeg: float  deg   (max target-facing correction during Coil)
- RootMotionAuthored: bool         (true = travel comes from montage root motion only)
- ActiveWindows     : String       (semicolon list of frame ranges, doc only)
- RecoveryTime      : float  s     (Brake+recovery tail)
- PrimaryDamage     : float
- SecondaryADamage  : float
- SecondaryBDamage  : float
- BrakeDamage       : float
- PrimaryHitstun    : float  s
- PrimaryBlockstun  : float  s
- PrimaryKnockback  : float
- SecondaryKnockback: float
- EdgeEnergyGain    : float        (Edge system not built yet - 0 placeholder)
- HitStop           : float  s
- CameraShakeScale  : float
- PrimaryParryable  : bool
- Interruptible     : bool         (true during Coil, committed after DirectionLockFrame)
- RingOutCapable    : bool
- RecoveryOnHit     : float  s
- RecoveryOnBlock   : float  s
- RecoveryOnMiss    : float  s
- AIUsageRange      : float  uu    (max approach distance AI will commit from)
- AIEdgeRiskTol     : Name         (Low/Med/High tolerance for self-ring-out)

(Row Name column = MoveID, e.g. Ripper.Heavy.TorqueRush)

## Step 2 - Import CSV as DataTable (schema = FEEMoveData), name DT_Ripper_Moves

```csv
Name,InputType,StartupTime,DirectionLockFrame,MaxStartupSteerDeg,RootMotionAuthored,ActiveWindows,RecoveryTime,PrimaryDamage,SecondaryADamage,SecondaryBDamage,BrakeDamage,PrimaryHitstun,PrimaryBlockstun,PrimaryKnockback,SecondaryKnockback,EdgeEnergyGain,HitStop,CameraShakeScale,PrimaryParryable,Interruptible,RingOutCapable,RecoveryOnHit,RecoveryOnBlock,RecoveryOnMiss,AIUsageRange,AIEdgeRiskTol
Ripper.Heavy.TorqueRush,Heavy,0.27,9,12,true,F11-15;F18-22;F25-29;F31-34,0.37,14,6,6,10,0.45,0.30,900,500,0,0.08,1.0,true,true,true,0.30,0.45,0.55,600,Low
```

STRUCTURAL/TIMING values (StartupTime, DirectionLockFrame, MaxStartupSteerDeg,
RootMotionAuthored, ActiveWindows, RingOutCapable, Interruptible, PrimaryParryable)
are derived from the APPROVED montage spec (30fps, F1-42, Coil/Launch/Maul/Brake).
DAMAGE / STUN / KNOCKBACK / HITSTOP / CAMERA / RECOVERY / AI numbers are INITIAL
PLACEHOLDERS - tune in playtest. Do not treat them as balanced.
