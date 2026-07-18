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

# Run apt-get update only once per invocation (not before every package)
APT_UPDATED=false
apt_update_once() {
  if [ "$APT_UPDATED" = false ]; then
    sudo apt-get update -qq
    APT_UPDATED=true
  fi
}

# Some tools ship under a different package name on Linux distros
# (e.g. brew's "nvim" is "neovim" in apt/dnf/pacman)
pkg_name_for() {
  local tool=$1
  local manager=$2
  case "$manager" in
  apt | dnf | yum | pacman)
    case "$tool" in
    nvim) echo "neovim" ;;
    *) echo "$tool" ;;
    esac
    ;;
  *) echo "$tool" ;;
  esac
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
    local pkg_manager
    pkg_manager=$(detect_package_manager)
    local pkg
    pkg=$(pkg_name_for "$tool" "$pkg_manager")
    case $pkg_manager in
    apt)
      apt_update_once
      sudo apt-get install -y "$pkg"
      ;;
    dnf)
      sudo dnf install -y "$pkg"
      ;;
    yum)
      sudo yum install -y "$pkg"
      ;;
    pacman)
      sudo pacman -S --noconfirm "$pkg"
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

# GitHub CLI — NOT in Ubuntu's apt archive; needs GitHub's official repo
install_gh() {
  if command -v gh >/dev/null 2>&1; then
    echo "gh is already installed"
    return
  fi

  echo "Installing gh (GitHub CLI)..."

  case $(detect_platform) in
  macos)
    brew install gh
    ;;
  linux)
    local pkg_manager
    pkg_manager=$(detect_package_manager)
    case $pkg_manager in
    apt)
      if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
        echo "Adding GitHub CLI apt repository..."
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
        APT_UPDATED=false # force re-update so apt sees the new repo
      fi
      apt_update_once
      sudo apt-get install -y gh
      ;;
    dnf | yum)
      sudo $pkg_manager install -y gh
      ;;
    pacman)
      sudo pacman -S --noconfirm github-cli
      ;;
    *)
      echo "Please install gh manually: https://github.com/cli/cli/releases"
      ;;
    esac
    ;;
  esac
}

# Docker — on Linux use get.docker.com (docker-ce + compose v2 plugin).
# Ubuntu's own `docker.io` + `docker-compose` packages give you the legacy
# v1 compose binary (no `docker compose` subcommand) — avoid them.
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
    local pkg_manager
    pkg_manager=$(detect_package_manager)
    case $pkg_manager in
    pacman)
      # Arch packages compose v2 correctly
      sudo pacman -S --noconfirm docker docker-compose
      sudo systemctl enable --now docker
      ;;
    *)
      echo "Installing Docker Engine via get.docker.com..."
      curl -fsSL https://get.docker.com | sudo sh
      ;;
    esac

    # Non-root users need the docker group (applies on next login)
    if [ "$(id -u)" -ne 0 ]; then
      sudo usermod -aG docker "$USER"
      echo "⚠️  Added $USER to the docker group — log out and back in for it to take effect"
    fi
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

  # Install Homebrew on macOS if not present
  if [[ "$(detect_platform)" == "macos" ]] && ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Core tools: zsh git curl fzf zoxide bat nvim tmux
  # (gh and docker have dedicated installers below)
  CORE_TOOLS="zsh git curl fzf zoxide bat nvim tmux"

  for tool in $CORE_TOOLS; do
    install_tool "$tool"
  done

  install_gh
  install_docker
  install_tpm
  install_starship

  # Default shell -> zsh (takes effect next login). Don't fail the whole
  # run if chsh isn't permitted here.
  if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
    chsh -s "$(command -v zsh)" || echo "⚠️  chsh failed — run manually: chsh -s $(command -v zsh)"
  fi

  echo "✅ Core tools installation complete!"
  echo "📝 Note: Configuration files are NOT modified by this script"
  echo "🔧 Your existing configs in ~/.config/ remain the source of truth"
  echo "🔧 Log out and back in (or run 'exec zsh') to start using zsh"
}

main "$@"
