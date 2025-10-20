#!/bin/bash

# setup-desktop.sh - Full macOS desktop setup
# Target: Personal/work macOS machines with GUI

set -e

echo "🚀 Setting up full macOS desktop development environment..."

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ This script is designed for macOS only"
  exit 1
fi

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install Homebrew if not present
install_homebrew() {
  if command_exists brew; then
    echo "✅ Homebrew already installed"
    return 0
  fi

  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ -f /opt/homebrew/bin/brew ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

# Function to install Xcode Command Line Tools
install_xcode_tools() {
  if xcode-select -p >/dev/null 2>&1; then
    echo "✅ Xcode Command Line Tools already installed"
    return 0
  fi

  echo "📦 Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "⚠️  Please complete the Xcode Command Line Tools installation in the popup window"
}

# Function to install Homebrew package
install_brew_package() {
  local package=$1
  local name=$2

  if brew list "$package" >/dev/null 2>&1; then
    echo "✅ $name already installed"
    return 0
  fi

  echo "📦 Installing $name..."
  brew install "$package"
}

# Function to install Homebrew cask
install_brew_cask() {
  local package=$1
  local name=$2

  if brew list --cask "$package" >/dev/null 2>&1; then
    echo "✅ $name already installed"
    return 0
  fi

  echo "📦 Installing $name..."
  brew install --cask "$package"
}

# Install system dependencies
echo "🔧 Installing system dependencies..."
install_homebrew
install_xcode_tools

# Install core development tools
echo "🛠️ Installing core development tools..."
install_brew_package "zsh" "zsh"
install_brew_package "docker" "Docker"
install_brew_package "fzf" "fzf"
install_brew_package "zoxide" "zoxide"
install_brew_package "bat" "bat"
install_brew_package "gh" "GitHub CLI"
install_brew_package "lazygit" "lazygit"
install_brew_package "lazydocker" "lazydocker"
install_brew_package "opencode" "opencode"

# Install desktop applications
echo "🖥️ Installing desktop applications..."

# Browsers
install_brew_cask "google-chrome" "Google Chrome"
install_brew_cask "firefox" "Firefox"
install_brew_cask "arc" "Arc Browser"

# Development GUI Tools
install_brew_cask "cursor" "Cursor"
install_brew_cask "transmit" "Transmit"
install_brew_cask "postman" "Postman"
install_brew_cask "tableplus" "TablePlus"

# Productivity Applications
install_brew_cask "google-drive" "Google Drive"
install_brew_cask "slack" "Slack"
install_brew_cask "notion" "Notion"
install_brew_cask "notion-calendar" "Notion Calendar"
install_brew_cask "flux" "f.lux"
install_brew_cask "rectangle" "Rectangle"
install_brew_cask "the-unarchiver" "The Unarchiver"
install_brew_cask "vlc" "VLC"
install_brew_cask "expressvpn" "ExpressVPN"
install_brew_cask "raycast" "Raycast"
install_brew_cask "spotify" "Spotify"
install_brew_cask "git-credential-manager" "Git Credential Manager"

# Terminal emulator
install_brew_cask "ghostty" "Ghostty"

# Install zsh-syntax-highlighting
if [[ ! -d ~/.zsh-syntax-highlighting ]]; then
  echo "📦 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
fi

# Set up configuration files
echo "⚙️ Setting up configuration files..."

# Create config directories
mkdir -p ~/.config/{zsh,git,ghostty,tmux}

# Copy zsh configuration
if [[ -f ~/.config/zsh/.zshrc ]]; then
  echo "✅ zsh configuration already exists"
else
  echo "📋 Creating zsh configuration..."
  cat >~/.config/zsh/.zshrc <<'EOF'
# Full desktop zsh configuration

# Enable colors
autoload -U colors && colors

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Basic completion
autoload -U compinit
compinit

# Enable zsh-syntax-highlighting
if [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# fzf integration
if command -v fzf >/dev/null 2>&1; then
    if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
    elif [[ -f /usr/local/share/fzf/key-bindings.zsh ]]; then
        source /usr/local/share/fzf/key-bindings.zsh
    fi
fi

# zoxide integration
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# bat integration
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

# Docker aliases
if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias di='docker images'
fi

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# GitHub CLI aliases
if command -v gh >/dev/null 2>&1; then
    alias ghr='gh repo'
    alias ghi='gh issue'
    alias ghp='gh pr'
fi

# Load local configuration if it exists
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
EOF
fi

# Copy git configuration
if [[ -f ~/.config/git/gitconfig ]]; then
  echo "✅ git configuration already exists"
else
  echo "📋 Creating git configuration..."
  cat >~/.config/git/gitconfig <<'EOF'
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = nvim --wait
    excludesfile = ~/.gitignore_global

[init]
    defaultBranch = main

[pull]
    rebase = false

[push]
    default = simple

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    di = diff
    dc = diff --cached
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    amend = commit --amend
    reset = reset --soft HEAD~1
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !cursor
    url = config --get remote.origin.url
EOF
fi

# Copy ghostty configuration
if [[ -f ~/.config/ghostty/config ]]; then
  echo "✅ ghostty configuration already exists"
else
  echo "📋 Creating ghostty configuration..."
  cat >~/.config/ghostty/config <<'EOF'
# Ghostty terminal configuration

# Font
font-family = "Fira Code"
font-size = 14

# Colors (Catppuccin Mocha theme)
background = #1e1e2e
foreground = #cdd6f4
cursor = #f5e0dc
selection-background = #585b70

# Black
color-0 = #45475a
color-8 = #585b70

# Red
color-1 = #f38ba8
color-9 = #f38ba8

# Green
color-2 = #a6e3a1
color-10 = #a6e3a1

# Yellow
color-3 = #f9e2af
color-11 = #f9e2af

# Blue
color-4 = #89b4fa
color-12 = #89b4fa

# Magenta
color-5 = #f5c2e7
color-13 = #f5c2e7

# Cyan
color-6 = #94e2d5
color-14 = #94e2d5

# White
color-7 = #bac2de
color-15 = #a6adc8

# Window
window-padding-x = 10
window-padding-y = 10
window-border-width = 1
window-border-color = #313244

# Tab bar
tab-bar-background = #11111b
tab-bar-foreground = #cdd6f4
tab-bar-border-color = #313244
tab-bar-border-width = 1

# Tab
tab-background = #1e1e2e
tab-foreground = #cdd6f4
tab-background-selected = #313244
tab-foreground-selected = #f5e0dc

# Scrollbar
scrollbar-background = #313244
scrollbar-foreground = #585b70
scrollbar-width = 8

# Bell
bell = visual
bell-duration = 1000
bell-color = #f38ba8

# Cursor
cursor-style = block
cursor-blink = true
cursor-blink-interval = 1000

# Selection
selection-foreground = #1e1e2e
selection-background = #f5e0dc

# URL
url-color = #89b4fa
url-style = underline

# Performance
render-timer = false
enable-gpu = true
EOF
fi

# Copy tmux configuration
if [[ -f ~/.config/tmux/.tmux.conf ]]; then
  echo "✅ tmux configuration already exists"
else
  echo "📋 Creating tmux configuration..."
  cat >~/.config/tmux/.tmux.conf <<'EOF'
# tmux configuration

# Set default terminal mode to 256color mode
set -g default-terminal "screen-256color"

# Enable mouse support
set -g mouse on

# Set prefix key to Ctrl-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Reload config
bind r source-file ~/.config/tmux/.tmux.conf \; display "Config reloaded!"

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Switch windows using Alt-1, Alt-2, etc.
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5
bind -n M-6 select-window -t 6
bind -n M-7 select-window -t 7
bind -n M-8 select-window -t 8
bind -n M-9 select-window -t 9

# Resize panes using Ctrl-arrow
bind -n C-Left resize-pane -L 5
bind -n C-Right resize-pane -R 5
bind -n C-Up resize-pane -U 5
bind -n C-Down resize-pane -D 5

# Status bar
set -g status-position bottom
set -g status-justify left
set -g status-style 'dim'
set -g status-left-length 20
set -g status-right-length 50
set -g status-left '#[fg=green,bold][#S] '
set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M #[fg=green,bold]#(whoami)@#h'

# Window status
setw -g window-status-current-style 'fg=white bg=red bold'
setw -g window-status-current-format ' #I#[fg=red]:#[fg=white]#W#[fg=red]#F '

# Pane border
set -g pane-border-style 'fg=colour238'
set -g pane-active-border-style 'fg=colour51'

# Message text
set -g message-style 'fg=colour232 bg=colour166 bold'

# Clock
setw -g clock-mode-colour colour135

# Copy mode
setw -g mode-style 'fg=colour18 bg=colour254 bold'

# Increase scrollback buffer size
set -g history-limit 10000

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows sequentially after closing any of them
set -g renumber-windows on

# Focus events enabled for terminals that support them
set -g focus-events on

# Aggressive resizing
setw -g aggressive-resize on
EOF
fi

# Set zsh as default shell if not already
if [[ "$SHELL" != *"zsh"* ]]; then
  echo "🔄 Setting zsh as default shell..."
  chsh -s $(which zsh)
  echo "⚠️  Please restart your terminal or run 'exec zsh' to use zsh"
fi

# Install VS Code extensions (if cursor is available)
if command_exists cursor; then
  echo "🔌 Installing Cursor extensions..."

  # List of extensions to install
  extensions=(
    "eamodio.gitlens"
    "sasa.vscode-pigments"
    "robinbentley.sass-indented"
    "ms-python.python"
    "bmewburn.vscode-intelephense-client"
    "vincaslt.highlight-matching-tag"
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "mgmcdermott.vscode-language-babel"
  )

  for extension in "${extensions[@]}"; do
    if cursor --list-extensions | grep -q "$extension"; then
      echo "✅ Extension $extension already installed"
    else
      echo "📦 Installing extension: $extension"
      cursor --install-extension "$extension"
    fi
  done
fi

echo "✅ Desktop setup complete!"
echo "📝 Next steps:"
echo "   - Restart your terminal or run 'exec zsh'"
echo "   - Update git configuration with your name and email"
echo "   - Configure any additional applications as needed"
echo "   - Set up project-specific configurations"
