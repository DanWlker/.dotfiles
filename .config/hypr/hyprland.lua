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
	-- Caelestia shell (fork in ~/.config/quickshell/caelestia): bar, launcher, notifications, OSD, lock,
	-- idle, wallpaper, session menu and the polkit agent (the password prompt for admin actions; it replaced
	-- hyprpolkitagent, and only one agent can register per session).
	-- Needs QML_IMPORT_PATH and CAELESTIA_LIB_DIR from ~/.config/uwsm/env.
	hl.exec_cmd("uwsm-app -s b -- qs -c caelestia -n -d")
	-- GTK apps (e.g. file dialogs) draw their own cursor from this GNOME setting, not from
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
		gaps_in = 6,
		gaps_out = 12,

		border_size = 3,

		col = {
			active_border = { colors = { mocha.lavender, mocha.sky }, angle = 45 },
			inactive_border = mocha.surface1,
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,
		layout = "master",
	},

	decoration = {
		rounding = 8,
		rounding_power = 4,

		-- Change transparency of focused and unfocused windows
		active_opacity = 0.9,
		inactive_opacity = 0.9,
		fullscreen_opacity = 0.9,

		shadow = {
			color = mocha.mantle,
			range = 8,
		},

		blur = {
			enabled = false,
		},
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

-- LimeFrenzy (speed = duration in tenths of a second)
hl.curve("default", { type = "bezier", points = { { 0.12, 0.92 }, { 0.08, 1.0 } } })
hl.curve("wind", { type = "bezier", points = { { 0.12, 0.92 }, { 0.08, 1.0 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.18, 0.95 }, { 0.22, 1.03 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "wind", style = "popin 60%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "overshot", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "overshot", style = "popin 60%" })
-- windowsMove slowed from 4 to 6 (0.6s)
hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, bezier = "overshot", style = "slide" })
-- disabled because it pops in slurp's selection overlay (region screenshots/recording)
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
		-- New windows always open to the right (or below), not on whichever side the cursor is
		force_split = 2, -- 0 = follow mouse (default), 1 = left/top, 2 = right/bottom
	},

	master = {
		new_on_active = "after",
	},

	scrolling = {
		column_width = 0.5,
	},

	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(

		-- Wake screens on input after DPMS off (defaults are false, which leaves screens dark
		-- if anything other than the idle return action turned them off)
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,

		-- Focus windows that ask for it (e.g. a link opened from another app switches to the browser)
		focus_on_activate = true,

		-- Let a new lock client take over if the lock screen dies while locked. The lock is part of the
		-- Caelestia shell, so a shell crash would otherwise leave the red "lockscreen died" screen
		-- (recoverable only from a TTY); restarting the shell now brings the lock back.
		allow_session_lock_restore = true,
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

		-- Mice: slower, no acceleration (same distance per hand movement at any speed).
		-- The trackpad is set back to defaults below, so this applies to every other pointer.
		sensitivity = -0.5, -- -1.0 - 1.0, 0 means no modification.
		accel_profile = "flat",

		-- MacBook trackpad, macOS-like (tap to click and palm rejection are Hyprland defaults, so not set here)
		touchpad = {
			natural_scroll = true, -- content follows your fingers
			scroll_factor = 0.1, -- scroll distance multiplier (default 1.0); lower = slower
			clickfinger_behavior = true, -- 2-finger click = right click, 3-finger = middle (not by click position)
		},

		-- Change speed of keyboard repeat
		repeat_delay = 350,
	},
})

-- 3-finger vertical swipe switches workspaces, like swiping between Spaces on macOS
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

-- Swipe feel (values from Caelestia's gestures.lua; its direction lock = on / 10px is Hyprland's default)
hl.config({
	gestures = {
		workspace_swipe_distance = 700, -- px of finger travel for a full workspace switch
		workspace_swipe_cancel_ratio = 0.15, -- let go before 15% of the way and it snaps back
		workspace_swipe_min_speed_to_force = 5, -- a quick flick switches even if short
	},
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
-- Caelestia's launcher (its global shortcuts are "caelestia:<name>", see CustomShortcut in the shell)
hl.bind(mainMod .. " + Return", hl.dsp.global("caelestia:launcher"))

-- Notifications: sidebar with the notification centre, and clear all
hl.bind(mainMod .. " + COMMA", hl.dsp.global("caelestia:sidebar"))
hl.bind(mainMod .. " + SHIFT + COMMA", hl.dsp.global("caelestia:clearNotifs"), { locked = true })

-- Windows
hl.bind(mainMod .. " + A", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
-- Pin: keep a floating window on top and visible on every workspace (float it with SUPER+F first)
hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- Caelestia's session menu (lock / log out / reboot / shut down)
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.global("caelestia:session"))
-- Lock through logind; Caelestia's lock screen listens for it (as does anything else that should lock)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
-- Restore the lock screen after the shell crashed while locked (needs misc.allow_session_lock_restore):
-- start the shell if it's gone, give it time to come up, then lock through its IPC. Works while locked.
hl.bind(
	mainMod .. " + ALT + L",
	hl.dsp.exec_cmd(
		"sh -c 'pgrep -x qs >/dev/null || uwsm-app -s b -- qs -c caelestia -n -d; sleep 2; qs -c caelestia ipc call lock lock'"
	),
	{ locked = true }
)
-- Caelestia's region picker on a frozen screen, copied to the clipboard
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.global("caelestia:screenshotFreezeClip"))
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
-- hl.bind(mainMod .. " + ALT + left", hl.dsp.layout("colresize -conf"))
-- hl.bind(mainMod .. " + ALT + right", hl.dsp.layout("colresize +conf"))
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

-- Laptop multimedia keys for volume and LCD brightness; Caelestia's OSD shows the change.
-- Volume through wpctl (the shell follows PipeWire), capped at 100% like before; raising unmutes.
local mediaKeys = {
	{
		"XF86AudioRaiseVolume",
		"wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
		true,
	},
	{ "XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", true },
	{ "XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", false },
	{ "XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", false },
	-- Brightness through the shell, which only tracks changes it makes itself. Always the laptop panel:
	-- Asahi has no DDC for the Dell, so the shell's own "brightnessUp" (focused monitor) would do nothing there.
	{ "XF86MonBrightnessUp", "qs -c caelestia ipc call brightness setFor eDP-1 +10%", true },
	{ "XF86MonBrightnessDown", "qs -c caelestia ipc call brightness setFor eDP-1 10%-", true },
}
for _, k in ipairs(mediaKeys) do
	hl.bind(k[1], hl.dsp.exec_cmd(k[2]), { locked = true, repeating = k[3] })
end

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Centre floating windows when they open (not XWayland ones: their popups/menus count as windows)
hl.window_rule({
	name = "center-floating",
	match = { float = true, xwayland = false },
	center = true,
})

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

-- Caelestia's layers (from its dots' rules.lua): no animation for the screen border and screenshot
-- picker, fade for the panels and wallpaper
hl.layer_rule({ match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true })
hl.layer_rule({ match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" })

-- slurp's selection overlay (record.sh region mode): fade instead of leaving an artifact
hl.layer_rule({
	name = "fade-selection",
	match = { namespace = "selection" },
	animation = "fade",
})
-- hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })
