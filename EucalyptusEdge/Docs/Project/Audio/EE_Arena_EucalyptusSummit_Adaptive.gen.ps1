# Eucalyptus Summit - adaptive combat stem MIDI (Intro/LoopA/LoopB/Edge/FinalRound/Victory/Defeat)
$ErrorActionPreference = "Stop"
function To-VLQ([int]$value){
  $buffer = $value -band 0x7F; $out = New-Object System.Collections.ArrayList
  while(($value -shr 7) -gt 0){ $value = $value -shr 7; $buffer = ($buffer -shl 8) -bor (($value -band 0x7F) -bor 0x80) }
  while($true){ [void]$out.Add([byte]($buffer -band 0xFF)); if(($buffer -band 0x80) -ne 0){ $buffer = $buffer -shr 8 } else { break } }
  return ,([byte[]]$out.ToArray())
}
function BE32([int]$n){ return ,([byte[]]@([byte](($n -shr 24)-band 0xFF),[byte](($n -shr 16)-band 0xFF),[byte](($n -shr 8)-band 0xFF),[byte]($n -band 0xFF))) }
function MetaTempo([int]$bpm){ $us=[int](60000000/$bpm); return [byte[]]@(0xFF,0x51,0x03,[byte](($us -shr 16)-band 0xFF),[byte](($us -shr 8)-band 0xFF),[byte]($us -band 0xFF)) }
function MetaTimeSig([int]$nn,[int]$dd){ return [byte[]]@(0xFF,0x58,0x04,[byte]$nn,[byte]$dd,0x18,0x08) }
function MetaText([int]$type,[string]$s){ $tb=[System.Text.Encoding]::ASCII.GetBytes($s); $r=New-Object System.Collections.Generic.List[byte]; $r.Add(0xFF); $r.Add([byte]$type); $r.AddRange((To-VLQ $tb.Count)); $r.AddRange($tb); return ,([byte[]]$r.ToArray()) }
$chanOf = @{1=0;2=1;3=2;4=3;5=4;6=5;7=6;8=7}
$events = @{}; 0..8 | ForEach-Object { $events[$_] = New-Object System.Collections.ArrayList }
function AddEv([int]$trk,[int]$abs,[int]$ord,[byte[]]$bytes){ [void]$events[$trk].Add([pscustomobject]@{t=$abs;ord=$ord;b=$bytes}) }
function AddNote([int]$trk,[int]$start,[int]$dur,[int]$note,[int]$vel){ $ch=$chanOf[$trk]; AddEv $trk $start 5 ([byte[]]@([byte](0x90 -bor $ch),[byte]$note,[byte]$vel)); AddEv $trk ($start+$dur) 1 ([byte[]]@([byte](0x80 -bor $ch),[byte]$note,[byte]0)) }
function AddProg([int]$trk,[int]$t,[int]$prog){ $ch=$chanOf[$trk]; AddEv $trk $t 3 ([byte[]]@([byte](0xC0 -bor $ch),[byte]$prog)) }
function AddChord([int]$trk,[int]$start,[int]$dur,[int[]]$notes,[int]$vel){ foreach($n in $notes){ AddNote $trk $start $dur $n $vel } }

# ---- Conductor ----
AddEv 0 0 0 (MetaText 3 "Eucalyptus Summit - Adaptive Combat")
AddEv 0 0 1 ([byte[]]@(0xFF,0x59,0x02,0x02,0x00))
AddEv 0 0 2 (MetaTimeSig 4 2)
AddEv 0 0 4 (MetaTempo 152)
AddEv 0 0 3 (MetaText 6 "INTRO")
AddEv 0 7680 3 (MetaText 6 "LOOP START (Loop A / Neutral) - seamless")
AddEv 0 23040 3 (MetaText 6 "LOOP END -> back to LOOP START | LOOP B (Pressure) below")
AddEv 0 32640 4 (MetaTempo 104); AddEv 0 32640 3 (MetaText 6 "VICTORY STING (Honor Cadence)")
AddEv 0 38400 4 (MetaTempo 72);  AddEv 0 38400 3 (MetaText 6 "DEFEAT STING")
$names = @{1="Strings Hi (melody)";2="Strings Lo (pad)";3="Horns";4="Woodwinds";5="Percussion (Taiko/Timp)";6="Bass";7="Choir [FINAL ROUND layer]";8="Celesta [EDGE ENERGY layer]"}
foreach($k in $names.Keys){ AddEv $k 0 0 (MetaText 3 $names[$k]) }
AddProg 1 0 48; AddProg 2 0 48; AddProg 3 0 60; AddProg 4 0 73; AddProg 5 0 116; AddProg 6 0 43; AddProg 7 0 52; AddProg 8 0 8

