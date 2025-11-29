-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set leader key to backslash
vim.g.mapleader = [[\]]
vim.g.maplocalleader = [[\]]

-- Auto-reload files when changed externally
vim.o.autoread = true

-- Set line length to 100 characters
vim.o.textwidth = 80
vim.o.colorcolumn = "80"
vim.o.wrap = true
vim.o.linespace = 6
