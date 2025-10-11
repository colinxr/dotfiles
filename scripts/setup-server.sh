#!/bin/bash

# setup-server.sh - Essential server tools only
# Target: Remote servers, headless machines, CI/CD environments

set -e

echo "🚀 Setting up essential server development environment..."

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
else
    echo "❌ Unsupported platform: $OSTYPE"
    exit 1
fi

echo "📋 Detected platform: $PLATFORM"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package based on platform
install_package() {
    local package=$1
    local name=$2
    
    if command_exists "$package"; then
        echo "✅ $name already installed"
        return 0
    fi
    
    echo "📦 Installing $name..."
    
    if [[ "$PLATFORM" == "macos" ]]; then
        if command_exists brew; then
            brew install "$package"
        else
            echo "❌ Homebrew not found. Please install Homebrew first."
            return 1
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y "$package"
        elif command_exists yum; then
            sudo yum install -y "$package"
        elif command_exists dnf; then
            sudo dnf install -y "$package"
        elif command_exists pacman; then
            sudo pacman -S --noconfirm "$package"
        else
            echo "❌ No supported package manager found"
            return 1
        fi
    fi
}

# Install shell and core tools
echo "🔧 Installing core development tools..."

# Install zsh if not present
if ! command_exists zsh; then
    install_package "zsh" "zsh"
fi

# Install zsh-syntax-highlighting
if [[ ! -d ~/.zsh-syntax-highlighting ]]; then
    echo "📦 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
fi

# Install Starship prompt
if ! command_exists starship; then
    echo "📦 Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Install Docker (special handling for Linux)
if ! command_exists docker; then
    echo "📦 Installing Docker..."
    if [[ "$PLATFORM" == "macos" ]]; then
        if command_exists brew; then
            brew install docker
        else
            echo "❌ Homebrew not found. Please install Homebrew first."
            exit 1
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        # Install Docker using official Docker repository
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg lsb-release
        
        # Add Docker's official GPG key
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        
        # Add Docker repository
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Update package index and install Docker
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        # Add user to docker group
        sudo usermod -aG docker $USER
        echo "⚠️  You may need to restart your session or run 'newgrp docker' to use Docker without sudo"
    fi
else
    echo "✅ Docker already installed"
fi

# Install other core development tools
install_package "fzf" "fzf"
install_package "zoxide" "zoxide"
install_package "bat" "bat"

# Install neovim
if ! command_exists nvim; then
    echo "📦 Installing neovim..."
    if [[ "$PLATFORM" == "macos" ]]; then
        brew install neovim
    elif [[ "$PLATFORM" == "linux" ]]; then
        # Try to get latest stable neovim
        if command_exists snap; then
            sudo snap install nvim --classic
        elif command_exists apt-get; then
            sudo apt-get install -y neovim
        else
            install_package "neovim" "neovim"
        fi
    fi
else
    echo "✅ neovim already installed"
fi

# Set up shell configuration
echo "⚙️ Setting up shell configuration..."

# Create zsh config directory if it doesn't exist
mkdir -p ~/.config/zsh

# Copy zsh configuration
if [[ -f ~/.config/zsh/.zshrc ]]; then
    echo "✅ zsh configuration already exists"
else
    echo "📋 Creating zsh configuration..."
    cat > ~/.config/zsh/.zshrc << 'EOF'
# ============================================================================
# Base ZSH Configuration - Server Compatible (Performance Optimized)
# To profile: time zsh -i -c exit
# ============================================================================

# XDG Base Directory compliance
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE HIST_VERIFY SHARE_HISTORY
setopt APPEND_HISTORY INC_APPEND_HISTORY

# ============================================================================
# Zsh Configuration
# ============================================================================

# Enable colors and completion
autoload -U colors && colors

# ============================================================================
# Completions (optimized with caching)
# ============================================================================

fpath=(~/.config/zsh/completions $fpath)

# Optimized compinit - cache for 24h
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ============================================================================
# Prompt Configuration
# ============================================================================

# Initialize Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Fallback to simple prompt if starship not installed
  export PROMPT='%n@%m:%~%# '
fi

# ============================================================================
# Core Aliases
# ============================================================================

# File operations
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias lsa='ls -la'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gamed='git commit --amend --reuse-message HEAD'
alias gac='ga .; gc -m'

# Configuration editing
alias zshconf='${EDITOR:-vi} ~/.config/zsh/.zshrc'
alias src-zsh='source ~/.config/zsh/.zshrc'

# Quick help aliases
alias nvim-help='cat ~/.config/docs/nvim-quick-ref.txt'
alias vimhelp='cat ~/.config/docs/nvim-quick-ref.txt'

# ============================================================================
# Tool Integrations
# ============================================================================

# Editor
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  alias vim='nvim'
  alias vi='nvim'
else
  export EDITOR='vi'
fi

# fzf - fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  # Try common installation paths
  if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
  elif [[ -f /usr/local/share/fzf/key-bindings.zsh ]]; then
    source /usr/local/share/fzf/key-bindings.zsh
  elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
  fi
  
  # Completion
  if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
  elif [[ -f /usr/local/share/fzf/completion.zsh ]]; then
    source /usr/local/share/fzf/completion.zsh
  fi
fi

# zoxide - smarter cd
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# bat - better cat
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
  alias bat='batcat'
fi

# Docker aliases
if command -v docker >/dev/null 2>&1; then
  alias d='docker'
  alias dps='docker ps'
  alias di='docker images'
  alias dex='docker exec -it'
  alias dlogs='docker logs -f'
fi

if command -v docker-compose >/dev/null 2>&1; then
  alias dc='docker-compose'
