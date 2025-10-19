-- LSP and language tooling configuration
return {
  -- LSP config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff_lsp = {},  -- Python linter/formatter
        
        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              procMacro = { enable = true },
            },
          },
        },
        
        -- Go
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
            },
          },
        },
        
        -- TypeScript/JavaScript
        tsserver = {},
        
        -- Web
        html = {},
        cssls = {},
        tailwindcss = {},
        
        -- Terraform/HCL
        terraformls = {},
        
        -- YAML/JSON
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
                kubernetes = "/*.k8s.yaml",
              },
            },
          },
        },
        jsonls = {},
        
        -- Dockerfile
        dockerls = {},
        docker_compose_language_service = {},
        
        -- Bash
        bashls = {},
        
        -- Markdown
        marksman = {},
      },
      
      -- LSP keymaps
      setup = {
        ["*"] = function(server, opts)
          -- Default handler
        end,
      },
    },
  },

  -- Mason - LSP/DAP/linter installer
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "lua-language-server",
        "pyright",
        "ruff-lsp",
        "rust-analyzer",
        "gopls",
        "typescript-language-server",
        "tailwindcss-language-server",
        "yaml-language-server",
        "json-lsp",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "bash-language-server",
        "terraform-ls",
        "marksman",
        
        -- Formatters
        "stylua",
        "black",
        "isort",
        "prettier",
        "gofumpt",
        "goimports",
        "shfmt",
        
        -- Linters
        "shellcheck",
        "eslint_d",
        "hadolint",  -- dockerfile linter
        "yamllint",
      },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        go = { "goimports", "gofumpt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        dockerfile = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },

  -- Better TypeScript errors
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    opts = {},
  },

  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      tools = {
        inlay_hints = {
          auto = true,
        },
      },
    },
  },

  -- Go tools
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp_inlay_hints = { enable = true },
      lsp_codelens = true,
    },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Python tools
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python Venv" },
    },
    opts = {
      name = { "venv", ".venv", "env", ".env" },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
        ft = "markdown",
      },
    },
  },

  -- Treesitter for better syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "python",
        "rust",
        "go",
        "javascript", "typescript", "tsx", "jsx",
        "html", "css",
        "json", "jsonc", "yaml", "toml",
        "bash",
        "dockerfile",
        "hcl", "terraform",
        "markdown", "markdown_inline",
        "regex",
        "sql",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
    },
  },
}
