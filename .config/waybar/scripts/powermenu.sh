#!/usr/bin/env bash
# Power menu for the waybar power button and SUPER+SHIFT+Q (fuzzel in dmenu mode).
# Suspend is left out on purpose: on Asahi the external monitor doesn't reconnect after it.

choice=$(printf '%s\n' "Lock" "Log out" "Reboot" "Shut down" |
	fuzzel --dmenu --prompt "Power: " --lines 4 --width 20) || exit 0

case "$choice" in
*Lock) loginctl lock-session ;;
*"Log out") uwsm stop ;;
*Reboot) systemctl reboot ;;
*"Shut down") systemctl poweroff ;;
esac
