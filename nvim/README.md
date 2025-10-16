# Neovim IDE Configuration

Full-featured IDE setup with AI completion, diff review workflow, and comprehensive language support.

## Stack

**AI Completion**
- GitHub Copilot (`copilot.lua` + `copilot-cmp`)
- Alt-l: accept suggestion
- Alt-[/]: cycle suggestions

**Diff Review** (Cursor-like workflow)
- `diffview.nvim`: split diff with staging
- `neogit`: magit-style git interface
- `gitsigns`: inline blame, hunk navigation

**LSP & Tooling**
- Languages: Python, Rust, Go, TypeScript, Lua, Bash, Docker, Terraform, Markdown
- Auto-formatting: conform.nvim (black, prettier, rustfmt, gofumpt)
- Linting: nvim-lint (ruff, eslint_d, shellcheck, hadolint)
- Mason auto-installs all tools

**UI**
- Gruvbox colorscheme
- Which-key: discoverable keybindings
- Neo-tree: file explorer
- Telescope: fuzzy finder
- Todo-comments: highlight TODO/FIXME/etc

## Setup

```bash
# Clone config
git clone <your-repo> ~/.config/nvim

# Open nvim - Lazy auto-installs plugins
nvim

# Set up Copilot
:Copilot auth

# Verify installation
:checkhealth
:Mason
```

## Key Workflows

### Git Review
1. Make changes
2. `<leader>gd` - open diffview
3. Navigate files, stage with `<leader>hs`
4. `<leader>gg` - neogit commit interface
5. Type `cc`, write message, `:wq`

### Code Navigation
- `gd` - go to definition
- `gr` - references
- `<leader>ca` - code actions
- `<leader>rn` - rename
- `K` - hover docs

### Search
- `<leader>ff` - find files
- `<leader>fg` - live grep
- `<leader>fb` - buffers
- `<leader>fs` - grep word under cursor

### Editing
- `<leader>cf` - format buffer
- `]d` / `[d` - next/prev diagnostic
- `<leader>e` - toggle file explorer

## Structure

```
nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua           # Lazy.nvim bootstrap
│   │   ├── keymaps.lua        # Custom keybindings
│   │   ├── options.lua        # Vim options
│   │   └── autocmds.lua       # Auto commands
│   └── plugins/
│       ├── ide.lua            # AI, git, diff, tools
│       ├── lsp.lua            # LSP, formatters, linters
│       └── ui.lua             # Colorscheme, UI plugins
└── lazy-lock.json             # Plugin versions
```

## Plugin Management

Lazy.nvim loads all `*.lua` files in `lua/plugins/`.

Add plugins:
```lua
-- lua/plugins/custom.lua
return {
  {
    "user/repo",
    opts = {},
    keys = {
      { "<leader>x", "<cmd>SomeCommand<cr>", desc = "Do thing" },
    },
  },
}
```

Update plugins: `:Lazy sync`
Install tools: `:Mason`

## Docker Integration

- `dockerls` + `docker-compose-language-service`: LSP
- `hadolint`: Dockerfile linting
- YAML schemas for docker-compose validation
- `rest.nvim`: REST client for API testing

## Language-Specific

**Python**: pyright, ruff, black, isort, venv-selector
**Rust**: rust-analyzer, rustfmt, clippy
**Go**: gopls, gofumpt, goimports
**TypeScript**: tsserver, prettier, eslint_d
**Bash**: bashls, shellcheck, shfmt

Based on [LazyVim](https://github.com/LazyVim/LazyVim).
