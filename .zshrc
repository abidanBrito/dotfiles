# .zshrc

# Auto-start hyprland on TTY1 if no display server is running
if [[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) == "/dev/tty1" ]]; then
    exec start-hyprland
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

# Completions plugin
# Synchronous and before compinit (blockf defers its compdefs)
zinit ice blockf
zinit light zsh-users/zsh-completions

# Plugins (deferred)
# NOTE(abi): syntax-highlighting last so it wraps every widget.
zinit wait lucid for \
    Aloxaf/fzf-tab \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting

# Snippets (deferred)
zinit wait lucid for \
    OMZP::command-not-found \
    OMZP::archlinux \
    OMZP::sudo \
    OMZP::git \
    OMZP::conda

### Keybindings
# Enable Emacs-like keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Edit command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

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

# Replay cached completions
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
if [[ "$TERM" != "dumb" ]] && command -v starship &> /dev/null; then
    eval "$(starship init zsh)"

    # Transient prompt
    _starship_transient_prompt() {
        PROMPT="$(starship module character)"
        zle .reset-prompt
    }
    _starship_restore_prompt() {
        PROMPT="$(starship prompt)"
    }
    precmd_functions+=(_starship_restore_prompt)
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget zle-line-finish _starship_transient_prompt
fi

command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"
command -v fzf &> /dev/null && eval "$(fzf --zsh)"
command -v uv &> /dev/null && eval "$(uv generate-shell-completion zsh)"
