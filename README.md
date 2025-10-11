# Dotfiles Configuration

This repository contains my personal dotfiles configuration with support for machine-specific local configurations and automated setup scripts.

## Structure

- `zsh/.zshrc` - Main zsh configuration (shared across machines)
- `zsh/.zshrc.local.example` - Template for machine-specific settings
- `setup-local-config.sh` - Configuration setup script
- `setup-server.sh` - Essential server tools installation
- `setup-desktop.sh` - Full macOS desktop setup
- `setup-minimal.sh` - Cross-platform essentials
- `install-analysis.md` - Analysis of package dependencies

## Quick Setup

### New Desktop Machine (macOS)

1. Clone this repository:
   ```bash
   git clone <your-repo> ~/.config
   cd ~/.config
   ```

2. Run the full desktop setup:
   ```bash
   ./setup-desktop.sh
   ```

3. Configure local settings:
   ```bash
   ./setup-local-config.sh
   ```

4. Edit `~/.zshrc.local` with your machine-specific settings

### New Server Machine (Linux/macOS)

1. Clone this repository:
   ```bash
   git clone <your-repo> ~/.config
   cd ~/.config
   ```

2. Run the server setup:
   ```bash
   ./setup-server.sh
   ```

3. Configure dotfiles:
   ```bash
   ./setup-local-config.sh
   ```

4. Edit `~/.zshrc.local` with your machine-specific settings

### Minimal Setup (Any Platform)

For quick setup on shared machines, containers, or any platform:

1. Clone this repository:
   ```bash
   git clone <your-repo> ~/.config
   cd ~/.config
   ```

2. Run minimal setup:
   ```bash
   ./setup-minimal.sh
   ```

3. Configure local settings:
   ```bash
   ./setup-local-config.sh
   ```

4. Edit `~/.zshrc.local` with your machine-specific settings

### Configuration-Only Setup (Existing Machine)

If you just want to configure dotfiles on an existing machine:

1. Clone this repository:
   ```bash
   git clone <your-repo> ~/.config
   cd ~/.config
   ```

2. Run configuration setup:
   ```bash
   ./setup-local-config.sh
   ```

3. Edit `~/.zshrc.local` with your machine-specific settings

## Local Configuration Pattern

The main `.zshrc` sources `~/.zshrc.local` if it exists. This allows you to:

- Keep shared configuration in the repository
- Store machine-specific settings locally (gitignored)
- Avoid committing sensitive information like API keys
- Customize per-machine without cluttering the main config

## What Goes Where

### In `.zshrc` (shared):
- Plugin configurations
- General aliases
- Common PATH modifications
- Shared environment variables

### In `.zshrc.local` (machine-specific):
- API keys and secrets
- Machine-specific PATH modifications
- Project-specific environment variables
- Local aliases and shortcuts
- Machine-specific tool configurations

## Example Local Configuration

```bash
# Machine-specific PATH
export PATH="/custom/tool/bin:$PATH"

# API keys (NEVER commit these)
export GROQ_API_KEY="your-key-here"

# Project-specific settings
export NODE_EXTRA_CA_CERTS=/path/to/project/cert.pem

# Local aliases
alias myproject="cd ~/Projects/myproject"
```

## Setup Scripts

### `setup-desktop.sh` - Full macOS Desktop Setup
**Target**: Personal/work macOS machines with GUI

**Includes**:
- macOS system dependencies (Homebrew, Xcode tools)
- Core development tools (docker, fzf, zoxide, bat, gh, lazygit, lazydocker)
- Desktop applications (browsers, editors, productivity tools)
- Personal configuration files (zsh, git, tmux, ghostty)
- Cursor extensions installation

### `setup-server.sh` - Essential Server Tools
**Target**: Remote servers, headless machines, CI/CD environments

**Includes**:
- Shell (zsh, zsh-syntax-highlighting, Starship prompt)
- Core development tools (docker, fzf, zoxide, bat)
- **Neovim with minimal server-friendly config** (no plugins, instant startup)
- Shell configuration (zsh/.zshrc)
- Cross-platform support (macOS/Linux)

**Excludes**:
- Platform-specific package managers (Homebrew)
- GUI applications and terminal emulators
- Personal configuration files (git, tmux, ghostty)
- Project-specific runtimes (Node.js)
- Editor extensions
- Media players, browsers, productivity apps
- LazyVim and heavy plugin installations

### `setup-minimal.sh` - Cross-Platform Essentials
**Target**: Quick setup, shared machines, containers, any platform

**Includes**:
- Shell (zsh, zsh-syntax-highlighting)
- Minimal core development tools (docker, fzf, zoxide, bat, gh)
- Shell configuration (zsh/.zshrc)
- No personal configurations
- Lightweight and portable

## Neovim Configuration

This repository includes two separate neovim configurations for different environments:

### Desktop/Local: LazyVim (Full Featured)
- Location: `nvim/` directory in this repo
- 30+ plugins with LSP, auto-completion, file trees, fuzzy finding
- Rich UI and advanced features
- Requires significant resources and network for first-time setup
- **Use on**: Desktop/laptop with good resources

### Server: Minimal Config (Resource Friendly)
- Auto-installed by `setup-server.sh`
- Zero plugins, no auto-install, no network required
- Essential keybindings and settings only
- Works immediately without setup delay
- **Use on**: Remote servers, VPS, containers, CI/CD

### Fix Crashed Neovim on Server

If you accidentally synced the full LazyVim config to a server and it crashes:

```bash
# Run this on your server
~/.config/scripts/fix-nvim-server.sh
```

This will:
- Backup your full config to `~/.config/nvim.desktop-backup`
- Install the minimal server config
- Clean up plugin data

See [docs/nvim-configs.md](docs/nvim-configs.md) for detailed documentation.

## Security Note

The `.zshrc.local` file is gitignored and should never be committed. Always use it for sensitive information like API keys, passwords, or machine-specific paths.


## Changelog 

- 2024-10-10 13:30:00 - Removed legacy new-install.sh script, replaced with modular setup scripts
- 2024-10-10 13:25:00 - Added modular setup scripts (setup-server.sh, setup-desktop.sh, setup-minimal.sh)
- 2024-12-19 15:30:00 - Initial changelog entry

