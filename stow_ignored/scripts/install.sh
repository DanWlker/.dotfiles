# Ask for admin priviledge upfront
sudo -v

# Install zsh if on linux
if [ "$(uname)" != "Darwin" ]; then
	sudo apt-get update
	sudo apt install curl zsh gcc
fi

# Download brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "~/.linuxbrew" ]; then
  eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Download dependencies
xargs -n 1 brew install < $HOME/.dotfiles/stow_ignored/my_brews

# Verify everything is installed
chmod +x $HOME/.dotfiles/stow_ignored/scripts/verify.sh
$HOME/.dotfiles/stow_ignored/scripts/verify.sh

# Link stuff in the correct location
cd ~/.dotfiles/ && stow .
