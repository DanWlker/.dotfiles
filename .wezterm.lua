local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Edge Dark (base16)"
-- config.color_scheme = "Kasugano (terminal.sexy)"
-- config.color_scheme = "kanagawabones"
-- config.color_scheme = "Catppuccin Frappe"
-- config.color_scheme = "rose-pine"

-- [[ Font ]]
-- JetbrainsMono Nerd Font
-- Monaspace Neon
-- MonoLisa Nerd Font
-- CommitMono Nerd Font
-- FiraCode Nerd Font
-- Maple Mono NF
local fontName = "JetbrainsMono Nerd Font"
config.font = wezterm.font(fontName)
config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font(fontName, { weight = "Bold", stretch = "Normal", style = "Normal" }),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font(fontName, { weight = "Bold", stretch = "Normal", style = "Italic" }),
	},
}
config.font_size = 16
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true
config.front_end = "WebGpu"
return config
