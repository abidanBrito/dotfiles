# .bashrc

# Early exit for non-interactive shells
[[ $- != *i* ]] && return

# Load environment variables
if [ -f ~/.config/shell/profile ]; then
    source ~/.config/shell/profile || echo "WARNING: failed to load ~/.config/shell/profile" >&2
else
    echo "WARNING: ~/.config/shell/profile not found" >&2
fi

# Load aliases
if [ -f ~/.config/shell/aliases ]; then
    source ~/.config/shell/aliases || echo "WARNING: failed to load ~/.config/shell/aliases" >&2
else
    echo "WARNING: ~/.config/shell/aliases not found" >&2
fi

# Better prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] ❯ '

### History settings
HISTFILE=~/.bash_history
HISTSIZE=3000
HISTFILESIZE=$HISTSIZE

# Ignore duplicates and space-prefixed commands
HISTCONTROL=ignoredups:erasedups:ignorespace

# Append to history file
shopt -s histappend

### Shell integrations
command -v zoxide &> /dev/null && eval "$(zoxide init bash)"
command -v fzf &> /dev/null && eval "$(fzf --bash)"

# Bash Line Editor (syntax highlighting, autosuggestions, better line editing)
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none
[[ ${BLE_VERSION-} ]] && ble-attach
