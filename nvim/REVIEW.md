# Neovim Setup Review — Gap Analysis vs. PhpStorm, VSCode, Cursor

> **Date:** 2026-05-19
> **Config base:** LazyVim (v8)
> **Target languages:** Node.js, Liquid, React, PHP

---

## Current Setup Summary

| Area | What's Configured |
|---|---|
| **Base** | LazyVim, lazy.nvim, Catppuccin Mocha theme |
| **LSP** | Intelephense (PHP), tsserver (JS/TS), html, cssls, tailwindcss |
| **Treesitter** | php, php_only, javascript, typescript, tsx, jsx, html, css |
| **Formatting** | Conform.nvim with Prettier (JS/TS/React/HTML/CSS), no PHP formatter via Conform |
| **Git** | Gitsigns, Diffview, Telescope git pickers |
| **Search** | Telescope (fd + ripgrep) with good ignore patterns |
| **AI** | opencode.nvim |
| **PHP/Laravel** | Intelephense, phptools.nvim, php-cs-fixer, custom Pest runner, IDE helper generation |
| **Testing** | Custom Pest runner (neotest disabled) |
| **UI** | Neo-tree, indent-blankline, treesitter-context, nvim-ufo folding, dressing.nvim, spectre (search/replace) |

---

## Critical Gaps by Language

### 1. Liquid — Almost Nothing

This is the biggest gap. There is **zero Liquid-specific tooling** configured.

| Feature | PhpStorm | VSCode | Cursor | Your nvim |
|---|---|---|---|---|
| Syntax highlighting | ✅ Built-in | ✅ Extension | ✅ Extension | ⚠️ Treesitter only (basic) |
| LSP (autocomplete, go-to-def) | ✅ Full | ✅ Liquid Language Server | ✅ Liquid Language Server | ❌ **None** |
| Snippets | ✅ Built-in | ✅ Extension | ✅ Extension + AI | ❌ **None** |
| Format on save | ✅ | ✅ (Prettier plugin) | ✅ | ❌ **None** |
| Shopify schema awareness | ✅ | ⚠️ Partial | ⚠️ Partial | ❌ **None** |

**Recommended additions:**

- **`liquid` Treesitter parser** — not in `ensure_installed`
- **`liquid-language-server`** (via Mason) — autocomplete, diagnostics
- **`@shopify/prettier-plugin-liquid`** — add to Conform for formatting `.liquid` and `.liquid`-adjacent files
- **`vim-liquid`** — enhanced syntax highlighting
- **LuaSnip with Liquid snippets** — common Shopify patterns (`{% section %}`, `{% render %}`, `{% schema %}`, `{% form %}`, etc.)

---

### 2. PHP — Good but Missing PhpStorm-Level Features

Intelephense is well-configured (stubs, Laravel, WordPress, Drupal), but PhpStorm has deep features missing here:

| Feature | PhpStorm | Your nvim |
|---|---|---|
| Go-to-definition | ✅ | ✅ (Intelephense) |
| Refactoring (rename, extract method) | ✅ Deep | ⚠️ Basic (LSP rename only) |
| Database client / SQL integration | ✅ Full | ❌ **None** |
| HTTP client / REST testing | ✅ Built-in | ❌ **None** |
| Composer integration | ✅ Deep | ⚠️ Partial (root detection only) |
| PHPUnit/Pest test runner UI | ✅ Full GUI | ⚠️ Custom terminal runner (no inline results) |
| Xdebug visual debugging | ✅ Full | ❌ **No DAP configured** |
| Code coverage overlay | ✅ | ❌ **None** |
| Blade/Twig template navigation | ✅ | ❌ **None** |
| Laravel: route → controller, view → component | ✅ Laravel Plugin | ⚠️ Partial (IDE helper generation only) |
| PHPStan/Psalm static analysis | ✅ | ❌ **Not configured** |
| Auto-import on paste/type | ✅ | ⚠️ Manual (`<leader>pi`) |

**Recommended additions:**

- **`nvim-dap`** + **`nvim-dap-php`** (or Xdebug via DAP) — visual debugging, breakpoints, variable inspection, step-through
- **`phpstan`** or **`psalm`** via Mason + `nvim-lint` — static analysis diagnostics inline
- **`rest.nvim`** — HTTP client for API testing
- **`lazyvim.plugins.extras.lang.php`** — LazyVim's PHP extra adds phpactor, neotest-phpunit, and more
- **Re-enable neotest** — the custom Pest runner is clever but neotest gives inline pass/fail marks, test tree navigation, re-run failed tests, and works across languages
- **`ccaglak/larago.nvim`** — commented out as a phptools dependency; provides goto-blade, goto-component, route navigation
- **`brenoprata10/nvim-highlight-colors`** — PhpStorm-style color preview for hex/rgb in PHP/CSS

---

