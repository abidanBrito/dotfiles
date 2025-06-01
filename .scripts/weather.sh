#!/usr/bin/env bash

location="$1"
attempts=5
delay=2

for ((i=1; i<=attempts; i++)); do
  text=$(curl -s "https://wttr.in/${location}?format=1")
  if [ $? -eq 0 ]; then
    text=$(echo "$text" | sed -E "s/\s+/ /g")
    tooltip=$(curl -s "https://wttr.in/${location}?format=4")
    if [ $? -eq 0 ]; then
      tooltip=$(echo "$tooltip" | sed -E "s/\s+/ /g")
      echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
      exit 0
    fi
  fi
  sleep "$delay"
done

echo "{\"text\":\"error\", \"tooltip\":\"error\"}"F