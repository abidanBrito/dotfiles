#!/usr/bin/env bash

## Author: Abidán Brito
## This script screenshots the screen, a window or a region, then copies
## it to the clipboard or saves it to ~/Pictures/Screenshots.

savedir="$HOME/Pictures/Screenshots"
mkdir -p "$savedir"

tmpname="screenshot_$(date +%s).png"
tmp="/tmp/$tmpname"

mode=$(echo -e "󰍹  Full screen\n󱂬  Window\n󰆟  Region" | rofi -dmenu -i -p "Screenshot")
[ -z "$mode" ] && exit

case "$mode" in
    *Full*)   hyprshot -m active -m output -o /tmp -f "$tmpname" -s ;;
    *Window*) hyprshot -m window -o /tmp -f "$tmpname" -s ;;
    *Region*) hyprshot -m region -o /tmp -f "$tmpname" -s ;;
esac

[ ! -f "$tmp" ] && exit

sleep 0.3
dest=$(echo -e "󰅍  Copy to clipboard\n󰆓  Save to file" | rofi -dmenu -i -p "Destination")
[ -z "$dest" ] && rm -f "$tmp" && exit

if [[ "$dest" == *"Copy"* ]]; then
    wl-copy < "$tmp"
    rm -f "$tmp"
    notify-send " 󰹑   Screenshot: copied to clipboard"
else
    final="$savedir/screenshot_$(date +%Y%m%d_%H%M%S).png"
    mv "$tmp" "$final"
    notify-send " 󰹑   Screenshot: saved" "$final"
fi
