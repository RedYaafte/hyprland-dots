#!/usr/bin/env bash
set -euo pipefail
display=1
fallback_monitor="HDMI-A-1"
case "${1:-}" in up) ddcutil --display "$display" setvcp 10 + 5 >/dev/null ;; down) ddcutil --display "$display" setvcp 10 - 5 >/dev/null ;; *) printf 'Uso: %s {up|down}\n' "${0##*/}" >&2; exit 2 ;; esac
read -r current maximum < <(ddcutil --terse --display "$display" getvcp 10 | awk '$1 == "VCP" && $2 == "10" { print $(NF - 1), $NF; exit }')
[[ "$current" =~ ^[0-9]+$ && "$maximum" =~ ^[1-9][0-9]*$ ]] || { printf 'No se pudo leer el brillo DDC.\n' >&2; exit 1; }
progress="$(awk -v current="$current" -v maximum="$maximum" 'BEGIN { printf "%.3f", current / maximum }')"
monitor="$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | select(.focused == true) | .name' | head -n1)"
[[ -n "$monitor" && "$monitor" != "null" ]] || monitor="$fallback_monitor"
swayosd-client --monitor "$monitor" --duration 1800 --custom-icon display-brightness-symbolic --custom-progress "$progress" --custom-progress-text "${current}%"
