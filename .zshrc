if [ -d "/opt/homebrew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "~/.linuxbrew" ]; then
	eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew" ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

## Start tmux
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
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

if [[ -f $(brew --prefix 2>/dev/null)/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
	source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
	[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
fi

# options
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=120000 # https://zsh.sourceforge.io/Doc/Release/Options.html#index-HIST_005fEXPIRE_005fDUPS_005fFIRST
export SAVEHIST=100000
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt globdots
setopt nobeep
setopt numeric_glob_sort
setopt complete_in_word  # Complete from both ends of a word
setopt always_to_end     # Move cursor to the end of a completed word
setopt path_dirs         # Perform path search even on command names with slashes
setopt auto_menu         # Show completion menu on a succesive tab press
setopt auto_list         # Automatically list choices on ambiguous completion
setopt auto_remove_slash # Remove trailing slashes
setopt auto_param_slash  # If completed parameter is a directory, add a trailing slash
setopt glob_complete     # Show completions for glob instead of expanding
unsetopt menu_complete   # Do not autoselect the first completion entry
unsetopt flow_control    # Disable start/stop characters in shell editor
unsetopt case_glob
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
# vi mode
bindkey -v
export KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char # fix backspace sometimes not working
zstyle ':completion:*' menu select
# case insensitive matching + ignore separators (. _ -) + substring matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# aliases
alias whoami="whoami && curl ident.me"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias ln='ln -iv'
alias mkdir="mkdir -pv"
mkcd() {
	[[ $# -ne 1 ]] && return 1
	mkdir -p -- "$1" && cd -- "$1" || return 1
}

# Local dependencies
export PATH="$HOME/.local/bin:$PATH"

# Setup commands
source ~/.config/setup.zsh
if [ -f ~/.local/setup.zsh ]; then
	source ~/.local/setup.zsh
fi

# run compinit only after all completion definitions are set up
autoload -Uz compinit && compinit
