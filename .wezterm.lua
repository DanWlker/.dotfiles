local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Catppuccin Macchiato"
--config.color_scheme = "Tokyo Night"
config.font = wezterm.font("Fira Code")
return config
