#!/usr/bin/env bash
set -euo pipefail
case "${1:-}" in up) action="+5" ;; down) action="-5" ;; mute) action="mute-toggle" ;; *) printf 'Uso: %s {up|down|mute}\n' "${0##*/}" >&2; exit 2 ;; esac
monitor="$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | select(.focused == true) | .name' | head -n1)"
[[ -n "$monitor" && "$monitor" != "null" ]] && exec swayosd-client --monitor "$monitor" --output-volume "$action"
exec swayosd-client --output-volume "$action"
