# Other no configuration plugins as a record of what to install when moving to new laptop:
# stow
# tldr
# tmux
# tmp

echo -ne '\e[6 q' # Use beam shape cursor on startup.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Start tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new -As0
fi

setopt inc_append_history
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# fzf
eval "$(fzf --zsh)"

# ripgrep (replaces grep)
alias grep="rg"

# fd (replaces find)
alias find="fd"

# dust (replaces du)
alias du="dust"

# eza (replaces ls)
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"

# bat (replaces cat)
alias cat="bat -p"

# zoxide (replaces cd)
eval "$(zoxide init zsh --cmd cd)"

# gnu sed (replaces sed)
alias sed="gsed"

# fzf-tab
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
autoload -U compinit; compinit
source ~/somewhere/fzf-tab.plugin.zsh

# powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# zsh-auto-suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
unset ZSH_AUTOSUGGEST_USE_ASYNC # To fix incompatibility issue: https://github.com/romkatv/powerlevel10k/issues/1554#issuecomment-1701598955

# zsh-syntax-highlighting (Note this must be the near? last command in .zshrc)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# vi mode
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.
# Set cursor style (DECSCUSR), VT520.
# 0  ⇒  blinking block.
# 1  ⇒  blinking block (default).
# 2  ⇒  steady block.
# 3  ⇒  blinking underline.
# 4  ⇒  steady underline.
# 5  ⇒  blinking bar, xterm.
# 6  ⇒  steady bar, xterm.

# others
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
export EDITOR=nvim
