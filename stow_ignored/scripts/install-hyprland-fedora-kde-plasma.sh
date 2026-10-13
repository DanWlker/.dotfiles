#!/usr/bin/env bash

# Ask for admin priviledge upfront
sudo -v

sudo dnf copr enable -y lionheartp/Hyprland
sudo dnf copr enable -y erikreider/swayosd
sudo dnf copr enable -y imput/helium

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
	# From KDE (already present with Plasma): KWallet unlock at login (autostart runs pam_kwallet_init),
	# and System Settings for waybar's bluetooth/network on-click (kcm_bluetooth, kcm_networkmanagement)
	pam-kwallet kf6-kwallet plasma-systemsettings
)
sudo dnf install "${PACKAGES[@]}"

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

# Manual steps not covered here:
# - Font: Maple Mono NF (used by kitty, waybar, fuzzel, hyprlock) is installed by hand into ~/.local/share/fonts
# - Optional Caps Lock OSD (root service that watches keyboards):
#     sudo systemctl enable --now swayosd-libinput-backend.service
