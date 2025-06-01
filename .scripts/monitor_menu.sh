#!/usr/bin/env bash

# Present options to the user through wofi
op=$( echo -e "Mirror\nExtend" | rofi -dmenu -i )

# Handle the selected option
case $op in 
        "Mirror")
                # Mirror e-DP1 to HDMI-A-1
		hyprctl keyword monitor HDMI-A-1, preferred, auto, auto, mirror, eDP-1
                notify-send "HDMI-A-1 is now mirroring."
                ;;
        "Extend")
                # Extend HDMI-A-1
		hyprctl keyword monitor HDMI-A-1, preferred, auto, auto
                notify-send "HDMI-A-1 is now extending."
                ;;
        *)
                notify-send "No valid option selected."
                ;;
esac

