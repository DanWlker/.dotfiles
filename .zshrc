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
setopt share_history          # Import new commands from $HISTFILE and append yours to it as they're typed — history is live-shared across every open shell. Supersedes inc_append_history (docs say to turn that one off if this is set).
setopt hist_ignore_space      # Don't record lines whose first character is a space.
setopt hist_ignore_all_dups   # When a new line duplicates an older one, drop the OLDER entry — anywhere in history, not just the previous event. Result: one copy of each command, always at the newest spot.
setopt hist_save_no_dups      # When writing the history file, omit older commands that duplicate newer ones. Mostly a safety net here (see below).
setopt hist_find_no_dups      # When searching history in the line editor (Ctrl+R, arrow search), don't show a line already found, even if the duplicates aren't adjacent.
setopt hist_expire_dups_first # When history is full and must be trimmed, discard the oldest duplicated event before sacrificing a unique one. Requires HISTSIZE > SAVEHIST to have any cushion to work in.
setopt globdots               # Alias for GLOB_DOTS: globs no longer require a leading '.' to be typed explicitly, so '*' matches dotfiles too. (Careful: 'rm *' and 'mv * dir' now hit .git, .env, etc.)
setopt nobeep                 # Inverts BEEP — no terminal bell on line-editor errors.
setopt numeric_glob_sort      # Sort numeric filenames matched by a glob numerically rather than lexicographically: file2 before file10, not after.
setopt complete_in_word       # Complete from both ends of a word
setopt always_to_end          # Move cursor to the end of a completed word
setopt path_dirs              # Perform path search even on command names with slashes
setopt auto_menu              # Show completion menu on a succesive tab press
setopt auto_list              # Automatically list choices on ambiguous completion
setopt auto_remove_slash      # Remove trailing slashes
setopt auto_param_slash       # If completed parameter is a directory, add a trailing slash
setopt glob_complete          # Show completions for glob instead of expanding
unsetopt menu_complete        # Do not autoselect the first completion entry
unsetopt flow_control         # Disable start/stop characters in shell editor
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
# courtesy of: https://www.hypertesto.me/en/blog/2026/08/curlese-five-years-later/
alias curlopsy="curl -o /dev/null -s -w 'dns:%{time_namelookup} connect:%{time_connect} tls:%{time_appconnect} total:%{time_total} http:%{http_code}\n'"
alias curl='curl -v --trace-time -w "\n======\nTotal Took: %{time_total} | TCP connection took: %{time_connect} | TLS/SSL connection took: %{time_appconnect}\n=====\n"'
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
