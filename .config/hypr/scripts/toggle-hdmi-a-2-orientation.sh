#!/usr/bin/env bash
set -euo pipefail

output="HDMI-A-2"
mode="1920x1080@60"
position="3440x0"
waybar_dir="$HOME/.config/waybar"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/${output,,}-orientation"

monitor_is_active() {
  hyprctl monitors -j 2>/dev/null | jq -e --arg monitor "$1" '.[] | select(.name == $monitor)' >/dev/null
}

current_orientation() {
  local transform
  transform="$(hyprctl monitors -j | jq -r --arg output "$output" '.[] | select(.name == $output) | .transform')"
  [[ "$transform" == "1" || "$transform" == "3" ]] && printf '%s\n' vertical || printf '%s\n' horizontal
}

apply_orientation() {
  local transform=0
  [[ "$1" == "vertical" ]] && transform=1
  hyprctl eval "hl.monitor({ output = \"$output\", mode = \"$mode\", position = \"$position\", scale = 1, transform = $transform })"
}

restart_waybar() {
  pkill -x waybar 2>/dev/null || true
  sleep 0.2
  if [[ "$(current_orientation)" == "vertical" ]]; then
    monitor_is_active "HDMI-A-1" && waybar --config "$waybar_dir/config-horizontal.jsonc" --style "$waybar_dir/style.css" >/dev/null 2>&1 &
    monitor_is_active "$output" && waybar --config "$waybar_dir/config-vertical.jsonc" --style "$waybar_dir/style-vertical.css" >/dev/null 2>&1 &
  else
    waybar --config "$waybar_dir/config.jsonc" --style "$waybar_dir/style.css" >/dev/null 2>&1 &
  fi
}

case "${1:-toggle}" in
  toggle)
    [[ "$(current_orientation)" == "vertical" ]] && orientation="horizontal" || orientation="vertical"
    apply_orientation "$orientation"
    mkdir -p "$state_dir"
    printf '%s\n' "$orientation" > "$state_file"
    sleep 0.2
    restart_waybar
    ;;
  apply)
    orientation="vertical"
    [[ -r "$state_file" ]] && orientation="$(<"$state_file")"
    [[ "$orientation" == "horizontal" || "$orientation" == "vertical" ]] || orientation="vertical"
    apply_orientation "$orientation"
    sleep 0.2
    restart_waybar
    ;;
  *) printf 'Uso: %s [toggle|apply]\n' "${0##*/}" >&2; exit 2 ;;
esac
