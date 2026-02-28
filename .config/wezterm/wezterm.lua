-- wezterm.lua
-- Wezterm config file

local wezterm = require('wezterm')    -- Configuration module
local mux = wezterm.mux               -- Multiplexer layer module
local act = wezterm.action            -- Enum constructor to bind keys to actions
local home = wezterm.home_dir

-- NOTE(abi): config_builder object provides clear error messages.
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

--
-- Startup event callback
--
wezterm.on('gui-startup', function()
  local tab, pane, window = mux.spawn_window({
      position = {
        x = 380,
        y = 220,
      },
      width = 85,
      height = 20,
  })
end)

--
-- Sane defaults
--
config.use_dead_keys = false
config.enable_wayland = false
config.scrollback_lines = 3000
config.exit_behavior = 'Close'
config.audible_bell = 'Disabled'
config.window_close_confirmation = 'NeverPrompt'
config.check_for_updates_interval_seconds = 1209600
config.harfbuzz_features = { 'calt = 1', 'clig = 1', 'liga = 1', 'zero' }
config.adjust_window_size_when_changing_font_size = false
config.canonicalize_pasted_newlines = 'None'
config.max_fps = 120

-- Hardware accelerated rasterization
config.front_end = 'WebGpu'
config.prefer_egl = true
config.webgpu_force_fallback_adapter = false
config.webgpu_power_preference = 'HighPerformance'

-- Default shell
config.default_prog = { "zsh" }

-- Environment variables
config.set_environment_variables = {
  XDG_CONFIG_HOME = home .. '/.config',
  XDG_CACHE_HOME = home .. '/.cache',
  XDG_DATA_HOME = home .. '/.local/share'
}

-- Startup working directory & workspace
config.default_workspace = "main"
config.default_cwd = home .. '/dev'

--
-- Look & feel
--
config.color_scheme = 'Catppuccin Mocha'
config.line_height = 1.2

-- Window
config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.9
config.window_padding = {
  left = '1.3cell',
  right = '1.3cell',
  top = '0.6cell',
  bottom = '0.6cell',
}

-- Panes
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6
}

-- Cursor
config.default_cursor_style = 'SteadyBlock'

-- Fonts
config.font = wezterm.font_with_fallback {
    { family='CaskaydiaCove Nerd Font', weight='Regular', scale = 1.0 },
    { family = "Symbols Nerd Font Mono", scale = 1.0 }
}
config.font_size = 13
config.cell_width = 1.05
config.use_cap_height_to_scale_fallback_fonts = false
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'
config.freetype_load_flags = 'DEFAULT'

-- Tab bar
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.status_update_interval = 1000

function basename(s)
  if type(s) ~= "string" then return "" end
  return string.gsub(s, "(.*[/\\])", "")
end

-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html
function tab_title(tab_info)
  return tostring(tab_info.tab_index + 1)
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#333333'
    local background = '#292929'
    local foreground = '#7a7d84'

    if tab.is_active then
      background = '#222222'
      foreground = '#d8dee9'
    elseif hover then
      background = '#252525'
      foreground = '#a3a8b0'
    end

    local edge_foreground = background
    local title = tab_title(tab)

    local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

    return {
      { Background = { Color = edge_foreground } },
      { Foreground = { Color = edge_foreground } },
      { Text = "  " },
      -- { Background = { Color = edge_foreground } },
      { Foreground = { Color = foreground } },
      { Text = title },
      -- { Background = { Color = background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW .. " " },
    }
  end
)

wezterm.on('update-right-status', function(window, pane)
  -- Workspace
  local ws = window:active_workspace()
  
  -- Current process
  -- TODO(abi): fix string / nil issue, check debug overlay...
  local fg_process = basename(pane:get_foreground_process_name())
  
  local nf = wezterm.nerdfonts
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#7dcfff" }},
    { Text = nf.cod_symbol_method .. " " .. ws .. "  "},
    { Foreground = { Color = "#e0af68" }},
    { Text = nf.fa_code .. " " .. fg_process .. "  "},
  }))
end)

--
-- Domains
--
config.default_domain = 'local'
config.wsl_domains = {
    {
    name = 'WSL:udev',
    distribution = 'udev',
    username = "abi",
    default_cwd = "~",
    default_prog = { "zsh" }
  },
}

