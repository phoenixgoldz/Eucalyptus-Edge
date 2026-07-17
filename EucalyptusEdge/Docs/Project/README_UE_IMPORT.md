# EUCALYPTUS EDGE — UI PRODUCTION SLICES v1
Sliced from the four painterly master sheets (style-locked). 92 assets + 5 canon recolors.

## UE import settings (all files)
Texture Group: UI · Mip Gen: NoMipmaps · Compression: UserInterface2D (sRGB on)

## Packs
- pack1_menu_buttons/  — T_UI_BtnLg_{Idle,Hover,Pressed,Disabled} → Button widget style slots 1:1. Icon + label stay UMG children.
- pack3_icon_rings/    — 4 materials × 4 states + large. Center is clear per the sheet spec (~70% inner diameter): drop any icon inside in UMG.
- pack7_bars/          — per bar: _BG under a ProgressBar; _Fill as Fill Image (segmented fills: set Fill Method → Grid/Box as needed); _Glow as an overlay Image for special states (pulse via material). _Full is a reference composite, not for runtime. BarCap_* are optional left/right end ornaments.
- pack7_bars_emerald/  — CANON: Edge Energy is emerald, not blue. Use these fills for the Edge meter; originals kept if you want blue for Loading instead.
- pack0_misc/          — logo lockup, banners (3 hanging + 1 leaf pennant), large panel states, hanging signs, medallions, stone ring, lock ring, segmented multi-color bar, 8 icon buttons × 2 states.

## Canon notes
- XP bar is violet — conflicts with "violet = Blighted/locked only." Extracted as-is; say the word and I'll hue-shift it (teal or amber recommended).
- Small lilac flowers on frames are decorative flora, not state signaling — no conflict, left untouched.
- No cut characters, no Sonia references anywhere in these sheets. Clean.

## Re-cuts
Every crop came from the master sheets non-destructively. If any single asset needs a tighter/looser crop or its neighbor bled in, name it and I re-cut in seconds.
