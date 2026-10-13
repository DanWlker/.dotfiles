#!/usr/bin/env bash

# Ask for admin priviledge upfront
sudo -v

read -rp "Enter your package install command (e.g. 'sudo apt install -y'): " INSTALL_CMD
read -rp "Enter your package update command (or leave blank to skip e.g. 'sudo apt-get update'): " UPDATE_CMD

# Fedora: Hyprland stack, swayosd and Helium come from COPRs
if command -v dnf >/dev/null; then
	sudo dnf copr enable -y lionheartp/Hyprland
	sudo dnf copr enable -y erikreider/swayosd
	sudo dnf copr enable -y imput/helium
fi

# Run update if provided
if [[ -n "$UPDATE_CMD" ]]; then
	eval "$UPDATE_CMD"
fi

# Install packages
PACKAGES=(
	# Compositor + session
	hyprland uwsm xdg-desktop-portal-hyprland qt5-qtwayland qt6-qtwayland
	# Hypr ecosystem: wallpaper, idle/lock, polkit prompt, dialogs, Qt6 theming
	hyprpaper hypridle hyprlock hyprpolkitagent hyprland-guiutils hyprqt6engine
	# Bar, launcher, notifications, OSD
	waybar fuzzel mako swayosd
	# Apps used by keybinds
	kitty helium-bin hyprshot
	# Media/brightness keys (wpctl comes from wireplumber)
	wireplumber brightnessctl playerctl
	# Input method (Chinese Pinyin); not fcitx5-autostart, Hyprland's autostart / Plasma's KWin launch it
	fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-qt6 fcitx5-configtool kcm-fcitx5
)
eval "$INSTALL_CMD ${PACKAGES[*]}"

# mako: only start under Hyprland. Its D-Bus activation file would otherwise let it
# grab org.freedesktop.Notifications in Plasma before plasmashell does.
mkdir -p "$HOME/.config/systemd/user/mako.service.d"
cat >"$HOME/.config/systemd/user/mako.service.d/hyprland-only.conf" <<'EOF'
# Only run mako under Hyprland. Its D-Bus activation file would otherwise
# let it grab org.freedesktop.Notifications in Plasma before plasmashell does.
[Service]
ExecCondition=
ExecCondition=/bin/sh -c '[ -n "$WAYLAND_DISPLAY" ] && [ "$XDG_CURRENT_DESKTOP" = Hyprland ]'
EOF
systemctl --user daemon-reload