fi

# GitHub CLI
if command -v gh >/dev/null 2>&1; then
  alias ghr='gh repo'
  alias ghi='gh issue'
  alias ghp='gh pr'
fi

# ============================================================================
# Syntax Highlighting
# ============================================================================

# Load zsh-syntax-highlighting (load last for performance)
if [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ============================================================================
# Machine-Specific Configuration
# ============================================================================

# Source local configuration if it exists (desktop-specific tools, paths, aliases)
if [[ -f ~/.config/zsh/.zshrc.local ]]; then
  source ~/.config/zsh/.zshrc.local
fi
EOF
fi

# Create ~/.zshrc that sources XDG-compliant location
if [[ ! -f ~/.zshrc ]]; then
    echo "📋 Creating ~/.zshrc sourcing stub..."
    cat > ~/.zshrc << 'EOF'
# Source actual configuration from XDG-compliant location
source "$HOME/.config/zsh/.zshrc"
EOF
fi

# Set zsh as default shell if not already
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "🔄 Setting zsh as default shell..."
    chsh -s $(which zsh)
    echo "⚠️  Please restart your terminal or run 'exec zsh' to use zsh"
fi

# Set up minimal neovim configuration
echo "⚙️ Setting up minimal neovim configuration..."
mkdir -p ~/.config/nvim
mkdir -p ~/.config/docs

if [[ -f ~/.config/nvim/init.lua ]]; then
    echo "⚠️  Existing nvim config found. Creating backup..."
    mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.backup
fi

cat > ~/.config/nvim/init.lua << 'EOF'
-- Minimal server-friendly nvim config
-- No plugin manager, no auto-install, just essential settings

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Basic keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>e", ":Ex<CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":noh<CR>")

-- File type detection
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Set colorscheme (built-in fallback)
vim.cmd("colorscheme habamax")
EOF

echo "✅ Minimal nvim configuration created"

# Create nvim quick reference
cat > ~/.config/docs/nvim-quick-ref.txt << 'HELPEOF'
╔════════════════════════════════════════════════════════════════╗
║              NEOVIM MINIMAL CONFIG - QUICK REFERENCE           ║
╚════════════════════════════════════════════════════════════════╝

OPENING FILES
─────────────────────────────────────────────────────────────────
  nvim filename.txt       Open specific file from command line
  :e filename.txt         Open file from within nvim
  :Ex                     Open file explorer (netrw)
  :e .                    Browse current directory

ESSENTIAL KEYS
─────────────────────────────────────────────────────────────────
  Space                   Leader key (prefix for commands)
  Space + w               Save file (:w)
  Space + q               Quit (:q)
  Space + e               File explorer (:Ex)
  Esc                     Clear search highlight

NAVIGATION
─────────────────────────────────────────────────────────────────
  h j k l                 Move cursor left/down/up/right
  w / b                   Next/previous word
  gg / G                  Go to top/bottom of file
  Ctrl+d / Ctrl+u         Scroll half page down/up (centered)
  n / N                   Next/previous search result

EDITING
─────────────────────────────────────────────────────────────────
  i                       Insert mode (start typing)
  Esc                     Exit insert mode (back to normal)
  o / O                   Insert line below/above
  dd                      Delete line
  yy                      Copy line
  p                       Paste
  u                       Undo
  Ctrl+r                  Redo

VISUAL MODE (SELECTION)
─────────────────────────────────────────────────────────────────
  v                       Visual mode (character selection)
  V                       Visual line mode
  J (in visual)           Move selection down
  K (in visual)           Move selection up

SEARCHING
─────────────────────────────────────────────────────────────────
  /pattern                Search forward
  ?pattern                Search backward
  n                       Next match
  N                       Previous match
  *                       Search for word under cursor

SAVING & QUITTING
─────────────────────────────────────────────────────────────────
  :w                      Save
  :q                      Quit (fails if unsaved)
  :wq                     Save and quit
  :q!                     Quit without saving
  ZZ                      Save and quit (normal mode)

FILE EXPLORER (:Ex)
─────────────────────────────────────────────────────────────────
  Enter                   Open file/directory
  -                       Go up one directory
  %                       Create new file
  d                       Create new directory
  D                       Delete file/directory

TIPS
─────────────────────────────────────────────────────────────────
  • This is a MINIMAL config - no plugins, no auto-complete
  • Press Space+e to browse files (netrw file explorer)
  • Always use :w to save before :q to quit
  • Press Esc to get back to normal mode if stuck
  • Use :help <topic> for built-in help (e.g., :help motion)

FIX CRASHED NVIM
─────────────────────────────────────────────────────────────────
  If nvim crashes on startup (trying to install plugins):
  
  ~/.config/scripts/fix-nvim-server.sh

═════════════════════════════════════════════════════════════════
View this file: nvim-help (or cat ~/.config/docs/nvim-quick-ref.txt)
HELPEOF

echo "✅ Server setup complete!"
echo ""
echo "📝 Installed tools:"
echo "   - zsh with syntax highlighting and Starship prompt"
echo "   - neovim with minimal server-friendly config (no plugins)"
echo "   - fzf, zoxide, bat, docker"
echo ""
echo "📝 Next steps:"
echo "   - Restart your terminal or run 'exec zsh'"
echo "   - Test nvim: 'nvim test.txt'"
echo "   - View nvim help: 'nvim-help' or 'vimhelp'"
echo ""
echo "⌨️  Essential nvim keys:"
echo "   - Space+e: File explorer"
echo "   - Space+w: Save"
echo "   - Space+q: Quit"
echo "   - :e filename: Open file"
echo "   - Esc: Back to normal mode"
