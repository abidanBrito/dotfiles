# dotfiles

> Personal configuration files for my Linux setup, managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## Setup

```bash
git clone https://github.com/abidanBrito/dotfiles ~/dotfiles
cd ~/dotfiles
stow .
```

> **Note:** make sure GNU Stow is installed (`sudo pacman -S stow` or equivalent).
> Any conflicting files in `~` or `~/.config` will need to be removed or adopted first.

---

## Contents

### Window Manager — Hyprland
Wayland compositor with custom keybindings, window rules, animations and monitor configuration. Paired with **Waybar** for a minimal status bar.

### Shell
- **Zsh** - See [.zshrc](.zshrc).
- **Bash** - See [.bashrc](.bashrc).
- **Starship** - Fast, minimal and git-aware prompt. See [starship.toml](.config/starship.toml).
- Shared aliases and environment configurations. See [.shell_aliases](.shell_aliases) and [.shell_env](.shell_env).

### Editors
- **Emacs** - Literate configuration written in Org mode, built on `straight.el` + `use-package`. Features `meow` for modal editing, `lsp-mode` with `clangd` and `pyright`, tree-sitter and whatnot. See [`config.org`](.config/emacs/config.org).
- **Neovim** - Minimal configuration for quick edits. See [`init.lua`](.config/nvim/init.lua).

### Terminal
- **WezTerm** - Primary terminal emulator. See [wezterm.lua](.config/wezterm/wezterm.lua).
- **Kitty** - Secondary terminal emulator. See [kitty.conf](.config/kitty/kitty.conf).

### Other
- **Git** - Git aliases, delta pager, global settings. See [.gitconfig](.gitconfig).
- **Wallpapers** - Curated wallpapers to go with the chosen theme palette. See [wallpapers/](wallpapers/) 
- Custom shell scripts for various tasks. See [.scripts/](.scripts).

---

## License
This repository is released under the MIT license. See [LICENSE](LICENSE) for more information.
