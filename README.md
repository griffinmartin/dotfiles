# dotfiles

Personal macOS development environment configs.

## What's included

| Tool | Config location | Description |
|------|----------------|-------------|
| [Fish](https://fishshell.com/) | `~/.config/fish` | Shell with vi keybindings, git aliases, zoxide, NVM via bass, Tide prompt |
| [Neovim](https://neovim.io/) | `~/.config/nvim` | LazyVim-based config with LSP, DAP, gitsigns, neo-tree, linting |
| [WezTerm](https://wezfurlong.org/wezterm/) | `~/.wezterm.lua` | Terminal emulator with Tokyo Night theme |
| [Zellij](https://zellij.dev/) | `~/.config/zellij` | Terminal multiplexer with custom Alt-key keybinds and Tokyo Night theme |
| [OpenCode](https://opencode.ai/) | `~/.config/opencode` | AI coding agent with [Superpowers](https://github.com/obra/superpowers) plugin |

## Install

Requires macOS. Installs Homebrew (if needed), all tools, symlinks configs, and sets up OpenCode.

```sh
git clone https://github.com/gmartin/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh
```

## Post-install

Set fish as default shell:

```sh
sudo sh -c 'echo $(which fish) >> /etc/shells'
chsh -s $(which fish)
```

Create NVM directory:

```sh
mkdir -p ~/.nvm
```

## Structure

```
dotfiles/
├── fish/           # Fish shell config, plugins, functions
├── nvim/           # Neovim (LazyVim) config
├── wezterm/        # WezTerm terminal config
├── zellij/         # Zellij multiplexer config
├── install.sh      # Bootstrap script
└── README.md
```

## Updating

Pull the latest and re-run the installer. It's idempotent -- existing configs get backed up to `*.bak` and tools already installed are skipped.

```sh
cd ~/dev/dotfiles
git pull
./install.sh
```
