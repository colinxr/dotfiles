# Neovim Configuration Guide

## Two Configs for Different Environments

### Desktop Config (LazyVim - Full Featured)
**Location:** `~/.config/nvim/init.lua` (on your local machine)

- Full LazyVim setup with 30+ plugins
- Rich UI, LSP, auto-completion, file trees, fuzzy finding
- Requires significant resources and network for first-time plugin installation
- **Use on:** Desktop/laptop with good resources

### Server Config (Minimal - Resource Friendly)
**Location:** Created by `setup-server.sh`

- Zero plugins, no auto-install, no network required
- Essential keybindings and settings only
- Works immediately without any setup delay
- **Use on:** Remote servers, VPS, containers, CI/CD

## Switching Between Configs

### On Server (Manual Fix if Already Crashed)
If you already synced the full config and it crashed:

#### Option 1: Run the fix script
```bash
~/.config/scripts/fix-nvim-server.sh
```

#### Option 2: Manual fix
```bash
# Backup the full config
mv ~/.config/nvim ~/.config/nvim.desktop-backup

# Clean up plugin data
rm -rf ~/.local/share/nvim/lazy

# Create minimal config
mkdir -p ~/.config/nvim

cat > ~/.config/nvim/init.lua << 'EOF'
-- Minimal server config (no plugins)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>e", ":Ex<CR>")
vim.cmd("colorscheme habamax")
EOF
```

### Automated Setup
Run the appropriate setup script:

```bash
# On server
~/.config/scripts/setup-server.sh

# On desktop/local machine  
~/.config/scripts/setup-desktop.sh  # (if exists)
```

## Minimal Config Key Bindings

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `Space + e` | File explorer (`:Ex`) |
| `Space + w` | Save file |
| `Space + q` | Quit |
| `Ctrl + d` | Scroll down half page (centered) |
| `Ctrl + u` | Scroll up half page (centered) |
| `Esc` | Clear search highlight |
| `J` (visual) | Move selected lines down |
| `K` (visual) | Move selected lines up |

## Common Commands

### Opening Files
```vim
:e filename.txt          " Open file
:Ex                      " File explorer (netrw)
:e .                     " Browse current directory
```

### Saving/Quitting
```vim
:w                       " Save
:q                       " Quit
:wq                      " Save and quit
:q!                      " Quit without saving
```

### Searching
```vim
/pattern                 " Search forward
?pattern                 " Search backward
n                        " Next match
N                        " Previous match
```

## Why Separate Configs?

1. **Resource Constraints**: Servers often have limited memory/CPU
2. **Network Access**: Plugin installation requires GitHub access, which may be restricted
3. **Startup Time**: Minimal config starts instantly
4. **Stability**: No plugin conflicts or breaking changes
5. **Simplicity**: Easier to troubleshoot basic text editing

## When to Use Each

**Use Desktop Config When:**
- Working on local development machine
- Need LSP, auto-completion, advanced features
- Have stable internet connection
- Complex codebase navigation

**Use Server Config When:**
- SSH into remote servers
- Quick config file edits
- Resource-constrained environments
- No internet access
- Docker containers
- CI/CD pipelines

