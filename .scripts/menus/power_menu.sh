#!/usr/bin/env bash

op=$( echo -e "  Poweroff\n  Reboot\n  Suspend\n  Lock\n  Logout" | rofi -dmenu -i -p "Power" | awk '{print tolower($2)}' )

case $op in 
        poweroff)
                ;&
        reboot)
                ;&
        suspend)
                systemctl $op
                ;;
        lock)
                hyprctl dispatch lock
                ;;
        logout)
                hyprctl dispatch 'hl.dsp.exit()'
                ;;
esac
