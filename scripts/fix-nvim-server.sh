#!/bin/bash

# fix-nvim-server.sh - Quick fix for crashed nvim on servers
# Run this on your server to replace LazyVim with minimal config

set -e

echo "🔧 Fixing nvim configuration for server environment..."

# Backup existing config if it exists
if [[ -d ~/.config/nvim ]]; then
    if [[ -d ~/.config/nvim.desktop-backup ]]; then
        echo "⚠️  Backup already exists at ~/.config/nvim.desktop-backup"
    else
        echo "📦 Backing up existing config to ~/.config/nvim.desktop-backup"
        mv ~/.config/nvim ~/.config/nvim.desktop-backup
    fi
fi

# Clean up any lazy plugin data
if [[ -d ~/.local/share/nvim ]]; then
    echo "🧹 Cleaning up plugin data..."
    rm -rf ~/.local/share/nvim/lazy
fi

# Create fresh minimal config
echo "📝 Creating minimal server config..."
mkdir -p ~/.config/nvim

cat > ~/.config/nvim/init.lua << 'EOF'
-- Minimal server-friendly nvim config
-- No plugin manager, no auto-install, just essential settings

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Basic keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>e", ":Ex<CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":noh<CR>")

-- File type detection
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Set colorscheme (built-in fallback)
vim.cmd("colorscheme habamax")
EOF

echo "✅ Minimal nvim configuration installed!"
echo ""
echo "📝 Your old config backed up to: ~/.config/nvim.desktop-backup"
echo ""
echo "⌨️  Quick keys:"
echo "   Space+e: File explorer"
echo "   Space+w: Save"
echo "   Space+q: Quit"
echo "   :e filename: Open file"
echo ""
echo "Test it: nvim test.txt"

