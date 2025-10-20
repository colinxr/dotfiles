# Dotfiles Configuration

This repository contains my personal dotfiles configuration with support for
machine-specific local configurations and automated setup scripts.

## Structure

- `zsh/.zshrc` - Main zsh configuration (shared across machines)
- `zsh/.zshrc.local.example` - Template for machine-specific settings
- `scripts/install-core.sh` - Cross-platform core development tools
- `scripts/install-desktop.sh` - macOS desktop applications and tools
- `scripts/fix-nvim-server.sh` - Neovim server configuration fix
- `docs/install-analysis.md` - Analysis of package dependencies

## Quick Start

### New Machine Setup (2 Commands)

1. Clone this repository:

   ```bash
   git clone <your-repo> ~/.config
   cd ~/.config
   ```

2. Install tools:

   ```bash
   # Core tools (all platforms)
   ./scripts/install-core.sh

   # Desktop apps (macOS only)
   ./scripts/install-desktop.sh
   ```

That's it! Your configuration files are already in place and ready to use.

### Existing Machine

Your existing setup continues to work unchanged. Optionally run the scripts to
add missing tools.

## Tool Categories

### Core Tools (install-core.sh)

Cross-platform CLI tools for all machines:

- **Shell**: zsh
- **Version Control**: git
- **Containerization**: docker
- **Fuzzy Search**: fzf
- **Smart Navigation**: zoxide
- **Syntax Highlighting**: bat
- **GitHub CLI**: gh
- **Editor**: nvim
- **Terminal Multiplexer**: tmux

### Desktop Tools (install-desktop.sh)

macOS GUI applications and development tools:

- **Browsers**: Chrome, Firefox, Arc
- **Development GUI**: Cursor, Postman, TablePlus
- **Communication**: Slack
- **Productivity**: Notion, Notion Calendar, Raycast, Rectangle, f.lux
- **Media**: VLC, Tidal
- **Terminal**: Ghostty
- **Development**: tmuxifier, opencode

## Configuration Management

### Philosophy

- **Your configs in `~/.config/`** are the source of truth
- **No configuration generation** by installation scripts
- **No `~/.zshrc` sourcing stub needed** - zsh loads `~/.config/zsh/.zshrc`
  automatically
- **Machine-specific settings** go in `~/.zshrc.local` (gitignored)
- **Zero conflicts** with existing configurations

### What Goes Where

#### In `~/.config/` (shared, version controlled):

- All configuration files in this repository
- Plugin configurations, general aliases, common PATH modifications
- Shared environment variables and tool settings

#### In `~/.zshrc.local` (machine-specific, gitignored):

- API keys and secrets
- Machine-specific PATH modifications
- Project-specific environment variables
- Local aliases and shortcuts
- Machine-specific tool configurations

### Example Local Configuration

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

## Migration from Old Scripts

The old setup scripts (`setup-*.sh`) have been replaced with the new focused
installers:

### New Approach

- **install-core.sh**: Cross-platform core tools only
- **install-desktop.sh**: macOS desktop apps only
- **Zero configuration generation**: Your configs remain the source of truth

### Migration Benefits

- **Simpler**: 2 commands instead of complex setup scripts
- **Safer**: No config file modifications or conflicts
- **Cross-platform**: Works on servers, desktops, containers
- **Idempotent**: Safe to run multiple times

### Old vs New

| Old Script              | New Equivalent                                      |
| ----------------------- | --------------------------------------------------- |
| `setup-minimal.sh`      | `install-core.sh` (more comprehensive)              |
| `setup-server.sh`       | `install-core.sh` (same tools, no config changes)   |
| `setup-desktop.sh`      | `install-core.sh` + `install-desktop.sh`            |
| `setup-local-config.sh` | **No longer needed** - configs are already in place |

## Neovim Configuration

This repository includes two separate neovim configurations for different
environments:

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

The `.zshrc.local` file is gitignored and should never be committed. Always use
it for sensitive information like API keys, passwords, or machine-specific
paths.

## Troubleshooting

### Scripts Don't Run

```bash
chmod +x scripts/install-*.sh
```

### Docker Permission Issues (Linux)

```bash
sudo usermod -aG docker $USER
# Then log out and back in
```

### Homebrew Not Found (macOS)

The install scripts will automatically install Homebrew if missing.

### Tool Already Installed

Scripts are idempotent - they'll skip tools that are already installed.

### Configuration Conflicts

The new installers don't modify configuration files, eliminating conflicts with
existing setups.

## Changelog

- 2025-10-20 - Replaced setup scripts with focused installers (install-core.sh,
  install-desktop.sh)
- 2024-10-10 13:30:00 - Removed legacy new-install.sh script, replaced with
  modular setup scripts
- 2024-10-10 13:25:00 - Added modular setup scripts (setup-server.sh,
  setup-desktop.sh, setup-minimal.sh)
- 2024-12-19 15:30:00 - Initial changelog entry
