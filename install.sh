#!/bin/bash
# install.sh — Instala los dotfiles en ~/.config

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

configs=(hypr waybar ghostty rofi nvim dunst yazi mpv)

for dir in "${configs[@]}"; do
    src="$DOTFILES_DIR/.config/$dir"
    dst="$CONFIG/$dir"
    if [ -d "$src" ]; then
        mkdir -p "$dst"
        cp -r "$src/." "$dst/"
        echo "✓ $dir"
    fi
done

# Hacer ejecutables los scripts
chmod +x "$CONFIG/hypr/scripts/wallpaper.sh"
chmod +x "$CONFIG/ghostty/greeting.sh"

echo ""
echo "✅ Dotfiles instalados."
echo ""
echo "⚠️  Recuerda:"
echo "  - Ajusta el monitor en hyprpaper.conf (actualmente HDMI-A-1)"
echo "  - Exporta LINEAR_API_KEY en tu .bashrc si usas el greeting de ghostty"
echo "  - Los wallpapers deben estar en ~/Wallpapers/{morning,afternoon,night,video}/"
