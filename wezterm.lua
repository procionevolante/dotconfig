-- wezterm configuration.

-- Place this in ~/.wezterm.lua (linux) or %USERPROFILE%\.wezterm.lua (Windows)

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- modify config obj to set configuration

-- keybindings
config.keys = {
  -- disable "new tab"
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- disable "close current tab"
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

-- styling
config.color_scheme = 'Monokai Vivid'
config.colors = {
    foreground = '#fbfbfb',
    background = '#000000',

    cursor_bg = '#ffffff',
    cursor_fg = '#000000',
}
-- make ANSI "blue" a little brighter for readability:
-- borrow its definition from mintty's
-- [hemlholtz theme](https://github.com/mintty/mintty/blob/master/themes/helmholtz)
local blue_idx = 5
config.colors.ansi = wezterm.get_builtin_color_schemes()[config.color_scheme].ansi
config.colors.brights = wezterm.get_builtin_color_schemes()[config.color_scheme].brights
config.colors.ansi[blue_idx] = '#005dff'
config.colors.brights[blue_idx] = '#7d97ff'
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.font = wezterm.font('Cascadia Mono')
config.font_size = 11.0

-- minimize window padding to not waste space
config.window_padding = {
    left = '1pt',
    right = '1pt',
    top = '1pt',
    bottom = '1pt',
}

-- specific TERM variable. Install wezterm terminfo for this to work,
-- see wezfurlong.org/wezterm/config/lua/config/term.html for more details
config.term = 'wezterm'

-- windows specific cfg
if string.find(wezterm.target_triple, 'windows') then
    -- run default WSL distro
    -- arrays in lua start at index 1...
    config.default_domain = wezterm.default_wsl_domains()[1].name
else -- linux specific cfg
    config.window_background_opacity = 0.85
end

-- return modified config
return config
