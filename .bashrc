# .bashrc

# Early exit for non-interactive shells
[[ $- != *i* ]] && return

# Load environment variables
if [ -f ~/.shell_env ]; then
    source ~/.shell_env || echo "WARNING: failed to load ~/.shell_env" >&2
else
    echo "WARNING: ~/.shell_env not found" >&2
fi

# Load aliases
if [ -f ~/.shell_aliases ]; then
    source ~/.shell_aliases || echo "WARNING: failed to load ~/.shell_aliases" >&2
else
    echo "WARNING: ~/.shell_aliases not found" >&2
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
command -v zoxide &> /dev/null && eval "$(zoxide init --cmd cd bash)"
command -v fzf &> /dev/null && eval "$(fzf --bash)"
