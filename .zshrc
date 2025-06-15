# .zshrc

# Auto-start hyprland on TTY1 if no display server is running
if [[ -z $DISPLAY ]] && [[ $(tty) == "/dev/tty1" ]]; then
    exec hyprland
fi

# Early exit for non-interactive shells
[[ -o interactive ]] || return

# Load environment variables
if [[ -f ~/.shell_env ]]; then
    source ~/.shell_env || echo "WARNING: failed to load ~/.shell_env" >&2
else
    echo "WARNING: ~/.shell_env not found" >&2
fi

# Load aliases
if [[ -f ~/.shell_aliases ]]; then
    source ~/.shell_aliases || echo "WARNING: failed to load ~/.shell_aliases" >&2
else
    echo "WARNING: ~/.shell_aliases not found" >&2
fi

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
HISTFILE=~/.zsh_history
HISTSIZE=3000
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Append to the end of the history file
setopt appendhistory

# Share history across zsh sessions
setopt sharehistory

# Ignore commands prepended with a space
setopt hist_ignore_space

# Ignore duplicates and don't show them, if there are any
setopt hist_ignore_all_dups
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

### Shell integrations
command -v starship &> /dev/null && eval "$(starship init zsh)"
command -v zoxide &> /dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v fzf &> /dev/null && eval "$(fzf --zsh)"
