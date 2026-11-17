#!/usr/bin/env bash

## Author: Abidán Brito
## This script prints battery status and the TLP profile as JSON for waybar.

# Raw battery readings from sysfs
bat=/sys/class/power_supply/BAT1
cap=$(<"$bat/capacity")
status=$(<"$bat/status")
now=$(<"$bat/energy_now")
full=$(<"$bat/energy_full")
pwr=$(<"$bat/power_now")

# Pick an icon per 10% of charge
icons=(󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
idx=$(( cap / 10 )); (( idx > 9 )) && idx=9

# CSS class for charging and low battery styling
class=""
if [[ $status == Charging ]]; then
    icon=󰂄; class=charging
else
    icon=${icons[$idx]}
    (( cap <= 15 )) && class=critical || { (( cap <= 30 )) && class=warning; }
fi

# Time left or time to full, from the current power draw
time=""
if (( pwr > 0 )); then
    case $status in
        Discharging) secs=$(( now * 3600 / pwr )); time="$(( secs / 3600 ))h $(( secs % 3600 / 60 ))m left" ;;
        Charging)    secs=$(( (full - now) * 3600 / pwr )); time="$(( secs / 3600 ))h $(( secs % 3600 / 60 ))m to full" ;;
    esac
fi
[[ -z $time ]] && time=$status

# Current TLP power profile for the tooltip
profile=$(tlp-stat -s 2>/dev/null | awk -F'= ' '/TLP profile/ {split($2, a, "/"); print a[1]}')
profile=${profile:-unknown}

printf '{"text":"%s %s%%","alt":"%s %s","tooltip":"%s","class":"%s"}\n' \
    "$icon" "$cap" "$icon" "$time" "${profile^}" "$class"
