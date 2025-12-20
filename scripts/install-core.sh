#!/bin/bash
# install-core.sh - Cross-platform core development tools
# Zero configuration generation - tools only

set -e

echo "🚀 Installing core development tools..."

# Platform detection
detect_platform() {
  case "$(uname -s)" in
  Darwin*) echo "macos" ;;
  Linux*) echo "linux" ;;
  *) echo "unknown" ;;
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

install_tpm() {
  DIR="$HOME/.config/tmux/plugins/tpm"

  if [ ! -d "$DIR" ]; then
    echo "Install Tmux Plugin Manager"
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm/
  elif [ -d "$DIR/.git" ]; then
    echo 'TPM Exists, Updating Now'
    (cd "$DIR" && git pull)
  else
    echo 'Directory exists but not a git repo, removing and re-cloning...'
    rm -rf "$DIR"
    git clone https://github.com/tmux-plugins/tpm "$DIR"
  fi
}

install_starship() {
  if command -v starship >/dev/null 2>&1; then
    echo "Starship is already installed"
    return
  fi
  
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh
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

  #Tnstall Tmux Plugin Manager
  install_tpm

  # Install Starship Prompt
  install_starship

  chsh -s $(which zsh)
  source ~/.config/zsh/.zshrc

  echo "✅ Core tools installation complete!"
  echo "📝 Note: Configuration files are NOT modified by this script"
  echo "🔧 Your existing configs in ~/.config/ remain the source of truth"
  echo "🔧 You may need to log out and back in for the changes to take effect"
}

main "$@"

