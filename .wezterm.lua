local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Catppuccin Macchiato"
--config.color_scheme = "Catppuccin Frappe"
--config.color_scheme = "Tokyo Night"
-- config.color_scheme = 'rose-pine'
config.font = wezterm.font("MesloLGS NF")
return config
