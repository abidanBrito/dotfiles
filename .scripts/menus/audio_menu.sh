#!/usr/bin/env bash

## Author: Abidán Brito
## This script picks the audio output from a rofi menu and moves playing
## streams to it.

declare -A sink_map

while IFS= read -r line; do
    if [[ $line =~ ^$'\t'Name:\ (.+)$ ]]; then
        current_name="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^$'\t'Description:\ (.+)$ ]]; then
        sink_map["${BASH_REMATCH[1]}"]="$current_name"
    fi
done < <(pactl list sinks)

default=$(pactl get-default-sink)

entries=()
for desc in "${!sink_map[@]}"; do
    name="${sink_map[$desc]}"
    if [[ "$name" == "$default" ]]; then
        entries+=("󰓃  $desc (●)")
    else
        entries+=("󰓃  $desc")
    fi
done

chosen=$(printf '%s\n' "${entries[@]}" | rofi -dmenu -i -p "Audio Output")
[ -z "$chosen" ] && exit

desc=$(echo "$chosen" | sed 's/^󰓃  //' | sed 's/ (●)$//')
sink="${sink_map[$desc]}"

pactl set-default-sink "$sink"
pactl list sink-inputs short | awk '{print $1}' | while read -r id; do
    pactl move-sink-input "$id" "$sink"
done
