# dotfiles

> Personal configuration files for my Linux setup, managed with [GNU Stow](https://www.gnu.org/software/stow/). Following the [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) color scheme.

---

## Setup

```bash
git clone https://github.com/abidanBrito/dotfiles ~/dotfiles
cd ~/dotfiles
stow .
```

**NOTE:** make sure GNU Stow is installed (`sudo pacman -S stow` or equivalent).

Stow symlinks everything in this repo into `~`, mirroring the directory structure. That is, `.config/emacs/config.org` in the repo becomes `~/.config/emacs/config.org` on your system.

### Common Stow commands

| Command | Description |
|---|---|
| `stow .` | Symlink all dotfiles into `~` |
| `stow -D .` | Remove all symlinks (unstow) |
| `stow -R .` | Restow: remove and re-apply symlinks |
| `stow -n .` | Dry run: preview changes without applying |
| `stow --adopt .` | Pull existing files from `~` into the repo, then symlink |

**NOTE:** if you have existing config files that conflict, `--adopt` will move them into the repo so Stow can manage them. Review any adopted files with `git diff` before committing.

---

## Contents

### Desktop

- **Hyprland** - Wayland compositor with custom keybindings, window rules, animations and monitor configuration. See [`hyprland.lua`](.config/hypr/hyprland.lua). 
- **Waybar** - Minimal status bar. See [`config.jsonc`](.config/waybar/config.jsonc). 
- **Rofi** - Application launcher. See [`config.rasi`](.config/rofi/config.rasi).

### Shell

- **Zsh** - See [.zshrc](.zshrc).
- **Bash** - See [.bashrc](.bashrc).
- **Starship** - Fast, minimal and git-aware prompt. See [starship.toml](.config/starship.toml).
- **Shared** - Aliases and environment configurations. See [aliases](.config/shell/aliases) and [profile](.config/shell/profile).

### Editors

- **Emacs** - Literate configuration written in Org mode, built on `elpaca` + `use-package`. Features `meow` for modal editing, `lsp-mode` with `clangd` and `pyright`, tree-sitter and whatnot. See [`config.org`](.config/emacs/config.org).
- **Neovim** - Minimal configuration for quick edits. See [`init.lua`](.config/nvim/init.lua).

### Terminal

- **WezTerm** - Primary terminal emulator. See [wezterm.lua](.config/wezterm/wezterm.lua).
- **Kitty** - Secondary terminal emulator. See [kitty.conf](.config/kitty/kitty.conf).

### Other

- **Git** - Git aliases, delta pager, global settings. See [config](.config/git/config).
- **Lazygit** - Git TUI configuration. See [config.yml](.config/lazygit/config.yml).
- **Wallpapers** - Curated wallpapers to go with the chosen theme palette. See [wallpapers/](wallpapers/) 
- Custom shell scripts for various tasks. See [.scripts/](.scripts).

---

## License

This repository is released under the MIT license. See [LICENSE](LICENSE) for more information.
