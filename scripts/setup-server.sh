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

# Install Oh My Zsh if not present
if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-syntax-highlighting
if [[ ! -d ~/.zsh-syntax-highlighting ]]; then
    echo "📦 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
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
# Essential server zsh configuration

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
EOF
fi

# Set zsh as default shell if not already
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "🔄 Setting zsh as default shell..."
    chsh -s $(which zsh)
    echo "⚠️  Please restart your terminal or run 'exec zsh' to use zsh"
fi

echo "✅ Server setup complete!"
echo "📝 Next steps:"
echo "   - Restart your terminal or run 'exec zsh'"
echo "   - Configure any additional tools as needed"
echo "   - Set up project-specific configurations"
