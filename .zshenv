export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export MANPAGER='nvim +Man!'

if [ -f ~/.local/env.sh ]; then
	source ~/.local/env.sh
fi
