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

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"

# ripgrep (replaces grep)
alias grep="rg -i"

# fd (replaces find)
alias find="fd"

# dust (replaces du)
alias du="dust"

# eza (replaces ls)
alias ls="eza --icons=auto"
alias tree="eza --icons=auto --tree"

# bat (replaces cat)
alias cat="bat -p"

# zoxide (replaces cd)
eval "$(zoxide init zsh --cmd cd)"

# direnv
eval "$(direnv hook zsh)"

# gnu sed (replaces sed)
alias sed="gsed"

# rsync (aliased for mv and cp to allow show progress, also rmb to install latest version using brew)
# alias cp="rsync --info=progress2 --info=name0"
# alias mv="rsync --info=progress2 --info=name0 --remove-source-files --archive"

# nvim
alias vim="nvim"

# xclip
if command -v xclip 2>&1 >/dev/null
then
  alias xclip="xclip -se c"
fi

# yazi
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

mkcd() {
    mkdir $1 ; cd $1
}

# asdf
if [ ! -d "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" ]; then
  echo "Creating completions for asdf"
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
fi
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
. ~/.asdf/plugins/golang/set-env.zsh
export FLUTTER_ROOT="$(asdf where flutter)"

# fzf-tab
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
autoload -Uz compinit && compinit # asdf also relies on this
source ~/somewhere/fzf-tab.plugin.zsh

# Local scripts
export PATH="$HOME/.local/bin:$PATH"

# powerlevel10k
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# zsh-auto-suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
unset ZSH_AUTOSUGGEST_USE_ASYNC # To fix incompatibility issue: https://github.com/romkatv/powerlevel10k/issues/1554#issuecomment-1701598955

# zsh-syntax-highlighting (Note this must be the near? last command in .zshrc)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# vi mode
bindkey -v
export KEYTIMEOUT=1
# https://github.com/kutsan/zsh-system-clipboard
source "${ZSH_CUSTOM:-$HOME/.zsh}/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"

# others
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

