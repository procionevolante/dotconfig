-- wezterm configuration.

-- Place this in ~/.wezterm.lua (linux) or %USERPROFILE%\.wezterm.lua (Windows)

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- modify config obj to set configuration

-- styling
config.color_scheme = 'Monokai Vivid'
config.colors = {
    foreground = '#fbfbfb',
    background = '#000000',

    cursor_bg = '#ffffff',
    cursor_fg = '#000000',
}
config.enable_scroll_bar = false
config.hide_tab_bar_if_only_one_tab = true
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

-- run WSL if on windows
if string.find(wezterm.target_triple, 'windows') then
    config.default_domain = 'WSL:Ubuntu-24.04'
end

-- return modified config
return config