### 3. Node.js / React — Missing VSCode/Cursor Features

| Feature | VSCode | Cursor | Your nvim |
|---|---|---|---|
| TypeScript LSP | ✅ tsserver | ✅ tsserver | ✅ tsserver |
| ESLint integration | ✅ | ✅ | ⚠️ `eslint_d` in Mason but **not wired to a linter plugin** |
| Import sorting | ✅ (extension) | ✅ (AI) | ❌ **None** |
| Auto-import on type | ✅ | ✅ | ⚠️ Partial (LSP may do it) |
| JSX/TSX snippets | ✅ | ✅ + AI | ❌ **None** |
| npm scripts runner | ✅ Built-in | ✅ | ❌ **None** |
| Package.json intellisense | ✅ | ✅ | ❌ **None** |
| Inline Chat / AI code gen | ❌ | ✅ Core feature | ⚠️ opencode.nvim (different UX) |
| Multi-file AI edits | ❌ | ✅ Core feature | ⚠️ opencode.nvim |
| Jest/Vitest test runner | ✅ Extension | ✅ | ❌ **None** (only Pest for PHP) |

**Recommended additions:**

- **`nvim-lint`** with **eslint_d** — `eslint_d` is installed via Mason but nothing consumes it
- **`tpope/vim-dotenv`** — `.env` file syntax highlighting (critical for Node.js projects)
- **LuaSnip with React/JSX snippets** — `rafce`, `rfce`, hooks patterns, component templates
- **`dnlhc/glance.nvim`** — VSCode-like peek definition/references (currently `gd` jumps away)
- **`b0o/SchemaStore.nvim`** — adds JSON schemas for package.json, tsconfig.json, etc.
- **`pmizio/typescript-tools.nvim`** — replaces bare tsserver with VSCode-equivalent TS experience (organize imports, add missing imports, rename file, remove unused imports)
- **Jest/Vitest test runner** — equivalent to the Pest runner but for Node.js testing
- **Inlay hints for TypeScript** — parameter names, return types (VSCode/Cursor feature)

---

## General IDE Gaps (All Languages)

| Feature | VSCode | Cursor | PhpStorm | Your nvim |
|---|---|---|---|---|
| **Visual debugger** | ✅ DAP | ✅ DAP | ✅ Xdebug | ❌ **No DAP at all** |
| **Integrated terminal profiles** | ✅ | ✅ | ✅ | ⚠️ toggleterm (basic) |
| **Task runner / build system** | ✅ tasks.json | ✅ | ✅ | ❌ **None** |
| **Workspace / multi-root** | ✅ | ✅ | ✅ | ⚠️ Limited |
| **Breadcrumbs** | ✅ | ✅ | ✅ | ❌ **None** |
| **Minimap** | ✅ | ✅ | ✅ | ❌ **None** |
| **Project-wide refactoring** | ✅ | ✅ AI | ✅ | ❌ **None** |
| **Database GUI** | ✅ Extension | ✅ Extension | ✅ Built-in | ❌ **None** |
| **API testing (REST/GraphQL)** | ✅ Extension | ✅ Extension | ✅ Built-in | ❌ **None** |
| **Docker integration** | ✅ Extension | ✅ Extension | ✅ Plugin | ⚠️ LSP only |
| **Environment variable management** | ✅ | ✅ | ✅ | ❌ **None** |
| **CodeLens** | ✅ | ✅ | ✅ | ⚠️ Partial (go.nvim only) |
| **Inlay hints** | ✅ | ✅ | ✅ | ⚠️ Only for Rust/Go |
| **Pull request review** | ✅ GitHub PR ext | ✅ | ✅ | ❌ **None** |

---

## Prioritized Recommendations

### 🔴 High Priority (Biggest Impact)

1. **Add `nvim-dap`** — Debugging is the single biggest gap vs. all three IDEs. Add DAP for PHP (Xdebug), Node.js (node-debug2), and React (Chrome debug adapter).
2. **Add `nvim-lint`** — Linters are installed via Mason (eslint_d, shellcheck, etc.) but nothing consumes them. Wire them up with per-filetype linter configs.
3. **Add Liquid tooling** — `liquid` treesitter parser, `liquid-language-server`, Prettier Liquid plugin, LuaSnip snippets.
4. **Add `typescript-tools.nvim`** — Replaces bare tsserver with VSCode-equivalent TS experience (organize imports, add missing imports, rename file).
5. **Add `LuaSnip`** — React, PHP, Liquid, and Node.js snippet collections.

### 🟡 Medium Priority

6. **Add `glance.nvim`** — Peek definitions instead of jumping (VSCode/Cursor behavior).
7. **Add PHPStan/Psalm** — Static analysis for PHP beyond Intelephense.
8. **Add `rest.nvim`** — HTTP client for API testing.
9. **Add `neogit`** — Full git commit/PR workflow (mentioned in README but not configured).
10. **Add SchemaStore.nvim** — JSON schema for package.json, tsconfig, etc.
11. **Re-evaluate neotest** — Custom Pest runner works but neotest gives inline results, test tree, and works across languages (Jest, Vitest, PHPUnit, Pest).
12. **Add inlay hints for TypeScript** — Parameter names, return types.

