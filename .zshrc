# Other no configuration plugins as a record of what to install when moving to new laptop:
# stow
# tldr
# tmux
# tmp

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# Basic tab autocomplete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# zsh-auto-suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
unset ZSH_AUTOSUGGEST_USE_ASYNC # To fix incompatibility issue: https://github.com/romkatv/powerlevel10k/issues/1554#issuecomment-1701598955

# zsh-syntax-highlighting (Note this must be the near? last command in .zshrc)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# vi mode
bindkey -v
export KEYTIMEOUT=1
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

