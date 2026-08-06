HOMEBREW_PREFIX=$(brew --prefix)

# https://stackoverflow.com/a/677212
if command -v vivid >/dev/null 2>&1; then
	export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
	# https://medium.com/better-programming/boost-your-command-line-productivity-with-fuzzy-finder-985aa162ba5d
	if command -v fd >/dev/null 2>&1; then
		export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
		# CTRL-T's command
		export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
		# ALT-C's command
		export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
		_fzf_compgen_path() {
			fd . "$1"
		}
		_fzf_compgen_dir() {
			fd --type d . "$1"
		}
	fi
	if command -v rg >/dev/null 2>&1; then
		fgrep() {
			if [ ! "$" -gt 0 ]; then
				echo "Need a string to search for!"
				return 1
			fi
			rg --smart-case --hidden --files-with-matches --no-messages -g "!node_modules" -g "!.git" "$1" | fzf --multi $FZF_PREVIEW_WINDOW --preview "rg --smart-case --pretty --context 10 '$1' {}"
		}
	else
		fgrep() {
			if [ ! "$" -gt 0 ]; then
				echo "Need a string to search for!"
				return 1
			fi
			grep -rIl --exclude-dir=node_modules --exclude-dir=.git -- "$1" . | fzf --multi $FZF_PREVIEW_WINDOW --preview "grep -n --color=always -C 10 -- '$1' {}"
		}
	fi
	export FZF_DEFAULT_OPTS="
		--multi
		--info=inline
		--preview-window=:hidden
		--bind '?:toggle-preview'
		--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
		--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
		--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
		--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
		--color=selected-bg:#45475A
		--color=border:#6C7086,label:#CDD6F4
		"
	source <(fzf --zsh)
fi

# btop
if command -v btop >/dev/null 2>&1; then
	alias top="btop"
fi

# delta
if command -v delta >/dev/null 2>&1; then
	alias diff="delta --side-by-side"
fi

# ripgrep (replaces grep)
if command -v rg >/dev/null 2>&1; then
	alias grep='rg --smart-case -g "!node_modules" -g "!.git"'
fi

# wget
if command -v wget >/dev/null 2>&1; then
	alias wget='wget -c'
fi

# fd (replaces find)
if command -v fd >/dev/null 2>&1; then
	alias find="fd"
fi

# dust (replaces du)
if command -v dust >/dev/null 2>&1; then
	alias du="dust"
fi

# eza (replaces ls)
if command -v eza >/dev/null 2>&1; then
	alias ls="eza --icons=auto --group-directories-first"
fi

# bat (replaces cat)
if command -v bat >/dev/null 2>&1; then
	# bat will auto remove numbers if piped or subshell
	alias cat="bat"
	alias less='bat --paging=always'
fi

# zoxide (replaces cd)
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh --cmd cd)"
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
	eval "$(direnv hook zsh)"
fi

# gnu sed (replaces sed)
if command -v gsed >/dev/null 2>&1; then
	alias sed="gsed"
fi

# gawk (replaces awk)
if command -v gawk >/dev/null 2>&1; then
	alias awk="gawk"
fi

# nvim
if command -v nvim >/dev/null 2>&1; then
	alias vim="nvim"
	alias vi="nvim"
fi

# xclip
if command -v xclip >/dev/null 2>&1; then
	alias xclip="xclip -se c"
fi

# bun
if [[ -f "$HOME/.bun/bin/bun" ]]; then
	# bun completions
	[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

	# bun
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

# rust
if [[ -f "$HOME/.cargo/env" ]]; then
	. "$HOME/.cargo/env"
fi

# tailscale needs special handling on mac
if [[ -f /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# yazi
if command -v yazi >/dev/null 2>&1; then
	y() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
		yazi "$@" --cwd-file="$tmp"
		if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
			builtin cd -- "$cwd"
		fi
		rm -f -- "$tmp"
	}
fi

# pnpm
if [[ -d "$HOME/.local/share/pnpm" ]]; then
	export PNPM_HOME="$HOME/.local/share/pnpm"
	case ":$PATH:" in
	*":$PNPM_HOME/bin:"*) ;;
	*) export PATH="$PNPM_HOME/bin:$PATH" ;;
	esac
fi

# lazygit
if command -v lazygit >/dev/null 2>&1; then
	alias l="lazygit"
fi

# kubectl
if command -v kubectl &>/dev/null 2>&1 && command -v kubecolor >/dev/null 2>&1; then
	alias kubectl="kubecolor"
	alias k="kubectl"
fi

# asdf
if command -v asdf >/dev/null 2>&1; then
	if [[ ! -d "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" ]]; then
		echo "Creating completions for asdf"
		mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
		asdf completion zsh >"${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
	fi
	export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
	fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
	if asdf where flutter >/dev/null 2>&1; then
		export FLUTTER_ROOT="$(asdf where flutter)"
	fi
fi

# mani
if command -v mani >/dev/null 2>&1; then
	# Define where to store mani completions
	MANI_COMPLETIONS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mani/completions"

	# Create and generate completion if missing
	if [[ ! -d "$MANI_COMPLETIONS_DIR" ]]; then
		echo "Creating completions for mani"
		mkdir -p "$MANI_COMPLETIONS_DIR"
		mani completion zsh >"$MANI_COMPLETIONS_DIR/_mani"
	fi

	# Add to fpath for autoloading
	fpath=($MANI_COMPLETIONS_DIR $fpath)
fi

# carapace
if command -v carapace >/dev/null 2>&1; then
	export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
	# zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
	zstyle ':fzf-tab:*' query-string ''
	source <(carapace _carapace)
fi

# go
if command -v go >/dev/null 2>&1; then
	export PATH=$(go env GOPATH)/bin:$PATH
fi

# terraform
if command -v terraform >/dev/null 2>&1; then
	autoload -U +X bashcompinit && bashcompinit
	complete -o nospace -C /Users/zixi.hee/homebrew/bin/terraform terraform
fi

# fzf-tab
if [[ -f "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]]; then
	# set descriptions format to enable group support
	# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
	zstyle ':completion:*:descriptions' format '[%d]'
	# set list-colors to enable filename colorizing
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
	zstyle ':completion:*' menu no
	# NOTE: This may lead to unexpected behavior since some flags break this plugin. See https://github.com/Aloxaf/fzf-tab/issues/455
	zstyle ':fzf-tab:*' use-fzf-default-opts yes
	# switch group using < >
	zstyle ':fzf-tab:*' switch-group '<' '>'
	# use tab to multi select, matching fzf defaults
	zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle'
	# should have min height so previews can show up
	zstyle ':fzf-tab:*' fzf-flags --height=60%
	# use tmux popups
	# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
	source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
fi

# zsh-system-clipboard
if [[ -f $HOMEBREW_PREFIX/share/zsh-system-clipboard/zsh-system-clipboard.zsh ]]; then
	source "$HOMEBREW_PREFIX/share/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

# zsh-auto-suggestions
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	unset ZSH_AUTOSUGGEST_USE_ASYNC # To fix incompatibility issue: https://github.com/romkatv/powerlevel10k/issues/1554#issuecomment-1701598955
fi

# zsh-history-substring-search
if [[ -f "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
	export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='none'
	export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'
	source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down
fi

# zsh-patina
if [[ -f "$HOMEBREW_PREFIX/bin/zsh-patina" ]]; then
	eval "$($HOMEBREW_PREFIX/bin/zsh-patina activate)"
fi