### 🟢 Nice to Have

13. **Minimap** (`minimap.vim` or `codewindow.nvim`)
14. **Breadcrumbs** (`aerial.nvim` for symbol outline)
15. **Project/task runner** (`overseer.nvim`)
16. **Docker.nvim** — Container management from within nvim
17. **Database client** (`vim-dadbod` or `database.nvim`)

---

## Configuration Bugs Found

### 1. Duplicate autocmd

The auto-reload autocmd is defined in **both** `options.lua` (line 20) and `autocmds.lua` (line 10). Remove one.

```lua
-- In options.lua, lines 20-27 — DUPLICATE
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("silent! checktime")
    end
  end,
})
```

### 2. Conflicting `<leader>e` mapping

In `keymaps.lua`:
- **Line 79:** `<leader>e` → `vim.diagnostic.open_float`
- **Line 83:** `<leader>e` → `Neotree toggle`

The second mapping overwrites the first. Diagnostic float is unreachable. Fix by changing one:

```lua
-- Change diagnostic to a different key, e.g.:
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
```

### 3. README vs. Reality Mismatch

The README documents plugins that are **not** in the actual config:

| Mentioned in README | Actually Configured? |
|---|---|
| `copilot.lua` + `copilot-cmp` | ❌ Not found |
| `neogit` | ❌ Not found |
| `gruvbox` colorscheme | ❌ Uses catppuccin |
| `rest.nvim` | ❌ Not found |
| `nvim-lint` | ❌ Not found |
| `todo-comments` | ❌ Not found (may come from LazyVim extras) |
| `which-key` | ❌ Not explicitly configured (may come from LazyVim) |

Update the README to match reality, or add the missing plugins.

### 4. Print width consistency

- `textwidth = 80` in options.lua
- Prettier `--print-width 80` in conform.nvim
- `colorcolumn = "80"` in options.lua

Most modern JS/TS/React projects use 100 or 120. If this is intentional, fine — but worth noting.

### 5. `tsserver` without `typescript-tools.nvim`

Using bare `tsserver` means missing:
- Organize imports
- Add all missing imports
- Rename file (updates all references)
- Remove unused imports
- Go to source definition

All of these are standard VSCode features.

### 6. No `.liquid` file type in Conform formatters

Conform has formatters for JS/TS/React/HTML/CSS/JSON/YAML/Markdown but nothing for `.liquid` files. Even without a Liquid LSP, you can add Prettier with the Shopify plugin.

---

## Suggested Plugin Additions (Quick Reference)

| Plugin | Purpose | Priority |
|---|---|---|
| `mfussenegger/nvim-dap` | Debug Adapter Protocol | 🔴 |
| `nvim-neotest/neotest` | Inline test results (multi-lang) | 🔴 |
| `mfussenegger/nvim-lint` | Consume Mason linters (eslint_d, etc.) | 🔴 |
| `L3MON4D3/LuaSnip` | Snippet engine | 🔴 |
| `pmizio/typescript-tools.nvim` | VSCode-level TS experience | 🔴 |
| `williamboman/mason.nvim` (add `liquid-language-server`) | Liquid LSP | 🔴 |
| `dnlhc/glance.nvim` | Peek definitions | 🟡 |
| `rest-nvim/rest.nvim` | HTTP client | 🟡 |
| `nvim-neogit/neogit` | Full git workflow | 🟡 |
| `b0o/SchemaStore.nvim` | JSON schemas (package.json, tsconfig) | 🟡 |
| `chrisgrieser/nvim-early-retirement` | Auto-close unused buffers | 🟡 |
| `stevearc/overseer.nvim` | Task runner | 🟢 |
| `kristijanhusak/vim-dadbod-ui` | Database GUI | 🟢 |
| `codewindow.nvim` | Minimap | 🟢 |
| `simrat39/symbols-outline.nvim` | Symbol outline / breadcrumbs | 🟢 |

---

## Treesitter Parsers to Add

Currently missing from `ensure_installed`:

```lua
"liquid",        -- Shopify Liquid templates
"blade",         -- Laravel Blade templates (if using Laravel)
"dotenv",        -- .env files
"graphql",       -- GraphQL queries (common in React/Node)
"regex",         -- Already have this, good
```

---

## Mason Packages to Add

Currently missing from `ensure_installed`:

```
liquid-language-server      -- Liquid LSP
phpstan                     -- PHP static analysis
typescript-language-server  -- Already have, but consider typescript-tools instead
eslint_d                    -- Already have, but not wired up
```
