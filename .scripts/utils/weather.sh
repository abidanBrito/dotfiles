#!/usr/bin/env bash

## Author: Abidán Brito
## This script prints wttr.in weather as JSON for the waybar weather module.

location="$1"
attempts=5
delay=2

# Tooltip layout in wttr.in format codes
tooltip_format="%c %C, %t (feels like %f)\n💧 %h   🌬 %w   🌧 %p\n📍 %l"

# Retry a few times in case the network is not up yet
for ((i=1; i<=attempts; i++)); do
  text=$(curl -s "https://wttr.in/${location}?format=1")
  if [ $? -eq 0 ]; then
    # Squeeze spaces in the bar text
    text=$(echo "$text" | sed -E "s/[[:blank:]]+/ /g" | tr -d '\n')
    tooltip=$(curl -s --get --data-urlencode "format=${tooltip_format}" "https://wttr.in/${location}")
    if [ $? -eq 0 ]; then
      # Tidy spacing and add a comma before the country
      tooltip=$(echo "$tooltip" \
        | sed -E "s/[[:blank:]]+/ /g" \
        | sed "s/ ,/,/g" \
        | sed '/📍/s/ \([^ ]*\)$/, \1/')
      jq -nc --arg text "$text" --arg tooltip "$tooltip" '{"text":$text,"tooltip":$tooltip}'
      exit 0
    fi
  fi
  sleep "$delay"
done

# Every attempt failed
jq -nc '{"text":"error","tooltip":"error"}'