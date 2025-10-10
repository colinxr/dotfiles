# Installation Script Analysis

## Current `new-install.sh` Package Breakdown

### macOS-Specific System Dependencies (Desktop Only)
- **Homebrew** - macOS package manager
- **Xcode Command Line Tools** - macOS development tools

### Project-Specific Runtime (Optional)
- **NVM** - Node Version Manager (project-dependent)
- **Node.js** - JavaScript runtime (project-dependent)

### Core Development Tools (Server + Desktop)
- **zsh** - Shell
- **zsh-syntax-highlighting** - Shell enhancement
- **docker** - Containerization
- **fzf** - Fuzzy finder
- **zoxide** - Smart cd
- **bat** - Better cat
- **gh** - GitHub CLI
- **lazygit** - Git TUI
- **lazydocker** - Docker TUI

### Desktop-Only Tools
- **ghostty** - Terminal emulator (GUI only)

### Desktop-Specific Applications
#### Browsers
- **google-chrome** - Web browser
- **firefox** - Web browser  
- **arc** - Web browser

#### Development GUI Tools
- **cursor** - Code editor
- **transmit** - FTP client
- **postman** - API testing
- **tableplus** - Database client

#### Productivity Applications
- **google-drive** - Cloud storage
- **slack** - Team communication
- **notion** - Note-taking
- **notion-calendar** - Calendar integration
- **flux** - Screen color temperature
- **rectangle** - Window management
- **the-unarchiver** - Archive utility
- **vlc** - Media player
- **expressvpn** - VPN client
- **raycast** - Productivity launcher
- **spotify** - Music streaming
- **git-credential-manager** - Git credentials

### Configuration Files
- **zsh/.zshrc** - Shell configuration (Server + Desktop)
- **git/gitconfig** - Git configuration (Desktop only - personal preference)
- **ghostty/config** - Terminal configuration (Desktop only - GUI only)
- **tmux/.tmux.conf** - Terminal multiplexer (Desktop only - personal preference)

### Editor Extensions (Desktop)
- **gitlens** - Git integration
- **vscode-pigments** - Color highlighting
- **sass-indented** - Sass support
- **ms-python.python** - Python support
- **bmewburn.vscode-intelephense-client** - PHP support
- **vincaslt.highlight-matching-tag** - HTML/XML support
- **dbaeumer.vscode-eslint** - JavaScript linting
- **esbenp.prettier-vscode** - Code formatting
- **mgmcdermott.vscode-language-babel** - Babel support

## Proposed Split Structure

### `setup-server.sh` - Essential server tools only
**Target**: Remote servers, headless machines, CI/CD environments

**Includes**:
- Shell (zsh, zsh-syntax-highlighting)
- Core development tools (docker, fzf, zoxide, bat, gh, lazygit, lazydocker)
- Shell configuration (zsh/.zshrc)

**Excludes**:
- Platform-specific package managers (Homebrew)
- GUI applications and terminal emulators
- Personal configuration files (git, tmux, ghostty)
- Project-specific runtimes (Node.js)
- Editor extensions
- Media players, browsers, productivity apps

### `setup-desktop.sh` - Full macOS desktop setup
**Target**: Personal/work macOS machines with GUI

**Includes**:
- macOS system dependencies (Homebrew, Xcode tools)
- Core development tools (docker, fzf, zoxide, bat, gh, lazygit, lazydocker)
- Desktop applications (browsers, editors, productivity tools)
- Personal configuration files (zsh, git, tmux, ghostty)
- Editor extensions
- Shell enhancements

### `setup-minimal.sh` - Cross-platform essentials
**Target**: Quick setup, shared machines, containers, any platform

**Includes**:
- Shell (zsh, zsh-syntax-highlighting)
- Core development tools only (docker, fzf, zoxide, bat, gh)
- Shell configuration (zsh/.zshrc)
- No platform-specific dependencies
- No personal configurations (git, tmux, ghostty)
- No GUI applications

## Recommendations

1. **Create modular scripts** that can be run independently
2. **Add platform detection** (macOS vs Linux) to avoid installing incompatible packages
3. **Include dependency checks** to avoid reinstalling existing packages
4. **Add dry-run mode** to preview what would be installed
5. **Separate personal configs** from essential tools
6. **Make Node.js/NVM optional** - install only when needed for specific projects
7. **Consider server vs desktop environment detection** (SSH vs local)
8. **Document which tools are truly essential** vs personal preference
