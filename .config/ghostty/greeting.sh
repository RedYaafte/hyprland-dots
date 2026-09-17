#!/usr/bin/env bash
set -euo pipefail

# A local, dependency-free greeting. Add one phrase per line to frases.txt to
# enable the optional quote below.
if command -v figlet >/dev/null 2>&1; then
    figlet -f slant "Black Ember"
else
    printf '%s\n' 'Black Ember'
fi

printf '\n%s\n' "$(date '+%A, %d %b %Y — %H:%M')"

phrases="$HOME/.config/ghostty/frases.txt"
if [[ -s "$phrases" ]]; then
    printf '\n%s\n' "$(shuf -n 1 "$phrases")"
fi
