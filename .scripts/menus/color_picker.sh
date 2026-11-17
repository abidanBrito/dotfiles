#!/usr/bin/env bash

## Author: Abidán Brito
## This script picks a color on screen and copies it in the chosen format.

hex=$(hyprpicker --format=hex)
[ -z "$hex" ] && exit

format=$(echo -e "󰄄  HEX\n󰄄  RGB\n󰄄  HSL\n󰄄  HSV\n󰄄  CMYK" | rofi -dmenu -i -p "Color Format" | awk '{print $NF}')
[ -z "$format" ] && exit

result=$(python3 -c "
import colorsys
h = '$hex'.lstrip('#')
r, g, b = (int(h[i:i+2], 16) / 255 for i in (0, 2, 4))
fmt = '${format}'
if fmt == 'HEX':
    print('$hex')
elif fmt == 'RGB':
    print(f'rgb({int(r*255)}, {int(g*255)}, {int(b*255)})')
elif fmt == 'HSL':
    hh, l, s = colorsys.rgb_to_hls(r, g, b)
    print(f'hsl({int(hh*360)}, {int(s*100)}%, {int(l*100)}%)')
elif fmt == 'HSV':
    hh, s, v = colorsys.rgb_to_hsv(r, g, b)
    print(f'hsv({int(hh*360)}, {int(s*100)}%, {int(v*100)}%)')
elif fmt == 'CMYK':
    k = 1 - max(r, g, b)
    if k == 1:
        print('cmyk(0%, 0%, 0%, 100%)')
    else:
        c, m, y = ((1 - x - k) / (1 - k) for x in (r, g, b))
        print(f'cmyk({int(c*100)}%, {int(m*100)}%, {int(y*100)}%, {int(k*100)}%)')
")

echo -n "$result" | wl-copy

swatch="/tmp/color_swatch.png"
convert -size 64x64 xc:none -fill "$hex" -draw "roundrectangle 4,4,59,59,8,8" "$swatch"
notify-send -i "$swatch" " 󰏘   Color picked" "  $result"
