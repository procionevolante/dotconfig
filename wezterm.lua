-- wezterm configuration.

-- Place this in ~/.wezterm.lua (linux) or %USERPROFILE%\.wezterm.lua (Windows)

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- modify config obj to set configuration

config.color_scheme = 'Hardcore (Gogh)'
config.colors = { foreground = '#fbfbfb' }
config.enable_scroll_bar = false

-- run WSL if on windows
if string.find(wezterm.target_triple, 'windows') then
    config.default_domain = 'WSL:Ubuntu-24.04'
end

config.font = wezterm.font('Cascadia Mono')
config.font_size = 11.0
config.hide_tab_bar_if_only_one_tab = true

-- return modified config
return config
