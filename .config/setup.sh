# fzf
if which fzf &>/dev/null; then
	export FZF_DEFAULT_OPTS=" \
		--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
		--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
		--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
		--color=selected-bg:#45475A \
		--color=border:#313244,label:#CDD6F4"
	source <(fzf --zsh)
fi

# ripgrep (replaces grep)
if which rg &>/dev/null; then
	alias grep="rg -i"
fi

# fd (replaces find)
if which fd &>/dev/null; then
	alias find="fd"
fi

# dust (replaces du)
if which dust &>/dev/null; then
	alias du="dust"
fi

# eza (replaces ls)
if which eza &>/dev/null; then
	alias ls="eza --icons=auto"
	alias tree="eza --icons=auto --tree"
fi

# bat (replaces cat)
if which bat &>/dev/null; then
	alias cat="bat -p"
fi

# zoxide (replaces cd)
if which zoxide &>/dev/null; then
	eval "$(zoxide init zsh --cmd cd)"
fi

# direnv
if which direnv &>/dev/null; then
	eval "$(direnv hook zsh)"
fi

# gnu sed (replaces sed)
if which gsed &>/dev/null; then
	alias sed="gsed"
fi

# rsync
if which rsync &>/dev/null; then
	alias cpr="rsync --info=progress2 --info=name0"
	alias mvr="rsync --info=progress2 --info=name0 --remove-source-files --archive"
fi

# nvim
if which nvim &>/dev/null; then
	alias vim="nvim"
fi

# xclip
if which xclip &>/dev/null; then
	alias xclip="xclip -se c"
fi

# tailscale needs special handling on mac
if [[ -f /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# yazi
if which yazi &>/dev/null; then
	y() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
		yazi "$@" --cwd-file="$tmp"
		if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
			builtin cd -- "$cwd"
		fi
		rm -f -- "$tmp"
	}
fi

# kubectl
if which kubectl &>/dev/null && which kubecolor &>/dev/null; then
	alias kubectl="kubecolor"
fi

# asdf
if which asdf &>/dev/null; then
	if [[ ! -d "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" ]]; then
		echo "Creating completions for asdf"
		mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
		asdf completion zsh >"${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
	fi
	export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
	fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
	. ~/.asdf/plugins/golang/set-env.zsh
	export FLUTTER_ROOT="$(asdf where flutter)"
fi

# fzf-tab
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
# NOTE: The use-fzf-default-opts may lead to unexpected behavior since some flags break this plugin. See https://github.com/Aloxaf/fzf-tab/issues/455
zstyle ':fzf-tab:*' use-fzf-default-opts yes
source ~/somewhere/fzf-tab.plugin.zsh

# zsh-system-clipboard
if [[ -f ${ZSH_CUSTOM:-$HOME/.zsh}/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh ]]; then
	source "${ZSH_CUSTOM:-$HOME/.zsh}/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

# zsh-auto-suggestions
if [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	unset ZSH_AUTOSUGGEST_USE_ASYNC # To fix incompatibility issue: https://github.com/romkatv/powerlevel10k/issues/1554#issuecomment-1701598955
fi

# zsh-syntax-highlighting (Note this must be the near? last command in .zshrc)
if [[ -f ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ]]; then
	source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
	source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
