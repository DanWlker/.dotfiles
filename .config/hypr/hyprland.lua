local mocha = require("mocha")

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-------------------
---- AUTOSTART ----
-------------------

-- TODO: check uwsm -v, should change to uwsm-app after versions later than the commit date is upgraded
-- https://github.com/Vladimir-csp/uwsm/issues/107#issuecomment-2746316911
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- hyprpaper")
	hl.exec_cmd("uwsm app -- waybar")
	hl.exec_cmd("uwsm app -- hypridle")
	-- TODO: check these later
	-- hl.exec_cmd("uwsm app -- elephant")
	-- hl.exec_cmd("uwsm app -- walker --gapplication-service")
	-- hl.exec_cmd("uwsm app -- mako")
	-- hl.exec_cmd("uwsm app -- fcitx5 -d")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 6,
		gaps_out = { top = 8, left = 12, right = 12, bottom = 12 },

		border_size = 3,

		col = {
			active_border = { colors = { mocha.lavender, mocha.sky }, angle = 45 },
			inactive_border = mocha.surface1,
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 12,
		rounding_power = 4,

		-- Change transparency of focused and unfocused windows
		active_opacity = 0.92,
		inactive_opacity = 0.92,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = mocha.mantle,
		},

		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},
})

-- https://github.com/HyDE-Project/HyDE/tree/master/Configs/.config/hypr/animations
-- Classic
-- hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
-- hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
-- hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
-- hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
-- hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

-- LimeFrenzy
hl.curve("default", { type = "bezier", points = { { 0.12, 0.92 }, { 0.08, 1.0 } } })
hl.curve("wind", { type = "bezier", points = { { 0.12, 0.92 }, { 0.08, 1.0 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.18, 0.95 }, { 0.22, 1.03 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "wind", style = "popin 60%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "overshot", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "overshot", style = "popin 60%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "overshot", style = "slide" })
-- disabled because it interferes with hyprshot
-- hl.animation({ leaf = "layers",    enabled = true, speed = 4, bezier = "default",  style = "popin" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slidevert" })
-- hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner" })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 24, bezier = "liner", style = "loop" })

-- Theme
-- hl.curve("wind",   { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
-- hl.curve("winIn",  { type = "bezier", points = { {0.1, 1.1},  {0.1, 1.1}  } })
-- hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1}      } })
-- hl.curve("liner",  { type = "bezier", points = { {1, 1},      {1, 1}      } })
-- hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "wind",   style = "slide" })
-- hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6,  bezier = "winIn",  style = "slide" })
-- hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,  bezier = "winOut", style = "slide" })
-- hl.animation({ leaf = "windowsMove", enabled = true, speed = 5,  bezier = "wind",   style = "slide" })
-- hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner" })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "once" })
-- hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default" })
-- hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "wind" })

hl.config({
	-- dwindle.pseudotile is gone in 0.55; use the hl.dsp.window.pseudo() dispatcher instead
	dwindle = {
		preserve_split = true, -- You probably want this
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		-- kb_layout  = "",
		-- kb_variant = "",
		-- kb_model   = "",
		-- kb_options = "",
		-- kb_rules   = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},

		-- Change speed of keyboard repeat
		repeat_delay = 350,
	},
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Programs
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("uwsm app -- kitty"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- helium"))
-- hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm app -- walker"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm app -- nc -U /run/user/1000/walker/walker.sock"))

-- Notifications
hl.bind(mainMod .. " + COMMA", hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(mainMod .. " + SHIFT + COMMA", hl.dsp.exec_cmd("makoctl dismiss --all"))
-- hl.bind(mainMod .. " + CTRL + COMMA", hl.dsp.exec_cmd("makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send \"Silenced notifications\" || notify-send \"Enabled notifications\""))
hl.bind(mainMod .. " + ALT + COMMA", hl.dsp.exec_cmd("makoctl invoke"))
hl.bind(mainMod .. " + SHIFT + ALT + COMMA", hl.dsp.exec_cmd("makoctl restore"))

-- Windows
hl.bind(mainMod .. " + A", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- uwsm stop rather than hl.dsp.exit(), so systemd brings the session units down in order
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("uwsm app -- hyprlock"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("uwsm app -- hyprshot -m region --freeze --clipboard"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Overwrite ctrl c ctrl v
hl.bind(mainMod .. " + C", hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" }), { description = "Universal copy" })
hl.bind(
	mainMod .. " + V",
	hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }),
	{ description = "Universal paste" }
)
hl.bind(mainMod .. " + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X" }), { description = "Universal cut" })

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Move window using mainMod + SHIFT + arrows
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Resize window using mainMod + ALT + arrows
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
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

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- https://wiki.hypr.land/Useful-Utilities/Screen-Sharing/#xwayland
-- https://www.reddit.com/r/hyprland/comments/1l4hwbj/white_box_spawns_on_top_left_on_startup/
hl.window_rule({
	name = "hide-xwaylandvideobridge",
	match = { class = "(xwaylandvideobridge)" },
	opacity = "0.0",
	no_initial_focus = true,
	no_focus = true,
	no_anim = true,
	no_blur = true,
	max_size = { 1, 1 },
})

-- fix hyprshot screenshot artifact showing up
hl.layer_rule({
	name = "fade-selection",
	match = { namespace = "selection" },
	animation = "fade",
})
-- hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })
