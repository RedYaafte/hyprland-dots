# hyprland-dots

A personal, keyboard-first Hyprland setup for Arch Linux and EndeavourOS. It
is designed to be portable, independent from Omarchy, and usable as a base for
a clean Arch installation.

## Highlights

- Hyprland Lua configuration with a custom Spiral layout.
- Walker as the primary launcher, powered by Elephant for personal theme
  selection and wallpaper previews.
- A standalone system menu for lock, suspend, logout, reboot, shutdown, and a
  lightweight terminal screensaver.
- The **Black Ember** theme: charcoal, burnt steel, aged bronze, and restrained
  ember highlights.
- Theme-aware Walker, Waybar, SwayOSD, Hyprland, Ghostty, and wallpapers.
- Separate horizontal and vertical Black Ember wallpapers.
- Dynamic time-based or video wallpapers remain available through shortcuts.
- Multimedia controls, SwayOSD volume feedback, and optional DDC/CI monitor
  brightness.

## Stack

| Component | Tool |
| --- | --- |
| Compositor | [Hyprland](https://hyprland.org) |
| Terminal | [Ghostty](https://ghostty.org) |
| Launcher | [Walker](https://github.com/abenz1267/walker) + Elephant |
| Bar | [Waybar](https://github.com/Alexays/Waybar) |
| Notifications | [Dunst](https://dunst-project.org) |
| Lock screen | [Hyprlock](https://github.com/hyprwm/hyprlock) |
| Idle daemon | [Hypridle](https://github.com/hyprwm/hypridle) |
| Wallpaper | Hyprpaper + mpvpaper |
| File manager | Dolphin + Yazi |
| Shell font | JetBrainsMono Nerd Font |

## Installation

> This project is still being validated for clean Arch installations. Test it
> in a VM or a secondary user account before applying it to an existing desktop.

```bash
git clone https://github.com/yafte/hyprland-dots
cd hyprland-dots
chmod +x install.sh
./install.sh
```

The installer copies the included configuration to `~/.config`. Existing
configuration directories are copied to
`~/.local/state/hyprland-dots/backups/<timestamp>/` first; pass `--no-backup`
only when that recovery copy is not needed. On a fresh installation, it selects
Black Ember as the default theme.

### Dependencies

```bash
# Arch Linux / EndeavourOS
paru -S hyprland hyprpaper hyprlock hypridle waybar walker elephant-all \
  dunst ghostty mpvpaper grim slurp wl-clipboard cliphist playerctl jq \
  brightnessctl ddcutil swayosd polkit-kde-agent uwsm wireplumber pipewire \
  nerd-fonts-jetbrains-mono yazi figlet
```

## Black Ember wallpapers

Black Ember expects these optional personal assets:

```text
~/Wallpapers/black_ember/
├── black-ember-watercolor-horizontal.png
└── black-ember-watercolor-vertical.png
```

The wallpaper script applies the horizontal image to regular monitors and the
vertical image to monitors rotated with transform `1` or `3`.

Time-based and video wallpaper shortcuts use this separate structure:

```text
~/Wallpapers/
├── morning/
├── afternoon/
├── night/
└── video/
```

## Key bindings

| Binding | Action |
| --- | --- |
| `Super + Q` | Open Ghostty |
| `Super + W` | Close focused window |
| `Super + E` | Open Dolphin |
| `Super + Space` | Open Walker |
| `Super + Alt + Space` | Open the system menu |
| `Super + Ctrl + T` | Open the personal theme selector |
| `Super + L` | Lock the session |
| `Super + V` | Toggle the focused window's floating state |
| `Super + Return` | Rotate the Spiral layout |
| `Super + F5` to `F8` | Morning, afternoon, night, and video wallpapers |
| `Print` / `Shift + Print` | Region / full-screen screenshot to clipboard |

## Hardware profiles

The default profile uses every monitor's preferred mode and requires no output
names. Your current ultrawide-plus-vertical-monitor layout is preserved in the
optional `yafte-desktop` profile. Start Hyprland with the desired profile:

```bash
HYPRLAND_PROFILE=yafte-desktop Hyprland
```

The orientation shortcut (`Super + Ctrl + O`) is enabled only by profiles that
define an `orientation` section. The DDC/CI brightness script is also optional;
remove or adapt its bindings when the display does not support DDC/CI.

## License

[MIT](LICENSE)
