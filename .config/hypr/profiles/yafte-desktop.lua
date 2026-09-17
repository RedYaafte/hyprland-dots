-- Current desktop layout. Enable it with HYPRLAND_PROFILE=yafte-desktop.
return {
    monitors = {
        { output = "HDMI-A-1", mode = "3440x1440@50", position = "0x0", scale = 1 },
        { output = "HDMI-A-2", mode = "1920x1080@60", position = "3440x0", scale = 1, transform = 1 },
    },
    orientation = {
        output = "HDMI-A-2",
        mode = "1920x1080@60",
        position = "3440x0",
        initial = "vertical",
    },
}