# ================= INTRO (bars 1-4) =================
AddChord 3 0 960 @(57,62) 70; AddChord 3 960 960 @(66,64) 68           # horn call A-D / F#-E
AddChord 2 3840 1920 @(50,54,57) 52; AddChord 2 5760 1920 @(45,49,52) 54  # strings swell D -> A
AddNote 1 3840 960 69 62; AddNote 1 4800 960 74 66                     # strings-hi enters A4->D5
AddNote 1 5760 480 76 70; AddNote 1 6240 480 78 74; AddNote 1 6720 960 81 80   # E5 F#5 A5 lead-in
AddNote 6 0 1920 38 60; AddNote 6 1920 1920 38 60; AddNote 6 3840 1920 38 62; AddNote 6 5760 1920 33 66
# intro perc build (bar3 pulse, bar4 fill)
foreach($x in 0,480,960,1440){ AddNote 5 (3840+$x) 200 38 66 }
foreach($p in @(@(5760,38),@(6000,45),@(6240,38),@(6480,45),@(6720,38),@(6960,45),@(7200,45),@(7440,45))){ AddNote 5 $p[0] 160 $p[1] 82 }
# intro edge shimmer (magic open)
AddNote 8 0 240 78 40; AddNote 8 240 240 81 40; AddNote 8 480 240 85 38; AddNote 8 960 720 86 42

# ================= LOOP A (8 bars) — core stems =================
$L=7680
# Strings-Hi melody (Edge Cell + development), bar-by-bar
AddNote 1 $L 480 69 84; AddNote 1 ($L+480) 480 74 88; AddNote 1 ($L+960) 480 76 84; AddNote 1 ($L+1440) 480 78 88   #b1 D: A-D-E-F#
AddNote 1 ($L+1920) 480 74 82; AddNote 1 ($L+2400) 480 72 82; AddNote 1 ($L+2880) 960 74 84                        #b2 C: D-C-D
AddNote 1 ($L+3840) 480 71 82; AddNote 1 ($L+4320) 480 74 84; AddNote 1 ($L+4800) 960 79 88                        #b3 G: B-D-G
AddNote 1 ($L+5760) 960 78 86; AddNote 1 ($L+6720) 960 81 88                                                        #b4 D: F#-A
AddNote 1 ($L+7680) 480 74 82; AddNote 1 ($L+8160) 480 71 80; AddNote 1 ($L+8640) 960 66 80                        #b5 Bm: D-B-F#
AddNote 1 ($L+9600) 480 76 84; AddNote 1 ($L+10080) 480 73 82; AddNote 1 ($L+10560) 960 69 84                      #b6 A: E-C#-A
AddNote 1 ($L+11520) 480 67 82; AddNote 1 ($L+12000) 480 69 84; AddNote 1 ($L+12480) 480 71 86; AddNote 1 ($L+12960) 480 73 88 #b7 G->A rise
AddNote 1 ($L+13440) 960 74 88; AddNote 1 ($L+14400) 480 78 84; AddNote 1 ($L+14880) 480 69 80                     #b8 D turnaround -> A pickup
# Strings-Lo pad (whole-note chords)
AddChord 2 $L 1920 @(50,54,57) 58; AddChord 2 ($L+1920) 1920 @(48,52,55) 58; AddChord 2 ($L+3840) 1920 @(43,47,50) 58; AddChord 2 ($L+5760) 1920 @(50,54,57) 60
AddChord 2 ($L+7680) 1920 @(47,50,54) 58; AddChord 2 ($L+9600) 1920 @(45,49,52) 58; AddChord 2 ($L+11520) 960 @(43,47,50) 58; AddChord 2 ($L+12480) 960 @(45,49,52) 58; AddChord 2 ($L+13440) 1920 @(50,54,57) 60
# Horns (octave-down melody head, first 2 beats each bar)
AddNote 3 $L 480 57 78; AddNote 3 ($L+480) 480 62 80; AddNote 3 ($L+1920) 480 62 76; AddNote 3 ($L+2400) 480 60 76
AddNote 3 ($L+3840) 480 59 76; AddNote 3 ($L+4320) 480 62 78; AddNote 3 ($L+5760) 960 66 80
AddNote 3 ($L+7680) 480 62 76; AddNote 3 ($L+8160) 480 59 76; AddNote 3 ($L+9600) 480 64 78; AddNote 3 ($L+10080) 480 61 76
AddNote 3 ($L+11520) 480 55 76; AddNote 3 ($L+12000) 480 57 76; AddNote 3 ($L+12480) 480 59 78; AddNote 3 ($L+12960) 480 61 80; AddNote 3 ($L+13440) 960 62 80
# Woodwinds sparkle (rising bars b3,b7 an octave up)
AddNote 4 ($L+3840) 480 83 66; AddNote 4 ($L+4320) 480 86 66; AddNote 4 ($L+4800) 960 91 70
AddNote 4 ($L+11520) 480 79 64; AddNote 4 ($L+12000) 480 81 64; AddNote 4 ($L+12480) 480 83 66; AddNote 4 ($L+12960) 480 85 68
# Percussion taiko quarter-pulse (all 8 loop bars)
for($b=0;$b -lt 8;$b++){ $base=$L+$b*1920; AddNote 5 $base 200 38 100; AddNote 5 ($base+480) 200 45 78; AddNote 5 ($base+960) 200 38 88; AddNote 5 ($base+1440) 200 45 78 }
# Bass roots/fifths quarter drive
$bassbars = @(@(38,45),@(36,43),@(31,38),@(38,45),@(35,42),@(33,40),@(31,33),@(38,45))
for($b=0;$b -lt 8;$b++){ $base=$L+$b*1920; $r=$bassbars[$b][0]; $f=$bassbars[$b][1]
  if($b -eq 6){ AddNote 6 $base 460 31 84; AddNote 6 ($base+480) 460 31 76; AddNote 6 ($base+960) 460 33 84; AddNote 6 ($base+1440) 460 33 76 }
  else { AddNote 6 $base 460 $r 84; AddNote 6 ($base+480) 460 $f 74; AddNote 6 ($base+960) 460 $r 82; AddNote 6 ($base+1440) 460 $f 74 } }
