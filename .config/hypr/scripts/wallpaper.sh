#!/bin/bash

MONITOR=$(hyprctl monitors | grep "Monitor" | head -n1 | awk '{print $2}')
WALL_DIR="$HOME/Wallpapers"

MODE=$1

killall hyprpaper 2>/dev/null
killall mpvpaper 2>/dev/null

get_time_mode() {
    HOUR=$(date +%H)

    if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 12 ]; then
        echo "morning"
    elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 19 ]; then
        echo "afternoon"
    else
        echo "night"
    fi
}

# 🎥 MODO VIDEO (manual)
if [ "$MODE" = "video" ]; then
    VIDEO=$(find "$WALL_DIR/video" -type f | shuf -n 1)
    mpvpaper -o "loop-file=inf no-audio hwdec=auto" "$MONITOR" "$VIDEO"

    # opcional: no generar colores con video
    exit 0
fi

# 🌤️ modo normal (auto o manual)
if [ -n "$MODE" ]; then
    SELECTED_MODE=$MODE
else
    SELECTED_MODE=$(get_time_mode)
fi

WALL=$(find "$WALL_DIR/$SELECTED_MODE" -type f | shuf -n 1)

hyprpaper &
sleep 1
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper "$MONITOR,$WALL"

# 🎨 colores dinámicos
# walrs -i "$WALL"
