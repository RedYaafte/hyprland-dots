#!/usr/bin/env bash
set -euo pipefail

action="${1:-toggle}"
[[ $# -gt 0 ]] && shift

output=""
mode=""
position=""
initial="vertical"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) output="$2"; shift 2 ;;
    --mode) mode="$2"; shift 2 ;;
    --position) position="$2"; shift 2 ;;
    --initial) initial="$2"; shift 2 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

[[ -n "$output" && -n "$mode" && -n "$position" ]] || {
  printf 'Usage: %s [toggle|apply] --output OUTPUT --mode MODE --position POSITION [--initial horizontal|vertical]\n' "${0##*/}" >&2
  exit 2
}
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/${output,,}-orientation"

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
  waybar >/dev/null 2>&1 &
}

case "$action" in
  toggle)
    [[ "$(current_orientation)" == "vertical" ]] && orientation="horizontal" || orientation="vertical"
    apply_orientation "$orientation"
    mkdir -p "$state_dir"
    printf '%s\n' "$orientation" > "$state_file"
    sleep 0.2
    restart_waybar
    ;;
  apply)
    orientation="$initial"
    [[ -r "$state_file" ]] && orientation="$(<"$state_file")"
    [[ "$orientation" == "horizontal" || "$orientation" == "vertical" ]] || orientation="vertical"
    apply_orientation "$orientation"
    sleep 0.2
    restart_waybar
    ;;
  *) printf 'Usage: %s [toggle|apply] --output OUTPUT --mode MODE --position POSITION [--initial horizontal|vertical]\n' "${0##*/}" >&2; exit 2 ;;
esac