# Choir FINAL ROUND additive (soft sustained ah, 2-bar spans)
AddChord 7 $L 3840 @(69,74) 50; AddChord 7 ($L+3840) 3840 @(67,74) 50; AddChord 7 ($L+7680) 3840 @(66,69) 48; AddChord 7 ($L+11520) 3840 @(69,74) 50
# Celesta EDGE ENERGY additive (Wonder Lift shimmer, sparse)
foreach($t in @(($L+960),($L+4800),($L+9600),($L+13440))){ AddNote 8 $t 240 78 44; AddNote 8 ($t+240) 240 80 44; AddNote 8 ($t+480) 480 81 46 }

# ================= LOOP B (Pressure, 4-bar intensity variant, bars 13-16) =================
$P=23040
# melody (higher, fuller)
AddNote 1 $P 480 74 92; AddNote 1 ($P+480) 480 78 94; AddNote 1 ($P+960) 960 81 96
AddNote 1 ($P+1920) 480 79 92; AddNote 1 ($P+2400) 480 76 90; AddNote 1 ($P+2880) 960 72 90
AddNote 1 ($P+3840) 480 83 94; AddNote 1 ($P+4320) 480 79 92; AddNote 1 ($P+4800) 960 74 92
AddNote 1 ($P+5760) 960 78 94; AddNote 1 ($P+6720) 480 81 92; AddNote 1 ($P+7200) 480 69 86
# pad
AddChord 2 $P 1920 @(50,54,57,62) 66; AddChord 2 ($P+1920) 1920 @(48,52,55,60) 66; AddChord 2 ($P+3840) 1920 @(43,47,50,55) 66; AddChord 2 ($P+5760) 1920 @(50,54,57,62) 68
# horns full chord stabs beats 1 & 3
$pchords = @(@(50,54,57,62),@(48,52,55,60),@(43,47,50,55),@(50,54,57,62))
for($b=0;$b -lt 4;$b++){ $base=$P+$b*1920; AddChord 3 $base 400 $pchords[$b] 92; AddChord 3 ($base+960) 400 $pchords[$b] 88 }
# percussion eighth drive (pressure)
for($b=0;$b -lt 4;$b++){ $base=$P+$b*1920; for($e=0;$e -lt 8;$e++){ $n = if($e % 2 -eq 0){38}else{45}; $v = if($e % 4 -eq 0){100}else{82}; AddNote 5 ($base+$e*240) 170 $n $v } }
# bass eighth drive
$pbass=@(38,36,31,38)
for($b=0;$b -lt 4;$b++){ $base=$P+$b*1920; $r=$pbass[$b]; for($e=0;$e -lt 8;$e++){ $n = if($e % 2 -eq 0){$r}else{$r+7}; AddNote 6 ($base+$e*240) 200 $n 84 } }
# choir full + edge continuous
for($b=0;$b -lt 4;$b++){ $base=$P+$b*1920; AddChord 7 $base 1920 @(62,66,69) 60 }
foreach($t in @(($P+960),($P+2880),($P+4800),($P+6720))){ AddNote 8 $t 240 78 50; AddNote 8 ($t+240) 240 80 50; AddNote 8 ($t+480) 480 81 52 }

