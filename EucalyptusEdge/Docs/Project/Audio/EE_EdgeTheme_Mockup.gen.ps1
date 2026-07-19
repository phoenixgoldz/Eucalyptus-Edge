# Eucalyptus Edge - Edge Theme MIDI mock-up generator (pure PowerShell, no deps)
$ErrorActionPreference = "Stop"

function To-VLQ([int]$value){
  $buffer = $value -band 0x7F
  $out = New-Object System.Collections.ArrayList
  while(($value -shr 7) -gt 0){
    $value = $value -shr 7
    $buffer = ($buffer -shl 8) -bor (($value -band 0x7F) -bor 0x80)
  }
  while($true){
    [void]$out.Add([byte]($buffer -band 0xFF))
    if(($buffer -band 0x80) -ne 0){ $buffer = $buffer -shr 8 } else { break }
  }
  return ,([byte[]]$out.ToArray())
}
function BE32([int]$n){ return ,([byte[]]@([byte](($n -shr 24)-band 0xFF),[byte](($n -shr 16)-band 0xFF),[byte](($n -shr 8)-band 0xFF),[byte]($n -band 0xFF))) }
function MetaTempo([int]$bpm){ $us=[int](60000000/$bpm); return [byte[]]@(0xFF,0x51,0x03,[byte](($us -shr 16)-band 0xFF),[byte](($us -shr 8)-band 0xFF),[byte]($us -band 0xFF)) }
function MetaTimeSig([int]$nn,[int]$dd){ return [byte[]]@(0xFF,0x58,0x04,[byte]$nn,[byte]$dd,0x18,0x08) }
function MetaText([int]$type,[string]$s){ $tb=[System.Text.Encoding]::ASCII.GetBytes($s); $r=New-Object System.Collections.Generic.List[byte]; $r.Add(0xFF); $r.Add([byte]$type); $r.AddRange((To-VLQ $tb.Count)); $r.AddRange($tb); return ,([byte[]]$r.ToArray()) }

$chanOf = @{1=0;2=1;3=2;4=3;5=4;6=5}
$events = @{}
0..6 | ForEach-Object { $events[$_] = New-Object System.Collections.ArrayList }
function AddEv([int]$trk,[int]$abs,[int]$ord,[byte[]]$bytes){ [void]$events[$trk].Add([pscustomobject]@{t=$abs;ord=$ord;b=$bytes}) }
function AddNote([int]$trk,[int]$start,[int]$dur,[int]$note,[int]$vel){ $ch=$chanOf[$trk]; AddEv $trk $start 5 ([byte[]]@([byte](0x90 -bor $ch),[byte]$note,[byte]$vel)); AddEv $trk ($start+$dur) 1 ([byte[]]@([byte](0x80 -bor $ch),[byte]$note,[byte]0)) }
function AddProg([int]$trk,[int]$t,[int]$prog){ $ch=$chanOf[$trk]; AddEv $trk $t 3 ([byte[]]@([byte](0xC0 -bor $ch),[byte]$prog)) }
function AddChord([int]$trk,[int]$start,[int]$dur,[int[]]$notes,[int]$vel){ foreach($n in $notes){ AddNote $trk $start $dur $n $vel } }

# ---- Conductor (track 0) ----
AddEv 0 0 0 (MetaText 3 "Eucalyptus Edge - Edge Theme Mockup")
AddEv 0 0 1 ([byte[]]@(0xFF,0x59,0x02,0x02,0x00))   # key sig: D major
AddEv 0 0 2 (MetaTimeSig 6 3)                        # 6/8
AddEv 0 0 4 (MetaTempo 116)
AddEv 0 0 3 (MetaText 6 "The Edge Theme")
# track names
AddEv 1 0 0 (MetaText 3 "Lead");  AddEv 2 0 0 (MetaText 3 "Strings"); AddEv 3 0 0 (MetaText 3 "Bass")
AddEv 4 0 0 (MetaText 3 "Choir"); AddEv 5 0 0 (MetaText 3 "Timpani"); AddEv 6 0 0 (MetaText 3 "Aux Harp-Celesta")
# programs
AddProg 1 0 60; AddProg 2 0 48; AddProg 3 0 43; AddProg 4 0 52; AddProg 5 0 47; AddProg 6 0 46

