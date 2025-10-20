#!/bin/bash
# install-core.sh - Cross-platform core development tools
# Zero configuration generation - tools only

set -e

echo "🚀 Installing core development tools..."

# Platform detection
detect_platform() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        *)          echo "unknown" ;;
    esac
}

# Package manager detection for Linux
detect_package_manager() {
    if command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Tool installation functions
install_tool() {
    local tool=$1
    echo "Installing $tool..."
    
    case $(detect_platform) in
        macos)
            if ! brew list "$tool" >/dev/null 2>&1; then
                brew install "$tool"
            else
                echo "$tool is already installed"
            fi
            ;;
        linux)
            local pkg_manager=$(detect_package_manager)
            case $pkg_manager in
                apt)
                    sudo apt-get update -qq
                    sudo apt-get install -y "$tool"
                    ;;
                dnf)
                    sudo dnf install -y "$tool"
                    ;;
                yum)
                    sudo yum install -y "$tool"
                    ;;
                pacman)
                    sudo pacman -S --noconfirm "$tool"
                    ;;
                *)
                    echo "Unsupported package manager: $pkg_manager"
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Unsupported platform"
            exit 1
            ;;
    esac
}

# Core tools list: zsh git docker fzf zoxide bat gh nvim tmux
CORE_TOOLS="zsh git fzf zoxide bat gh nvim tmux"

# Install Homebrew on macOS if not present
if [[ "$(detect_platform)" == "macos" ]] && ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Docker separately (special handling)
install_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo "Docker is already installed"
        return
    fi
    
    case $(detect_platform) in
        macos)
            install_tool "docker"
            ;;
        linux)
            local pkg_manager=$(detect_package_manager)
            case $pkg_manager in
                apt)
                    sudo apt-get update -qq
                    sudo apt-get install -y docker.io docker-compose
                    sudo usermod -aG docker "$USER"
                    ;;
                *)
                    echo "Please install Docker manually for your distribution"
                    ;;
            esac
            ;;
    esac
}

# Main installation
main() {
    echo "Platform: $(detect_platform)"
    
    if [[ "$(detect_platform)" == "linux" ]]; then
        echo "Package manager: $(detect_package_manager)"
    fi
    
    # Install core tools
    for tool in $CORE_TOOLS; do
        install_tool "$tool"
    done
    
    # Install Docker
    install_docker
    
    echo "✅ Core tools installation complete!"
    echo "📝 Note: Configuration files are NOT modified by this script"
    echo "🔧 Your existing configs in ~/.config/ remain the source of truth"
}

main "$@"