#!/bin/bash
# install-desktop.sh - macOS desktop development tools
# GUI applications and local development tools

set -e

echo "🚀 Installing desktop development tools..."

# macOS-only detection
check_macos() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        echo "❌ This script is for macOS only"
        exit 1
    fi
}

# Install Homebrew if not present
ensure_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# Install cask application
install_cask() {
    local app=$1
    echo "Installing $app..."
    
    if ! brew list --cask "$app" >/dev/null 2>&1; then
        brew install --cask "$app"
    else
        echo "$app is already installed"
    fi
}

# Install regular package
install_package() {
    local package=$1
    echo "Installing $package..."
    
    if ! brew list "$package" >/dev/null 2>&1; then
        brew install "$package"
    else
        echo "$package is already installed"
    fi
}

# Desktop applications list
BROWSERS="google-chrome firefox arc"
DEVELOPMENT_GUI="cursor postman tableplus"
COMMUNICATION="slack"
PRODUCTIVITY="notion notion-calendar raycast rectangle flux"
MEDIA="vlc tidal"
TERMINAL="ghostty"
DEVELOPMENT_TOOLS="tmuxifier opencode"

# Main installation
main() {
    check_macos
    ensure_homebrew
    
    echo "Platform: macOS"
    echo "Installing GUI applications and development tools..."
    
    # Update Homebrew
    echo "Updating Homebrew..."
    brew update
    
    # Install browsers
    echo "🌐 Installing browsers..."
    for app in $BROWSERS; do
        install_cask "$app"
    done
    
    # Install development GUI tools
    echo "💻 Installing development GUI tools..."
    for app in $DEVELOPMENT_GUI; do
        install_cask "$app"
    done
    
    # Install communication tools
    echo "💬 Installing communication tools..."
    for app in $COMMUNICATION; do
        install_cask "$app"
    done
    
    # Install productivity tools
    echo "📋 Installing productivity tools..."
    for app in $PRODUCTIVITY; do
        install_cask "$app"
    done
    
    # Install media tools
    echo "🎵 Installing media tools..."
    for app in $MEDIA; do
        install_cask "$app"
    done
    
    # Install terminal
    echo "🖥️ Installing terminal..."
    for app in $TERMINAL; do
        install_cask "$app"
    done
    
    # Install development tools
    echo "🔧 Installing development tools..."
    for tool in $DEVELOPMENT_TOOLS; do
        install_package "$tool"
    done
    
    echo "✅ Desktop tools installation complete!"
    echo "📝 Note: Configuration files are NOT modified by this script"
    echo "🔧 Your existing configs in ~/.config/ remain the source of truth"
}

main "$@"