--
-- Keyboard shortcuts
--
local my_keys = {}

-- Tabs
table.insert(my_keys, { key = 't', mods = 'CTRL', action = act({ SpawnTab = 'CurrentPaneDomain' }) })
table.insert(my_keys, { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab { confirm = false } })

table.insert(my_keys, { key = 'n', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) })
table.insert(my_keys, { key = 'p', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) })

for i = 1, 8 do
  table.insert(my_keys, { key = tostring(i), mods = 'ALT', action = act({ ActivateTab = i - 1 }), })
end

-- Panes
table.insert(my_keys, { key = 'i', mods = 'ALT', action = act({ SplitVertical = { domain = 'CurrentPaneDomain' } }) })
table.insert(my_keys, { key = 'o', mods = 'ALT', action = act({ SplitHorizontal = { domain = 'CurrentPaneDomain'} }) })

table.insert(my_keys, { key = 'h', mods = 'ALT|SHIFT', action = act({ ActivatePaneDirection = 'Left' }) })
table.insert(my_keys, { key = 'j', mods = 'ALT|SHIFT', action = act({ ActivatePaneDirection = 'Down' }) })
table.insert(my_keys, { key = 'k', mods = 'ALT|SHIFT', action = act({ ActivatePaneDirection = 'Up' }) })
table.insert(my_keys, { key = 'l', mods = 'ALT|SHIFT', action = act({ ActivatePaneDirection = 'Right' }) })

