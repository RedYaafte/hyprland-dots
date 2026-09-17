#!/bin/bash

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
MONITORS=($(hyprctl monitors | grep "^Monitor" | awk '{print $2}'))
WALL_DIR="$HOME/Wallpapers"

MODE=$1

killall hyprpaper 2>/dev/null
killall mpvpaper 2>/dev/null

apply_wallpaper() {
    local wallpaper="$1"
    hyprpaper &
    sleep 1
    hyprctl hyprpaper preload "$wallpaper"
    for monitor in "${MONITORS[@]}"; do
        hyprctl hyprpaper wallpaper "$monitor,$wallpaper"
    done
}

apply_theme_wallpapers() {
    local horizontal="$1"
    local vertical="${2:-$1}"

    hyprpaper &
    sleep 1
    hyprctl hyprpaper preload "$horizontal"
    [[ "$vertical" == "$horizontal" ]] || hyprctl hyprpaper preload "$vertical"

    for monitor in "${MONITORS[@]}"; do
        transform=$(hyprctl monitors -j | jq -r --arg monitor "$monitor" '.[] | select(.name == $monitor) | .transform')
        wallpaper="$horizontal"
        [[ "$transform" == "1" || "$transform" == "3" ]] && wallpaper="$vertical"
        hyprctl hyprpaper wallpaper "$monitor,$wallpaper"
    done
}

# A selected theme owns the startup wallpaper; time-based backgrounds remain
# available through the explicit morning/afternoon/night shortcuts.
if [[ -z "$MODE" || "$MODE" = "theme" ]]; then
    THEME_WALLPAPER_CONF="$config_dir/themes/current/wallpaper.conf"
    if [[ -r "$THEME_WALLPAPER_CONF" ]]; then
        THEME_WALLPAPER=$(sed -n 's/^path = "\(.*\)"$/\1/p' "$THEME_WALLPAPER_CONF" | head -n 1)
        THEME_WALLPAPER="${THEME_WALLPAPER/#\~/$HOME}"
        THEME_VERTICAL_WALLPAPER=$(sed -n 's/^vertical_path = "\(.*\)"$/\1/p' "$THEME_WALLPAPER_CONF" | head -n 1)
        THEME_VERTICAL_WALLPAPER="${THEME_VERTICAL_WALLPAPER/#\~/$HOME}"
        if [[ -f "$THEME_WALLPAPER" ]]; then
            [[ -f "$THEME_VERTICAL_WALLPAPER" ]] || THEME_VERTICAL_WALLPAPER="$THEME_WALLPAPER"
            apply_theme_wallpapers "$THEME_WALLPAPER" "$THEME_VERTICAL_WALLPAPER"
            exit 0
        fi
    fi
fi

[[ "$MODE" = "theme" ]] && MODE=""

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
    mpvpaper -o "loop-file=inf no-audio hwdec=auto" "${MONITORS[*]}" "$VIDEO"

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

apply_wallpaper "$WALL"

# 🎨 colores dinámicos
# walrs -i "$WALL"
