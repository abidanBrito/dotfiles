#!/usr/bin/env bash

## Author: Abidán Brito
## This script shows a rofi menu to power off, reboot, suspend, lock or
## log out.

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
