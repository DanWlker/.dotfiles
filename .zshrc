if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "~/.linuxbrew" ]; then
  eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

## Start tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new -As tmux
fi

## Start zellij
# modified from this command: zellij setup --generate-auto-start zsh
# if [[ -z "$ZELLIJ" ]]; then
#     zellij a main || zellij -s main || zellij
#     exit
# fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
	source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
	[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
fi

# options
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000
setopt inc_append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
autoload -Uz compinit && compinit
# vi mode
bindkey -v
export KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char # fix backspace sometimes not working

# aliases
alias whoami="whoami && curl ident.me"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias ln='ln -iv'
alias mkdir="mkdir -pv"
mkcd() {
	mkdir "$1" && cd "$1"
}
cherrypickremote() {
	git fetch "$1" "$2"
	git cherry-pick FETCH_HEAD
}

# Local dependencies
export PATH="$HOME/.local/bin:$PATH"

# Setup commands
source ~/.config/setup.sh
if [ -f ~/.local/setup.sh ]; then
	source ~/.local/setup.sh
fi