# ================= VICTORY STING (Honor Cadence C-G-D) =================
$V=32640
AddNote 1 $V 480 76 90; AddNote 1 ($V+480) 480 79 92; AddNote 1 ($V+960) 480 78 90; AddNote 1 ($V+1440) 480 81 94; AddNote 1 ($V+1920) 1920 74 98
AddChord 2 $V 960 @(48,52,55) 72; AddChord 2 ($V+960) 960 @(43,47,50) 72; AddChord 2 ($V+1920) 1920 @(50,54,57,62) 80
AddChord 3 $V 960 @(52,55,60) 78; AddChord 3 ($V+960) 960 @(47,50,55) 78; AddChord 3 ($V+1920) 1920 @(57,62,66) 86
AddChord 7 ($V+1920) 1920 @(62,66,69) 62
AddNote 6 $V 900 36 80; AddNote 6 ($V+960) 900 31 80; AddNote 6 ($V+1920) 1920 38 82
AddNote 5 ($V+1920) 240 38 98; AddNote 5 ($V+2400) 240 38 84; AddNote 5 ($V+1920) 1440 43 60

# ================= DEFEAT STING (deflated, minor, unresolved) =================
$D=38400
AddNote 1 $D 960 69 70; AddNote 1 ($D+960) 960 65 66; AddNote 1 ($D+1920) 960 64 62; AddNote 1 ($D+2880) 960 62 58
AddChord 2 $D 1920 @(50,53,57) 54; AddChord 2 ($D+1920) 960 @(43,46,50) 52; AddChord 2 ($D+2880) 960 @(45,49,52) 50
AddNote 6 $D 1920 38 60; AddNote 6 ($D+1920) 1920 33 58
AddNote 5 $D 240 38 60

# ---- assemble ----
$midi = New-Object System.Collections.Generic.List[byte]
$midi.AddRange([System.Text.Encoding]::ASCII.GetBytes("MThd")); $midi.AddRange((BE32 6))
$midi.AddRange([byte[]]@(0x00,0x01)); $midi.AddRange([byte[]]@(0x00,0x09)); $midi.AddRange([byte[]]@(0x01,0xE0))
for($trk=0;$trk -le 8;$trk++){
  $sorted = $events[$trk] | Sort-Object t,ord
  $data = New-Object System.Collections.Generic.List[byte]; $prev = 0
  foreach($ev in $sorted){ $d=$ev.t-$prev; $prev=$ev.t; $data.AddRange((To-VLQ $d)); $data.AddRange([byte[]]$ev.b) }
  $data.AddRange((To-VLQ 0)); $data.AddRange([byte[]]@(0xFF,0x2F,0x00))
  $midi.AddRange([System.Text.Encoding]::ASCII.GetBytes("MTrk")); $midi.AddRange((BE32 $data.Count)); $midi.AddRange($data)
}
$outDir = "C:\Users\Trevor\Desktop\Eucalyptus-Edge\.claude\worktrees\controller-layout-doc\EucalyptusEdge\Docs\Project\Audio"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$outPath = Join-Path $outDir "EE_Arena_EucalyptusSummit_Adaptive.mid"
[System.IO.File]::WriteAllBytes($outPath, $midi.ToArray())
# self-validate
$b=[System.IO.File]::ReadAllBytes($outPath)
function LenA($o){ return ([int]$b[$o])*16777216 + ([int]$b[$o+1])*65536 + ([int]$b[$o+2])*256 + ([int]$b[$o+3]) }
$o=8+(LenA 4); $cnt=0; $ok=$true
while($o -lt $b.Length){ $id=[System.Text.Encoding]::ASCII.GetString($b[$o..($o+3)]); $len=LenA ($o+4); $end=$o+8+$len; if($id -ne "MTrk"){ $ok=$false; break }; if(-not($b[$end-3] -eq 0xFF -and $b[$end-2] -eq 0x2F)){ $ok=$false; break }; $cnt++; $o=$end }
Write-Output ("WROTE {0}" -f $outPath)
Write-Output ("BYTES {0}  TRACKS {1}  EOF_EXACT {2}  ALL_EOT_OK {3}" -f $b.Length,$cnt,($o -eq $b.Length),$ok)