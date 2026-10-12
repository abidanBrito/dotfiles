-- hyprland.lua

local mocha = require("mocha")

------------------
---- MONITORS ----
------------------
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "-1920x0", scale = 1 })

---------------------
---- MY PROGRAMS ----
---------------------
local terminal          = "wezterm"
local terminalClassName = "org.wezfurlong.wezterm"
local editor            = "emacsclient -c -a emacs"
local browser           = "zen-browser"
local fileManager       = "thunar"
local menu              = "rofi -show drun"

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprshade auto")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("udiskie -t")
    hl.exec_cmd("pasystray --notify=all")
    hl.exec_cmd("emacs --daemon")
    hl.exec_cmd("thunar --daemon")
    hl.exec_cmd("~/.scripts/battery_watch.sh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("CLUTTER_BACKEND", "wayland")

-- NVidia drivers
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- NVidia hardware video acceleration
hl.env("NVD_BACKEND", "direct")

-- This supposedly helps fix flickering artifacts on laptops with NVIDIA GPUs
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- Fix flickering in Electron/CEF apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Pure GTK
hl.env("GDK_BACKEND", "wayland")

-- Force Qt apps to use the native Wayland QPA
hl.env("QT_QPA_PLATFORM", "wayland")

-- Prevent Qt apps from drawing their own window decorations
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Make all Firefox clones run natively instead of through XWayland
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Secure credential storage
hl.env("GNOME_KEYRING_CONTROL", "/run/user/1000/keyring")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in          = 3,
        gaps_out         = 6,
        border_size      = 2,
        col              = {
            active_border   = mocha.peach,
            inactive_border = mocha.overlay2,
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow           = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur             = {
            enabled  = true,
            size     = 7,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    -- Animations are globally disabled
    -- NOTE(abi): the curves/leaves below are kept so flipping `enabled = true` restores
    --            the original behaviour.
    animations = {
        enabled = false,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout          = "es",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "",
        kb_rules           = "",
        follow_mouse       = 1,
        sensitivity        = 0,
        numlock_by_default = true,
        repeat_delay       = 200,
        repeat_rate        = 50,
        touchpad           = {
            natural_scroll = true,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "ALT"

-- Master key switch (toggle keybindings on and off)
-- NOTE(abi): while in the "clean" submap only mainMod + T is live, which
--            returns to the default (reset) submap.
hl.define_submap("clean", function()
    hl.bind(mainMod .. " + T", hl.dsp.submap("reset"))
end)
hl.bind(mainMod .. " + T", hl.dsp.submap("clean"))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + CTRL + RETURN", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))          -- was: fullscreen, 1
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- was: fullscreen, 0

-- Hyprlock
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))

-- Hyprshot
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m active -m output"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m active -m window"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

-- Hyprshade
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("hyprshade toggle"))

-- Power menu (rofi)
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("~/.scripts/power_menu.sh"))

-- HDMI monitor menu (rofi)
hl.bind("SUPER + P", hl.dsp.exec_cmd("~/.scripts/monitor_menu.sh"))

-- Wifi menu (impala)
hl.bind("SUPER + W", hl.dsp.exec_cmd("kitty --title impala -e impala"))

-- Pavucontrol
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("pavucontrol"))

-- Temporary emacs frame for text input
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("emacsclient --eval '(abi/quick-text-input)'"))

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Switch workspaces (mainMod + [0-9]) and move active window (mainMod + SHIFT + [0-9])
for i = 1, 10 do
    local key = i % 10     -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- Floating windows
hl.window_rule({
    name   = "float-terminal",
    match  = { class = terminalClassName },
    float  = true,
    size   = "1200 600",
    center = true,
})

hl.window_rule({
    name   = "float-emacs-popup",
    match  = { class = "emacs", title = "emacs-float" },
    float  = true,
    size   = "900 400",
    center = true,
})

hl.window_rule({
    name  = "float-mpv",
    match = { class = "mpv" },
    float = true,
})

-- Ignore maximize request from apps
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Device TUIs
hl.window_rule({
    name      = "impala-devices",
    match     = { title = "impala" },
    tile      = true,
    workspace = "special:devices",
})
