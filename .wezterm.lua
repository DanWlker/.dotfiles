local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Edge Dark (base16)"
-- config.color_scheme = "Kasugano (terminal.sexy)"
-- config.color_scheme = "kanagawabones"
-- config.color_scheme = "Catppuccin Frappe"
-- config.color_scheme = "Tokyo Night"
-- config.color_scheme = "rose-pine"
config.font = wezterm.font("Fira Code")
config.font_size = 14
config.window_decorations = "RESIZE"
return config
