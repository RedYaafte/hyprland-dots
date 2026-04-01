# hyprland-dots 🌙

Mi configuración personal de Hyprland para Arch/EndeavourOS.

## Preview

> *(agrega screenshots en `screenshots/` y actualiza aquí)*

## Stack

| Componente | Herramienta |
|---|---|
| Compositor | [Hyprland](https://hyprland.org) |
| Terminal | [Ghostty](https://ghostty.org) |
| Bar | [Waybar](https://github.com/Alexays/Waybar) |
| Launcher | [Rofi](https://github.com/davatorium/rofi) |
| Notificaciones | [Dunst](https://dunst-project.org) |
| Lock screen | [Hyprlock](https://github.com/hyprwm/hyprlock) |
| Idle daemon | [Hypridle](https://github.com/hyprwm/hypridle) |
| Wallpaper | [Hyprpaper](https://github.com/hyprwm/hyprpaper) + [mpvpaper](https://github.com/GhostNaN/mpvpaper) |
| File manager | [Yazi](https://yazi-rs.github.io) |
| Editor | Neovim (minimalista, sin plugins) |
| Font | JetBrainsMono Nerd Font |

## Características

- **Wallpapers dinámicos** por hora del día (morning/afternoon/night) + modo video con mpvpaper
- **Waybar** con doble barra: módulos de sistema, Spotify, cava visualizer, power menu
- **Tema oscuro** consistente basado en colores Catppuccin Mocha
- **Ghostty** con greeting script (figlet + lolcat + frases + Linear issues)
- **Hyprlock** con blur de pantalla, reloj y campo de contraseña con gradiente
- Layout **master** con mfact 0.70

## Instalación

```bash
git clone https://github.com/yafte/hyprland-dots
cd hyprland-dots
chmod +x install.sh
./install.sh
```

### Dependencias

```bash
# Arch / EndeavourOS
paru -S hyprland hyprpaper hyprlock hypridle waybar rofi dunst ghostty \
        mpvpaper grim slurp wl-clipboard cliphist playerctl \
        brightnessctl wireplumber pipewire nerd-fonts-jetbrains-mono \
        yazi figlet lolcat
```

### Wallpapers

Los wallpapers no están incluidos en el repo. Organízalos así:

```
~/Wallpapers/
├── morning/    # imágenes para 06:00–12:00
├── afternoon/  # imágenes para 12:00–19:00
├── night/      # imágenes para 19:00–06:00
└── video/      # videos .mp4 para mpvpaper
```

Atajos para cambiar modo manualmente:
- `Super + F5` → morning
- `Super + F6` → afternoon  
- `Super + F7` → night
- `Super + F8` → video

### Variables de entorno opcionales

```bash
# Para el greeting de Ghostty con Linear
export LINEAR_API_KEY="tu_api_key_aqui"
```

## Keybinds principales

| Atajo | Acción |
|---|---|
| `Super + Q` | Terminal (Ghostty) |
| `Super + R` | Launcher (Rofi) |
| `Super + E` | File manager (Dolphin) |
| `Super + C` | Cerrar ventana |
| `Super + L` | Bloquear pantalla |
| `Super + V` | Toggle flotante |
| `Super + Return` | Swap con master |
| `Print` | Screenshot región → clipboard |
| `Shift + Print` | Screenshot completo → clipboard |

## Licencia

MIT