# ================= SECTION 1: THE EDGE THEME (6/8) =================
# Melody (Edge Cell A-D-E-F#, development, Wonder Lift, resolve)
AddNote 1 0 240 57 82
AddNote 1 240 480 62 88; AddNote 1 720 240 64 82; AddNote 1 960 480 66 88; AddNote 1 1440 240 69 84
AddNote 1 1680 720 71 86; AddNote 1 2400 240 69 80; AddNote 1 2640 480 66 84
AddNote 1 3120 480 64 82; AddNote 1 3600 240 66 82; AddNote 1 3840 480 67 84; AddNote 1 4320 240 66 82
AddNote 1 4560 960 64 80
AddNote 1 5760 240 57 82
AddNote 1 6000 480 62 90; AddNote 1 6480 240 64 84; AddNote 1 6720 480 66 90; AddNote 1 7200 240 69 86
AddNote 1 7440 240 71 86; AddNote 1 7680 240 73 86; AddNote 1 7920 480 74 92; AddNote 1 8400 240 71 84; AddNote 1 8640 240 69 82
AddNote 1 8880 240 66 82; AddNote 1 9120 240 68 84; AddNote 1 9360 480 69 88; AddNote 1 9840 240 71 84; AddNote 1 10080 240 69 82
AddNote 1 10320 480 66 84; AddNote 1 10800 240 64 80; AddNote 1 11040 720 62 86
# Strings (chords per bar)
AddChord 2 240 1440 @(50,54,57) 60; AddChord 2 1680 1440 @(47,50,54) 58; AddChord 2 3120 1440 @(43,47,50) 58; AddChord 2 4560 1440 @(45,49,52) 58
AddChord 2 6000 1440 @(50,54,57) 62; AddChord 2 7440 720 @(47,50,54) 60; AddChord 2 8160 720 @(43,47,50) 60; AddChord 2 8880 1440 @(45,49,52) 62
AddChord 2 10320 480 @(43,47,50) 60; AddChord 2 10800 960 @(50,54,57) 64
# Bass
AddNote 3 240 1440 38 70; AddNote 3 1680 1440 35 70; AddNote 3 3120 1440 31 70; AddNote 3 4560 1440 33 70
AddNote 3 6000 1440 38 70; AddNote 3 7440 720 35 70; AddNote 3 8160 720 31 70; AddNote 3 8880 1440 33 70
AddNote 3 10320 480 31 70; AddNote 3 10800 960 38 70
# Choir (Wonder Lift + resolve)
AddChord 4 8880 1440 @(57,64) 48; AddChord 4 10320 1440 @(54,62) 46

# ================= SECTION 2: HONOR CADENCE (4/4, victory) =================
AddEv 0 12480 2 (MetaTimeSig 4 2); AddEv 0 12480 4 (MetaTempo 72); AddEv 0 12480 3 (MetaText 6 "Honor Cadence (Victory)")
AddProg 1 12480 61
AddNote 1 12480 960 64 88; AddNote 1 13440 960 67 90
AddNote 1 14400 960 66 88; AddNote 1 15360 960 69 92
AddNote 1 16320 1920 74 98
AddChord 2 12480 1920 @(48,52,55) 66; AddChord 2 14400 1920 @(43,47,50) 66; AddChord 2 16320 1920 @(50,54,57,62) 72
AddNote 3 12480 1920 36 78; AddNote 3 14400 1920 31 78; AddNote 3 16320 1920 38 78
AddChord 4 16320 1920 @(62,66,69) 58
AddNote 5 12480 360 36 80; AddNote 5 16320 240 38 95; AddNote 5 16800 240 38 85

# ================= SECTION 3: FANFARES (4/4) =================
AddEv 0 18720 4 (MetaTempo 108)
$K=18720
AddEv 0 $K 3 (MetaText 6 "Fanfare - Koda (noble/horn)"); AddProg 1 $K 60
AddNote 1 $K 960 57 84; AddNote 1 ($K+960) 960 62 86; AddNote 1 ($K+1920) 960 64 84; AddNote 1 ($K+2880) 960 66 88
AddChord 2 $K 1920 @(50,54,57) 58; AddChord 2 ($K+1920) 1920 @(50,54,57) 58
AddNote 3 $K 1920 38 66; AddNote 3 ($K+1920) 1920 38 66

