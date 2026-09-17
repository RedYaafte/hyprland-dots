#!/bin/bash
# install.sh — Instala los dotfiles en ~/.config

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

configs=(hypr waybar ghostty nvim dunst yazi mpv systemd themes elephant walker swayosd)

for dir in "${configs[@]}"; do
    src="$DOTFILES_DIR/.config/$dir"
    dst="$CONFIG/$dir"
    if [ -d "$src" ]; then
        mkdir -p "$dst"
        cp -r "$src/." "$dst/"
        echo "✓ $dir"
    fi
done

# New installations use Black Ember. Preserve an existing selection.
if [ -d "$CONFIG/themes/black-ember" ] && [ ! -e "$CONFIG/themes/current" ]; then
    ln -s "black-ember" "$CONFIG/themes/current"
    echo "✓ tema por defecto: Black Ember"
fi

# Hacer ejecutables los scripts
chmod +x "$CONFIG/hypr/scripts/wallpaper.sh"
chmod +x "$CONFIG/hypr/scripts/launch-walker"
chmod +x "$CONFIG/hypr/scripts/system-menu"
chmod +x "$CONFIG/hypr/scripts/system-action"
chmod +x "$CONFIG/hypr/scripts/launch-screensaver"
chmod +x "$CONFIG/hypr/scripts/screensaver"
chmod +x "$CONFIG/hypr/scripts/toggle-hdmi-a-2-orientation.sh"
chmod +x "$CONFIG/hypr/scripts/toggle_float.sh"
chmod +x "$CONFIG/hypr/scripts/volume-osd.sh"
chmod +x "$CONFIG/hypr/scripts/brightness-ddc.sh"
chmod +x "$CONFIG/themes/set-theme"
chmod +x "$CONFIG/themes/select-theme-walker"

if [ -f "$CONFIG/themes/set-theme" ] && [ -L "$CONFIG/themes/current" ]; then
    "$CONFIG/themes/set-theme" "$(basename "$(readlink "$CONFIG/themes/current")")" || true
fi
chmod +x "$CONFIG/ghostty/greeting.sh"

echo ""
echo "✅ Dotfiles instalados."
echo ""
echo "⚠️  Recuerda:"
echo "  - Ajusta el monitor en hyprpaper.conf (actualmente HDMI-A-1)"
echo "  - Exporta LINEAR_API_KEY en tu .bashrc si usas el greeting de ghostty"
echo "  - Los wallpapers deben estar en ~/Wallpapers/{morning,afternoon,night,video}/"
