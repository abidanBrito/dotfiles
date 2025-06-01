# .zshrc

if [[ -z $DISPLAY ]] && [[ $(tty) == "/dev/tty1" ]]; then
	exec hyprland
fi

export EDITOR='nvim'

### Plugins
# Set where to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit, if it doesn't exist
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::command-not-found
zinit snippet OMZP::archlinux
zinit snippet OMZP::sudo
zinit snippet OMZP::git
zinit snippet OMZP::conda

### Keybindings
# Enable Emacs-like keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Fix backspace
bindkey "^[[3~" delete-char

### History
HISTSIZE=3000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Append to the end of the history file
setopt appendhistory

# Share history across zsh sessions
setopt sharehistory

# Ignore commands prepended with a space
setopt hist_ignore_space

# Ignore duplicates and don't show them, if there are any
setopt hist_ignore_all_dupc
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

### Completions
# Load completions
autoload -U compinit && compinit

# Replay all cached completions
zinit cdreplay -q

# Case-insensitive completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colored completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Disable the default completion menu
zstyle ':completion:*' menu no

# Enable FZF previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons $realpath'

### Aliases
alias ls='eza --icons'
alias tree='eza --tree --icons'
alias cat='bat'
alias vim='nvim'
alias lg='lazygit'

### Shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

# Miniconda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# FZF options
export FZF_DEFAULT_OPTS="--height=100% --preview '~/.config/fzf/preview.sh {}' --preview-window=right:60%:wrap"

