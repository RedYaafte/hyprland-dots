#!/usr/bin/env bash
# Install the included configuration into ~/.config.
set -euo pipefail

dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
backup=true

usage() {
    printf 'Usage: %s [--no-backup]\n' "${0##*/}"
}

case "${1:-}" in
    "") ;;
    --no-backup) backup=false ;;
    --help|-h) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
esac

configs=(hypr waybar ghostty nvim dunst yazi mpv systemd themes elephant walker swayosd)
backup_dir=""
wallpaper_source_dir="$dotfiles_dir/assets/wallpapers/black-ember"
# Override only for testing or a nonstandard wallpaper library location.
wallpaper_destination_dir="${HYPRLAND_DOTS_WALLPAPER_DIR:-$HOME/Wallpapers/black_ember}"

backup_existing() {
    local name="$1" destination="$2"
    [[ "$backup" == true && -e "$destination" ]] || return 0

    if [[ -z "$backup_dir" ]]; then
        backup_dir="$state_dir/hyprland-dots/backups/$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup_dir"
    fi

    cp -a "$destination" "$backup_dir/$name"
}

mkdir -p "$config_dir"
for name in "${configs[@]}"; do
    source_dir="$dotfiles_dir/.config/$name"
    destination="$config_dir/$name"
    [[ -d "$source_dir" ]] || continue

    backup_existing "$name" "$destination"
    mkdir -p "$destination"
    cp -a "$source_dir/." "$destination/"
    printf 'Installed %s\n' "$name"
done

# Monitor profiles are user-owned. A reinstallation never replaces the
# selected profile; change this file to opt into a machine-specific layout.
profile_file="$config_dir/hypr/profile"
if [[ ! -e "$profile_file" ]]; then
    printf 'default\n' > "$profile_file"
    printf 'Selected monitor profile: default\n'
fi

# New installations use Black Ember. Preserve an existing theme selection.
if [[ -d "$config_dir/themes/black-ember" && ! -e "$config_dir/themes/current" ]]; then
    ln -s "black-ember" "$config_dir/themes/current"
    printf 'Selected default theme: Black Ember\n'
fi

# Black Ember includes a default wallpaper pair. Existing personal choices are
# deliberately left untouched.
if [[ -d "$wallpaper_source_dir" ]]; then
    mkdir -p "$wallpaper_destination_dir"
    for wallpaper in "$wallpaper_source_dir"/*; do
        [[ -f "$wallpaper" ]] || continue
        destination="$wallpaper_destination_dir/$(basename "$wallpaper")"
        if [[ ! -e "$destination" ]]; then
            cp -a "$wallpaper" "$destination"
            printf 'Installed Black Ember wallpaper: %s\n' "$(basename "$wallpaper")"
        fi
    done
fi

scripts=(
    hypr/scripts/wallpaper.sh
    hypr/scripts/launch-walker
    hypr/scripts/system-menu
    hypr/scripts/system-action
    hypr/scripts/launch-screensaver
    hypr/scripts/screensaver
    hypr/scripts/toggle-hdmi-a-2-orientation.sh
    hypr/scripts/toggle_float.sh
    hypr/scripts/volume-osd.sh
    hypr/scripts/brightness-ddc.sh
    themes/set-theme
    themes/select-theme-walker
    ghostty/greeting.sh
)
for script in "${scripts[@]}"; do
    [[ -f "$config_dir/$script" ]] && chmod +x "$config_dir/$script"
done

if [[ -f "$config_dir/themes/set-theme" && -L "$config_dir/themes/current" ]]; then
    "$config_dir/themes/set-theme" "$(basename "$(readlink "$config_dir/themes/current")")" || true
fi

printf '\nDotfiles installed.\n'
if [[ -n "$backup_dir" ]]; then
    printf 'Existing configuration backed up to: %s\n' "$backup_dir"
fi
printf 'Log out and start a new Hyprland session to apply compositor changes.\n'
