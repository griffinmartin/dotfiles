#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# --- Helpers ---

info() { printf '\033[1;34m[info]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m[ ok ]\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31m[err ]\033[0m %s\n' "$1"; exit 1; }

backup_and_link() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        warn "Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sf "$src" "$dst"
    ok "Linked $dst -> $src"
}

# --- Phase 1: Homebrew + tools ---

info "Phase 1: Installing tools"

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ok "Homebrew installed"
else
    ok "Homebrew already installed"
fi

BREW_PACKAGES=(
    fish
    neovim
    wezterm
    zellij
    zoxide
    nvm
    pipx
    bun
)

info "Installing brew packages..."
for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        ok "$pkg already installed"
    else
        info "Installing $pkg..."
        brew install "$pkg"
        ok "$pkg installed"
    fi
done

# --- Phase 2: Symlink configs ---

info "Phase 2: Linking config files"

mkdir -p ~/.config

# WezTerm: lives at ~/.wezterm.lua
backup_and_link "$DOTFILES/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"

# Fish: lives at ~/.config/fish
backup_and_link "$DOTFILES/fish" "$HOME/.config/fish"

# Neovim: lives at ~/.config/nvim
backup_and_link "$DOTFILES/nvim" "$HOME/.config/nvim"

# Zellij: lives at ~/.config/zellij
backup_and_link "$DOTFILES/zellij" "$HOME/.config/zellij"

# --- Phase 3: OpenCode + Superpowers ---

info "Phase 3: Setting up OpenCode with Superpowers"

OPENCODE_DIR="$HOME/.config/opencode"
SUPERPOWERS_DIR="$OPENCODE_DIR/superpowers"

mkdir -p "$OPENCODE_DIR/plugins" "$OPENCODE_DIR/skills"

if [ -d "$SUPERPOWERS_DIR/.git" ]; then
    info "Updating superpowers repo..."
    git -C "$SUPERPOWERS_DIR" pull --ff-only
    ok "Superpowers updated"
else
    if [ -e "$SUPERPOWERS_DIR" ]; then
        warn "Backing up existing $SUPERPOWERS_DIR -> ${SUPERPOWERS_DIR}.bak"
        mv "$SUPERPOWERS_DIR" "${SUPERPOWERS_DIR}.bak"
    fi
    info "Cloning superpowers..."
    git clone https://github.com/obra/superpowers.git "$SUPERPOWERS_DIR"
    ok "Superpowers cloned"
fi

# Symlink plugin
backup_and_link "$SUPERPOWERS_DIR/.opencode/plugins/superpowers.js" "$OPENCODE_DIR/plugins/superpowers.js"

# Symlink skills
backup_and_link "$SUPERPOWERS_DIR/skills" "$OPENCODE_DIR/skills/superpowers"

# Generate package.json and install deps
cat > "$OPENCODE_DIR/package.json" <<'EOF'
{
  "dependencies": {
    "@opencode-ai/plugin": "1.2.17"
  }
}
EOF

info "Installing OpenCode plugin dependencies..."
(cd "$OPENCODE_DIR" && bun install)
ok "OpenCode dependencies installed"

# --- Phase 4: Fish post-install ---

info "Phase 4: Fish shell setup"

FISH="$(which fish)"

# Install Fisher if not present
if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    info "Installing Fisher..."
    "$FISH" -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    ok "Fisher installed"
else
    ok "Fisher already installed"
fi

# Install plugins from fish_plugins
info "Installing fish plugins..."
"$FISH" -c 'fisher update'
ok "Fish plugins installed"

# --- Done ---

printf '\n'
info "============================================"
ok   "Dotfiles installed successfully!"
info "============================================"
printf '\n'
info "Optional next steps:"
info "  - Set fish as your default shell:"
info "      sudo sh -c 'echo $(which fish) >> /etc/shells'"
info "      chsh -s $(which fish)"
info "  - Configure NVM directory: mkdir -p ~/.nvm"
printf '\n'
