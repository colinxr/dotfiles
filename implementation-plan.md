# Dotfiles Setup Implementation Plan

## **Strategy: Nuclear Reset**

Completely rebuild from scratch with 2 focused scripts that only install tools -
zero configuration generation.

## **New Script Architecture**

### **`install-core.sh`** - Universal Core Tools

**Purpose**: Install essential development tools on ALL machines (servers,
desktops, containers) **Scope**: Cross-platform CLI tools only **Tools**: zsh,
git, docker, fzf, zoxide, bat, gh, nvim, tmux **Platforms**: macOS (Homebrew) +
Linux (apt/dnf/yum/pacman)

### **`install-desktop.sh`** - Desktop Development Tools

**Purpose**: Install GUI applications and local development tools **Scope**:
macOS desktop applications only **Tools**: Browsers, editors, productivity apps,
tmuxifier, opencode **Platform**: macOS only (Homebrew casks)

## **Configuration Philosophy**

- **Your configs in `~/.config/`** are the source of truth
- **No configuration generation** by installation scripts
- **No `~/.zshrc` sourcing stub needed** - zsh loads `~/.config/zsh/.zshrc`
  automatically
- **Machine-specific settings** go in `~/.zshrc.local` (gitignored)
- **Zero conflicts** with existing configurations

## **Branch Strategy**

**Branch**: `feature/nuke` (created from main) **Merge Strategy**: Squash merge
when complete

## **Commit Plan (7 Steps)**

| Commit | Action                     | Files                        | Validation              |
| ------ | -------------------------- | ---------------------------- | ----------------------- |
| **1**  | Delete existing scripts    | `git rm scripts/setup-*.sh`  | No setup scripts remain |
| **2**  | Core installer skeleton    | `scripts/install-core.sh`    | Basic structure works   |
| **3**  | Core implementation        | `scripts/install-core.sh`    | Cross-platform install  |
| **4**  | Desktop installer skeleton | `scripts/install-desktop.sh` | macOS structure works   |
| **5**  | Desktop implementation     | `scripts/install-desktop.sh` | Desktop apps install    |
| **6**  | Update documentation       | `README.md`                  | Clear usage examples    |
| **7**  | Integration testing        | Both scripts                 | Clean installation      |

## **Detailed Implementation**

### **Commit 1: Remove Conflicting Scripts**

```bash
git rm scripts/setup-*.sh
# Removes: setup-desktop.sh, setup-server.sh, setup-minimal.sh, setup-local-config.sh
```

### **Commit 2: Create install-core.sh Skeleton**

```bash
#!/bin/bash
# install-core.sh - Cross-platform core development tools
# Zero configuration generation - tools only

set -e

echo "🚀 Installing core development tools..."

# Platform detection
# Package manager detection (apt/dnf/yum/pacman)
# Tool installation functions
# Core tools list: zsh git docker fzf zoxide bat gh nvim tmux
```

### **Commit 3: Complete Core Implementation**

```bash
# Full cross-platform support:
# - macOS: Homebrew
# - Linux: apt (Ubuntu/Debian),
# - Idempotent installation
# - Error handling
# - Progress indicators
```

### **Commit 4: Create install-desktop.sh Skeleton**

```bash
#!/bin/bash
# install-desktop.sh - macOS desktop development tools
# GUI applications and local development tools

set -e

echo "🚀 Installing desktop development tools..."

# macOS-only detection
# Homebrew cask installation
# Desktop applications list
# Development GUI tools
```

### **Commit 5: Complete Desktop Implementation**

```bash
# Categories:
# - Browsers (Chrome, Firefox, Arc)
# - Development GUI (Cursor, Postman, TablePlus)
# - Productivity (Slack, Notion, Raycast)
# - Terminal (Ghostty)
# - Tools (tmuxifier, opencode via brew)
```

### **Commit 6: Documentation Update**

```markdown
# New README sections:

- Quick Start (2 commands)
- Tool Categories
- Configuration Management
- Migration from old scripts
- Troubleshooting
```

### **Commit 7: Final Validation**

```bash
# Test matrix:
# - Fresh macOS machine
# - Fresh Ubuntu server
# - Existing configured machine
# - Verify no config conflicts
```

## **Package Manager Priority (Linux)**

```bash
# Detection order (most common first):
1. apt-get    # Ubuntu/Debian (dominant)
```

## **Tool Categories**

### **Core Tools (install-core.sh)**

- **Shell**: zsh
- **Version Control**: git
- **Containerization**: docker
- **Fuzzy Search**: fzf
- **Smart Navigation**: zoxide
- **Syntax Highlighting**: bat
- **GitHub CLI**: gh
- **Editor**: nvim
- **Terminal Multiplexer**: tmux

### **Desktop Tools (install-desktop.sh)**

- **Browsers**: Chrome, Firefox, Arc
- **Code Editors**: Cursor
- **Database**: TablePlus
- **API Testing**: Postman
- **Communication**: Slack
- **Productivity**: Notion, Notion Calendar
- **System**: Raycast, Rectangle, f.lux
- **Media**: VLC, Tidal
- **Terminal**: Ghostty
- **Development**: tmuxifier, opencode

## **Validation Checklist**

**Per Commit:**

- [ ] Script runs without errors
- [ ] Tools install correctly
- [ ] No configuration files created
- [ ] Idempotent (safe to run multiple times)
- [ ] Cross-platform compatibility

**Post-Implementation:**

- [ ] Your existing configs work unchanged
- [ ] New machines setup cleanly
- [ ] No conflicts with existing setups
- [ ] Clear documentation

## **Migration Strategy**

**New Machines:**

1. Clone dotfiles repo
2. Run `./scripts/install-core.sh`
3. Run `./scripts/install-desktop.sh` (if desktop)
4. Done - your configs are already in place

**Existing Machines:**

1. Continue current setup (no changes needed)
2. Optional: run new scripts to add missing tools
3. No config migration required

## **Success Criteria**

- **Zero configuration conflicts** with your existing setup
- **2-command installation** for new machines
- **Cross-platform support** (macOS + Linux)
- **Your configs remain the source of truth**
- **Machine-specific flexibility** via `~/.zshrc.local`

