-- Personal Hyprland configuration for Hyprland 0.55+.
require("layouts.spiral")
require("apps.walker")

local home = os.getenv("HOME") or ""
local config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local theme = {
    active_border = "rgba(9370dbff)",
    inactive_border = "rgba(9370db55)",
}
local loaded, selected = pcall(dofile, home .. "/.config/themes/current/hyprland.lua")
if loaded and type(selected) == "table" then theme = selected end

local profile_name = os.getenv("HYPRLAND_PROFILE")
if not profile_name then
    local profile_file = io.open(config_home .. "/hypr/profile", "r")
    if profile_file then
        profile_name = profile_file:read("*l")
        profile_file:close()
    end
end
if type(profile_name) ~= "string" or not profile_name:match("^[%w_-]+$") then
    profile_name = "default"
end

local profile_path = config_home .. "/hypr/profiles/" .. profile_name .. ".lua"
local profile = {
    monitors = { { output = "", mode = "preferred", position = "auto", scale = 1 } },
}
local profile_loaded, selected_profile = pcall(dofile, profile_path)
if profile_loaded and type(selected_profile) == "table" then profile = selected_profile end

for _, monitor in ipairs(profile.monitors or {}) do hl.monitor(monitor) end

local terminal = "ghostty"
local file_manager = "dolphin"
local scripts = home .. "/.config/hypr/scripts/"

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper &")
    hl.exec_cmd("waybar")
    if profile.orientation then
        local rotation = profile.orientation
        hl.exec_cmd(string.format(
            "%s apply --output %q --mode %q --position %q --initial %q",
            scripts .. "toggle-hdmi-a-2-orientation.sh", rotation.output, rotation.mode,
            rotation.position, rotation.initial or "vertical"
        ))
    end
    hl.exec_cmd("dunst")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("pgrep -x swayosd-server >/dev/null || swayosd-server")
    hl.exec_cmd(scripts .. "wallpaper.sh")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

hl.config({
    general = {
        gaps_in = 5, gaps_out = 20, border_size = 2,
        col = { active_border = theme.active_border, inactive_border = theme.inactive_border },
        resize_on_border = false, allow_tearing = false, layout = "lua:spiral",
    },
    decoration = {
        rounding = 10, active_opacity = 1.0, inactive_opacity = 0.95, fullscreen_opacity = 1.0,
        shadow = { enabled = true, range = 4, render_power = 3, color = "rgba(1a1a1aee)" },
        blur = { enabled = true, size = 8, passes = 2, new_optimizations = true, vibrancy = 0.1696 },
    },
    dwindle = { preserve_split = true },
    misc = { force_default_wallpaper = -1, disable_hyprland_logo = false },
    input = {
        kb_layout = "us", kb_variant = "altgr-intl", follow_mouse = 1, sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 1}, {0.1, 1} } })
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "quick", style = "fade" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

local mod = "SUPER"
local launch_walker = scripts .. "launch-walker"
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(launch_walker))
hl.bind(mod .. " + ALT + SPACE", hl.dsp.exec_cmd(scripts .. "system-menu"))
hl.bind(mod .. " + CTRL + T", hl.dsp.exec_cmd(home .. "/.config/themes/select-theme-walker"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd(scripts .. "toggle_float.sh"))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
if profile.orientation then
    local rotation = profile.orientation
    hl.bind(mod .. " + CTRL + O", hl.dsp.exec_cmd(string.format(
        "%s toggle --output %q --mode %q --position %q --initial %q",
        scripts .. "toggle-hdmi-a-2-orientation.sh", rotation.output, rotation.mode,
        rotation.position, rotation.initial or "vertical"
    )))
end

for _, direction in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
end
for index = 1, 10 do
    local key = index % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = index }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = index }))
end
hl.bind(mod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + CTRL + SHIFT + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mod .. " + CTRL + SHIFT + right", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + Return", hl.dsp.layout("rotate"))
hl.bind(mod .. " + equal", hl.dsp.layout("grow"))
hl.bind(mod .. " + minus", hl.dsp.layout("shrink"))
hl.bind(mod .. " + bracketright", hl.dsp.layout("ratio 0.66"))
hl.bind(mod .. " + bracketleft", hl.dsp.layout("ratio 0.33"))

hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | tee ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim - | tee ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy]]))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + F5", hl.dsp.exec_cmd(scripts .. "wallpaper.sh morning"))
hl.bind(mod .. " + F6", hl.dsp.exec_cmd(scripts .. "wallpaper.sh afternoon"))
hl.bind(mod .. " + F7", hl.dsp.exec_cmd(scripts .. "wallpaper.sh night"))
hl.bind(mod .. " + F8", hl.dsp.exec_cmd(scripts .. "wallpaper.sh video"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scripts .. "volume-osd.sh up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scripts .. "volume-osd.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scripts .. "volume-osd.sh mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scripts .. "brightness-ddc.sh up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scripts .. "brightness-ddc.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ name = "fix-xwayland-drags", match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })
hl.window_rule({ name = "float-pavucontrol", match = { class = "^(pavucontrol)$" }, float = true, center = true, size = "65% 70%", animation = "popin" })
hl.window_rule({ name = "float-nm-connection-editor", match = { class = "^(nm-connection-editor)$" }, float = true, center = true, size = "60% 65%", animation = "popin" })
hl.window_rule({ name = "float-picture-in-picture", match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ name = "opacity-ghostty", match = { class = "^(ghostty)$" }, opacity = "0.9 0.9" })
hl.window_rule({ name = "fullscreen-personal-screensaver", match = { class = "^dev.yafte.screensaver$" }, fullscreen = true })
