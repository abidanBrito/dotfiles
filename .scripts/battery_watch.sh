#!/bin/bash

WARNED_20=false
WARNED_15=false
WARNED_10=false
WARNED_5=false

while true; do
  BATTERY=$(cat /sys/class/power_supply/BAT*/capacity)
  STATUS=$(cat /sys/class/power_supply/BAT*/status)

  if [ "$STATUS" = "Discharging" ]; then
    if [ "$BATTERY" -le 3 ]; then
      notify-send -u critical "🪫 CRITICAL Battery" "${BATTERY}% — suspending now!" -t 0
      systemctl suspend
    elif [ "$BATTERY" -le 5 ] && [ "$WARNED_5" = false ]; then
      notify-send -u critical "🔋 Battery Critical" "${BATTERY}% remaining — plug in NOW!" -t 0
      WARNED_5=true
    elif [ "$BATTERY" -le 10 ] && [ "$WARNED_10" = false ]; then
      notify-send -u critical "🔋 Battery Very Low" "${BATTERY}% remaining" -t 15000
      WARNED_10=true
    elif [ "$BATTERY" -le 15 ] && [ "$WARNED_15" = false ]; then
      notify-send -u normal "🔋 Battery Low" "${BATTERY}% remaining" -t 10000
      WARNED_15=true
    elif [ "$BATTERY" -le 20 ] && [ "$WARNED_20" = false ]; then
      notify-send -u normal "🔋 Battery Low" "${BATTERY}% remaining" -t 8000
      WARNED_20=true
    fi
  else
    WARNED_20=false
    WARNED_15=false
    WARNED_10=false
    WARNED_5=false
  fi

  sleep 60
done
