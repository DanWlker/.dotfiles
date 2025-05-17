# Ask for admin priviledge upfront
sudo -v

# Install zsh if on linux
if [ "$(uname)" != "Darwin" ]; then
	sudo apt-get update
	sudo apt install -y curl zsh gcc git xclip coreutils
fi

# Download brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "$HOME/.linuxbrew" ]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

chmod +x "$HOME/.dotfiles/stow_ignored/scripts/verify.sh"

# Install mac specific ones first
if [ "$(uname)" == "Darwin" ]; then
	MAC_BREW_PATH=$HOME/.dotfiles/stow_ignored/brews/mac
	xargs -n 1 brew install < "$MAC_BREW_PATH"
	$HOME/.dotfiles/stow_ignored/scripts/verify.sh "$MAC_BREW_PATH"
fi

# Install common ones
COMMON_BREW_PATH=$HOME/.dotfiles/stow_ignored/brews/common
xargs -n 1 brew install < "$COMMON_BREW_PATH"
$HOME/.dotfiles/stow_ignored/scripts/verify.sh "$COMMON_BREW_PATH"

# Link stuff in the correct location
cd ~/.dotfiles/ && stow .
