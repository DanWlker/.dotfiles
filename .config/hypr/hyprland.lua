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

-- uwsm-app is safe for parallel autostart as of uwsm 0.27 (fixed in a404d04)
-- https://github.com/Vladimir-csp/uwsm/issues/107
-- "-s b" puts long-running services in the background slice
hl.on("hyprland.start", function()
	-- Hand the session env to ksecretd so the PAM-unlocked wallet registers on D-Bus.
	-- Its XDG autostart entry has X-systemd-skip=true (Plasma runs it itself), so uwsm skips it.
	hl.exec_cmd("/usr/libexec/pam_kwallet_init")
	-- Polkit agent; started here rather than enabled so it doesn't clash with Plasma's agent
	hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
	-- Notifications; guarded to Hyprland by mako.service.d/hyprland-only.conf so it can't race plasmashell
	hl.exec_cmd("systemctl --user start mako.service")
	-- Audio is stopped on logout (see SUPER+SHIFT+Q); bring it back fresh
	hl.exec_cmd("systemctl --user start pipewire pipewire-pulse wireplumber")
	hl.exec_cmd("uwsm-app -s b -- hyprpaper")
	hl.exec_cmd("uwsm-app -s b -- waybar")
	hl.exec_cmd("uwsm-app -s b -- hypridle")
	-- Volume/brightness OSD (keybinds call swayosd-client)
	hl.exec_cmd("uwsm-app -s b -- swayosd-server")
	-- GTK apps (e.g. waybar, file dialogs) draw their own cursor from this GNOME setting, not from
	-- XCURSOR_THEME. Plasma may reset it, so set it on every Hyprland login.
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme posys_cursor_scalable_black")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
	-- Input method (in Plasma, KWin launches it instead: Virtual Keyboard -> Fcitx 5)
	hl.exec_cmd("uwsm-app -s b -- fcitx5 -d")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Set in ~/.config/uwsm/env (toolkit/cursor vars) and ~/.config/uwsm/env-hyprland (HYPR*/AQ_* vars),
-- as recommended on the Hyprland wiki's uwsm page.

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = { top = 2, left = 8, right = 8, bottom = 8 },

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

		-- Wake screens on input after DPMS off (defaults are false, which leaves screens dark
		-- if anything other than hypridle's on-resume turned them off)
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
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

		-- Mice: slower, no acceleration (same distance per hand movement at any speed).
		-- The trackpad is set back to defaults below, so this applies to every other pointer.
		sensitivity = -0.5, -- -1.0 - 1.0, 0 means no modification.
		accel_profile = "flat",

		-- MacBook trackpad, set up to behave like macOS's defaults
		touchpad = {
			natural_scroll = true, -- content follows your fingers
			scroll_factor = 0.1, -- scroll distance multiplier (default 1.0); lower = slower
			clickfinger_behavior = true, -- 2-finger click = right click, 3-finger = middle (not by click position)
			tap_to_click = false, -- macOS default: press to click
			disable_while_typing = true, -- palm rejection
		},

		-- Change speed of keyboard repeat
		repeat_delay = 350,
	},
})

-- 3-finger horizontal swipe switches workspaces, like swiping between Spaces on macOS
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

-- MacBook trackpad: keep libinput's defaults instead of the mouse settings above
hl.device({
	name = "apple-spi-trackpad",
	sensitivity = 0,
	accel_profile = "adaptive",
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Programs
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("uwsm-app -- kitty"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm-app -- helium"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm-app -- fuzzel"))

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
-- uwsm stop rather than hl.dsp.exit(), so systemd brings the session units down in order.
-- Stop audio first: WirePlumber 0.5.17 crashes or hangs when every session client disconnects at once.
hl.bind(
	mainMod .. " + SHIFT + Q",
	hl.dsp.exec_cmd("systemctl --user stop wireplumber pipewire-pulse pipewire; uwsm stop")
)
-- Lock through logind so hypridle's lock_cmd (pidof hyprlock || hyprlock) is the only way hyprlock starts
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("uwsm-app -- hyprshot -m region --freeze --clipboard"))
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
-- swayosd-client changes the value and shows the OSD (swayosd-server runs from autostart)
local osdKeys = {
	{ "XF86AudioRaiseVolume", "--output-volume +5", true },
	{ "XF86AudioLowerVolume", "--output-volume -5", true },
	{ "XF86AudioMute", "--output-volume mute-toggle", false },
	{ "XF86AudioMicMute", "--input-volume mute-toggle", false },
	{ "XF86MonBrightnessUp", "--brightness +10", true },
	{ "XF86MonBrightnessDown", "--brightness -10", true },
}
for _, k in ipairs(osdKeys) do
	hl.bind(k[1], hl.dsp.exec_cmd("swayosd-client " .. k[2]), { locked = true, repeating = k[3] })
end

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