$W=24480
AddEv 0 $W 3 (MetaText 6 "Fanfare - Wren (confident/trumpet)"); AddProg 1 $W 56
AddNote 1 $W 200 69 92; AddNote 1 ($W+240) 200 74 92; AddNote 1 ($W+480) 200 76 90; AddNote 1 ($W+720) 200 78 94
AddNote 1 ($W+960) 200 81 96; AddNote 1 ($W+1200) 200 78 90; AddNote 1 ($W+1440) 200 74 88; AddNote 1 ($W+1680) 200 76 88
AddNote 1 ($W+1920) 400 78 94; AddNote 1 ($W+2400) 400 74 92; AddNote 1 ($W+2880) 200 69 86; AddNote 1 ($W+3120) 700 74 94
AddChord 2 $W 1920 @(50,54,57) 55; AddChord 2 ($W+1920) 1920 @(50,54,57) 55
AddNote 3 $W 1920 38 62; AddNote 3 ($W+1920) 1920 38 62

$R=30240
AddEv 0 $R 3 (MetaText 6 "Fanfare - Ripper (aggressive/trombone)"); AddProg 1 $R 57
AddNote 1 $R 240 45 96; AddNote 1 ($R+240) 240 50 98; AddNote 1 ($R+480) 240 52 94; AddNote 1 ($R+720) 240 53 96; AddNote 1 ($R+960) 240 54 96; AddNote 1 ($R+1200) 480 50 98
AddNote 1 ($R+1920) 240 45 96; AddNote 1 ($R+2160) 240 50 96; AddNote 1 ($R+2400) 480 54 98; AddNote 1 ($R+2880) 960 50 100
AddChord 2 $R 1920 @(50,54,57) 58; AddChord 2 ($R+1920) 1920 @(50,54,57) 60
AddNote 3 $R 1920 38 70; AddNote 3 ($R+1920) 1920 38 70
AddNote 5 $R 240 38 100; AddNote 5 ($R+1920) 240 38 100; AddNote 5 ($R+2880) 240 38 95

$KI=36000
AddEv 0 $KI 3 (MetaText 6 "Fanfare - Kiri (elegant/flute+harp)"); AddProg 1 $KI 73; AddProg 6 $KI 46
AddNote 1 $KI 240 69 76; AddNote 1 ($KI+240) 240 74 76; AddNote 1 ($KI+480) 240 76 74; AddNote 1 ($KI+720) 480 78 78
AddNote 1 ($KI+1200) 240 81 78; AddNote 1 ($KI+1440) 240 79 74; AddNote 1 ($KI+1680) 240 78 74
AddNote 1 ($KI+1920) 480 76 74; AddNote 1 ($KI+2400) 480 78 76; AddNote 1 ($KI+2880) 960 74 78
$gl=@(62,64,66,69,71,74); for($i=0;$i -lt 6;$i++){ AddNote 6 ($KI+$i*90) 120 $gl[$i] 60; AddNote 6 ($KI+1920+$i*90) 120 $gl[$i] 58 }
AddChord 2 $KI 1920 @(50,54,57) 50; AddChord 2 ($KI+1920) 1920 @(50,54,57) 50
AddNote 3 $KI 1920 38 58; AddNote 3 ($KI+1920) 1920 38 58

$BA=41760
AddEv 0 $BA 3 (MetaText 6 "Fanfare - Banjo (playful/pizz+bassoon)"); AddProg 1 $BA 45; AddProg 6 $BA 70
AddNote 1 $BA 150 57 86; AddNote 1 ($BA+240) 150 62 88; AddNote 1 ($BA+720) 150 64 84; AddNote 1 ($BA+960) 150 66 86; AddNote 1 ($BA+1440) 150 62 84; AddNote 1 ($BA+1680) 150 69 82
AddNote 1 ($BA+1920) 150 62 86; AddNote 1 ($BA+2160) 150 64 84; AddNote 1 ($BA+2400) 150 66 86; AddNote 1 ($BA+2640) 150 62 84; AddNote 1 ($BA+3120) 300 62 88
AddNote 6 $BA 150 38 70; AddNote 6 ($BA+480) 150 45 70; AddNote 6 ($BA+960) 150 38 70; AddNote 6 ($BA+1440) 150 45 70; AddNote 6 ($BA+1920) 150 38 70; AddNote 6 ($BA+2400) 150 45 70; AddNote 6 ($BA+2880) 300 38 70
AddChord 2 $BA 1920 @(50,54,57) 48; AddChord 2 ($BA+1920) 1920 @(50,54,57) 48

$E=47520
AddEv 0 $E 3 (MetaText 6 "Fanfare - Echo (mystical/celesta+choir)"); AddProg 1 $E 8; AddProg 6 $E 46
AddNote 1 $E 240 69 70; AddNote 1 ($E+240) 240 74 70; AddNote 1 ($E+480) 240 76 68; AddNote 1 ($E+720) 480 78 72
AddNote 1 ($E+1200) 240 78 68; AddNote 1 ($E+1440) 240 80 70; AddNote 1 ($E+1680) 240 81 74
AddNote 1 ($E+1920) 240 78 68; AddNote 1 ($E+2160) 240 76 66; AddNote 1 ($E+2400) 1440 74 72
AddChord 4 $E 1920 @(62,66,69) 44; AddChord 4 ($E+1920) 1920 @(62,66,69) 44
$ar=@(62,66,69,74); for($i=0;$i -lt 4;$i++){ AddNote 6 ($E+$i*120) 140 $ar[$i] 50; AddNote 6 ($E+1920+$i*120) 140 $ar[$i] 48 }
AddChord 2 $E 1920 @(50,54,57) 46; AddChord 2 ($E+1920) 1920 @(50,54,57) 46
AddNote 3 $E 1920 38 58; AddNote 3 ($E+1920) 1920 38 58

$AT=53280
AddEv 0 $AT 3 (MetaText 6 "Fanfare - Atlas (majestic/brass+timp)"); AddProg 1 $AT 61
AddNote 1 $AT 480 57 92; AddNote 1 ($AT+480) 480 62 96; AddNote 1 ($AT+960) 480 64 92; AddNote 1 ($AT+1440) 480 66 96
AddNote 1 ($AT+1920) 1920 62 98
AddChord 4 $AT 1920 @(62,66,69) 55; AddChord 4 ($AT+1920) 1920 @(62,66,69) 58
AddNote 5 $AT 240 38 95; AddNote 5 ($AT+960) 240 38 90; AddNote 5 ($AT+1920) 240 38 98; AddNote 5 ($AT+2880) 240 33 85
AddChord 2 $AT 1920 @(50,54,57) 64; AddChord 2 ($AT+1920) 1920 @(50,54,57,62) 68
AddNote 3 $AT 1920 38 72; AddNote 3 ($AT+1920) 1920 38 72

# ---- assemble SMF ----
$midi = New-Object System.Collections.Generic.List[byte]
$midi.AddRange([System.Text.Encoding]::ASCII.GetBytes("MThd")); $midi.AddRange((BE32 6))
$midi.AddRange([byte[]]@(0x00,0x01)); $midi.AddRange([byte[]]@(0x00,0x07)); $midi.AddRange([byte[]]@(0x01,0xE0))
for($trk=0;$trk -le 6;$trk++){
  $sorted = $events[$trk] | Sort-Object t,ord
  $data = New-Object System.Collections.Generic.List[byte]
  $prev = 0
  foreach($ev in $sorted){ $d=$ev.t-$prev; $prev=$ev.t; $data.AddRange((To-VLQ $d)); $data.AddRange([byte[]]$ev.b) }
  $data.AddRange((To-VLQ 0)); $data.AddRange([byte[]]@(0xFF,0x2F,0x00))
  $midi.AddRange([System.Text.Encoding]::ASCII.GetBytes("MTrk")); $midi.AddRange((BE32 $data.Count)); $midi.AddRange($data)
}
$outDir = "C:\Users\Trevor\Desktop\Eucalyptus-Edge\.claude\worktrees\controller-layout-doc\EucalyptusEdge\Docs\Project\Audio"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$outPath = Join-Path $outDir "EE_EdgeTheme_Mockup.mid"
[System.IO.File]::WriteAllBytes($outPath, $midi.ToArray())
$hdr = ($midi[0..3] | ForEach-Object { $_.ToString("X2") }) -join " "
Write-Output ("WROTE " + $outPath)
Write-Output ("BYTES " + $midi.Count + "  HEADER " + $hdr + "  TRACKS 7")
