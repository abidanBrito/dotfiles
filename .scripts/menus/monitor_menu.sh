#!/usr/bin/env bash

## Author: Abidán Brito
## This script mirrors or extends the HDMI monitor from a rofi menu.

# Present options to the user through wofi
op=$( echo -e "󰍺  Mirror\n󱄴  Extend" | rofi -dmenu -i -p "Monitor" | awk '{print $NF}' )

# Handle the selected option
case $op in 
        "Mirror")
                # Mirror e-DP1 to HDMI-A-1
		hyprctl keyword monitor HDMI-A-1, preferred, auto, auto, mirror, eDP-1
                notify-send " 󰍹   Display: mirroring (HDMI-A-1)"
                ;;
        "Extend")
                # Extend HDMI-A-1
		hyprctl keyword monitor HDMI-A-1, preferred, auto, auto
                notify-send " 󰍹   Display: extended (HDMI-A-1)"
                ;;
esac