table.insert(my_keys, { key = 'h', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Left', 1 } })
table.insert(my_keys, { key = 'j', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Down', 1 } })
table.insert(my_keys, { key = 'k', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Up', 1 } })
table.insert(my_keys, { key = 'l', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Right', 1 } })

-- Miscellaneous actions
table.insert(my_keys, { key = 'c', mods = 'ALT', action = act.ActivateCopyMode })
table.insert(my_keys, { key = 'q', mods = 'ALT', action = act.QuickSelect })
table.insert(my_keys, { key = 'l', mods ='ALT', action = act.QuickSelectArgs { patterns = { "^.+$" } , } , })
table.insert(my_keys, { key = 's', mods = 'ALT', action = act.Search { CaseSensitiveString = '' } })

table.insert(my_keys, { key = 'n', mods = 'ALT', action = act.TogglePaneZoomState })
table.insert(my_keys, { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette })
table.insert(my_keys, { key = 't', mods = 'CTRL|SHIFT', action = act.ShowTabNavigator })
table.insert(my_keys, { key = 'l', mods = 'CTRL|SHIFT', action = act.ShowLauncher })
table.insert(my_keys, { key = 'u', mods = 'CTRL|SHIFT', action = act.CharSelect })
table.insert(my_keys, { key = 'd', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay })

-- config.disable_default_key_bindings = true
config.keys = my_keys

return config



-- -- Keys
-- config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
-- config.keys = {
--   -- Send C-a when pressing C-a twice
--   { key = "a",          mods = "LEADER|CTRL", action = act.SendKey { key = "a", mods = "CTRL" } },
--   { key = "c",          mods = "LEADER",      action = act.ActivateCopyMode },
--   { key = "phys:Space", mods = "LEADER",      action = act.ActivateCommandPalette },

--   -- Pane keybindings
--   { key = "s",          mods = "LEADER",      action = act.SplitVertical { domain = "CurrentPaneDomain" } },
--   { key = "v",          mods = "LEADER",      action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
--   { key = "h",          mods = "LEADER",      action = act.ActivatePaneDirection("Left") },
--   { key = "j",          mods = "LEADER",      action = act.ActivatePaneDirection("Down") },
--   { key = "k",          mods = "LEADER",      action = act.ActivatePaneDirection("Up") },
--   { key = "l",          mods = "LEADER",      action = act.ActivatePaneDirection("Right") },
--   { key = "q",          mods = "LEADER",      action = act.CloseCurrentPane { confirm = true } },
--   { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
--   { key = "o",          mods = "LEADER",      action = act.RotatePanes "Clockwise" },
--   -- We can make separate keybindings for resizing panes
--   -- But Wezterm offers custom "mode" in the name of "KeyTable"
--   { key = "r",          mods = "LEADER",      action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

--   -- Tab keybindings
--   { key = "t",          mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
--   { key = "[",          mods = "LEADER",      action = act.ActivateTabRelative(-1) },
--   { key = "]",          mods = "LEADER",      action = act.ActivateTabRelative(1) },
--   { key = "n",          mods = "LEADER",      action = act.ShowTabNavigator },
--   {
--     key = "e",
--     mods = "LEADER",
--     action = act.PromptInputLine {
--       description = wezterm.format {
--         { Attribute = { Intensity = "Bold" } },
--         { Foreground = { AnsiColor = "Fuchsia" } },
--         { Text = "Renaming Tab Title...:" },
--       },
--       action = wezterm.action_callback(function(window, pane, line)
--         if line then
--           window:active_tab():set_title(line)
--         end
--       end)
--     }
--   },
--   -- Key table for moving tabs around
--   { key = "m", mods = "LEADER",       action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },
--   -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
--   { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
--   { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

--   -- Lastly, workspace
--   { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },

-- }
-- -- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
-- for i = 1, 9 do
--   table.insert(config.keys, {
--     key = tostring(i),
--     mods = "LEADER",
--     action = act.ActivateTab(i - 1)
--   })
-- end

-- config.key_tables = {
--   resize_pane = {
--     { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
--     { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
--     { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
--     { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
--     { key = "Escape", action = "PopKeyTable" },
--     { key = "Enter",  action = "PopKeyTable" },
--   },
--   move_tab = {
--     { key = "h",      action = act.MoveTabRelative(-1) },
--     { key = "j",      action = act.MoveTabRelative(-1) },
--     { key = "k",      action = act.MoveTabRelative(1) },
--     { key = "l",      action = act.MoveTabRelative(1) },
--     { key = "Escape", action = "PopKeyTable" },
--     { key = "Enter",  action = "PopKeyTable" },
--   }
-- }

-- config.leader = { key = 'RightAlt', mods = 'ALT'} -- wezterm --config debug_key_events=true

--   keys = {
--     {key="U",mods="CTRL",action=act.ScrollByPage(-0.5)},
--     {key="D",mods="CTRL",action=act.ScrollByPage(0.5)},
--     {key="K",mods="CTRL",action=act.ScrollByLine(-1)},
--     {key="J",mods="CTRL",action=act.ScrollByLine(1)},
--     {key="E", mods="CTRL", -- open url
--       action=wezterm.action.QuickSelectArgs{
--         patterns={
--           "https?://\\S+"
--         },
--         action = wezterm.action_callback(function(window, pane)
--           local url = window:get_selection_text_for_pane(pane)
--           wezterm.log_info("opening: " .. url)
--           wezterm.open_with(url)
--         end)
--       }
--     },
--   },

--   key_tables = {
--     search_mode = {
--       {key="Escape",mods='NONE',action=act.Multiple{act.CopyMode'Close',act.CopyMode'ClearPattern'}},
--       {key="Enter",mods='NONE',action=act.Multiple{act.CopyTo'Clipboard',act.CopyMode'Close',act.CopyMode'ClearPattern'}},
--       {key="p",mods='CTRL',action=act.CopyMode'PriorMatch'},
--       {key="n",mods='CTRL',action=act.CopyMode'NextMatch'},
--       {key="r",mods='CTRL',action=act.CopyMode'CycleMatchType'},
--       {key="u",mods='CTRL',action=act.CopyMode'ClearPattern'},
--     },
--   },

-- config.launch_menu  = {
--    {
--       label = "wsl",
--       args = { "wsl.exe" },
--       domain = { DomainName = "local" },
--       cwd = "\\\\wsl$\\Ubuntu-20.04\\home\\pw\\Dev"
--    },
--    {
--       label = "pwsh",
--       args = { os.getenv("LOCALAPPDATA") .. "\\Microsoft\\WindowsApps\\pwsh.exe", "-nologo" },
--       domain = { DomainName = "local" },
--       cwd = "D:\\Dev",
--    }
-- }
