#!/usr/bin/env bash

## Author: Abidán Brito
## This script picks an emoji from a rofi menu, then copies and types it.

chosen=$(grep '; fully-qualified' /usr/share/unicode/emoji/emoji-test.txt \
    | sed 's/.*# \([^ ]*\) E[0-9.]* /\1 /' \
    | rofi -dmenu -i -p "Emoji")

[ -z "$chosen" ] && exit

emoji="${chosen%% *}"
echo -n "$emoji" | wl-copy
sleep 0.1 && wtype "$emoji"
