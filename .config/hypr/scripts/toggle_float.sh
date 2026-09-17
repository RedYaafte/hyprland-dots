#!/usr/bin/env bash
set -euo pipefail

active_window="$(hyprctl activewindow -j 2>/dev/null || true)"
floating="$(jq -r '.floating // empty' <<<"$active_window" 2>/dev/null || true)"
[[ "$floating" == "true" || "$floating" == "false" ]] || exit 0
if [[ "$floating" == "true" ]]; then hyprctl dispatch togglefloating; exit 0; fi

monitor="$(jq -r '.monitor // empty' <<<"$active_window" 2>/dev/null || true)"
read -r width height < <(hyprctl monitors -j 2>/dev/null | jq -r --arg monitor "$monitor" '.[] | select(.name == $monitor) | "\(.width) \(.height)"' || true)
hyprctl dispatch togglefloating
[[ "$width" =~ ^[0-9]+$ && "$height" =~ ^[0-9]+$ ]] || exit 0
sleep 0.05
hyprctl --batch "dispatch resizeactive exact $((width * 70 / 100)) $((height * 50 / 100)); dispatch centerwindow" >/dev/null
