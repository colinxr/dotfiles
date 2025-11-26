-- Full IDE setup with AI completion and diff review
return {
  -- Git diff view - cursor-like staging/review workflow
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: Branch History" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
      file_panel = {
        win_config = {
          width = 35,
        },
      },
    },
  },

  -- Git signs with inline blame
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
      end,
    },
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  -- Better code action UI
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<leader>ca",
        function()
          require("actions-preview").code_actions()
        end,
        desc = "Code Action (Preview)",
        mode = { "n", "v" },
      },
    },
    opts = {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.6,
          height = 0.7,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    },
  },

  -- Inline diagnostics
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    keys = {
      {
        "<leader>ul",
        function()
          local ll = require("lsp_lines")
          ll.toggle()
        end,
        desc = "Toggle LSP Lines",
      },
    },
    config = function()
      require("lsp_lines").setup()
      -- Disable by default, toggle with keybind
      vim.diagnostic.config({ virtual_lines = false })
    end,
  },

  -- Docker integration
  {
    "kkvh/vim-docker-tools",
    ft = { "dockerfile", "yaml" },
    keys = {
      { "<leader>db", "<cmd>DockerBuild<cr>", desc = "Docker Build" },
      { "<leader>dr", "<cmd>DockerRun<cr>", desc = "Docker Run" },
      { "<leader>dc", "<cmd>DockerCompose<cr>", desc = "Docker Compose" },
    },
  },

  -- Treesitter context - keep function signature visible
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 4,
      min_window_height = 20,
    },
  },

  -- Better folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open All Folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
    },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    init = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },

  -- File browser with preview
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "node_modules",
          },
        },
        follow_current_file = {
          enabled = true,
        },
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
    },
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        auto_preview = true,
        win_height = 15,
        win_vheight = 15,
      },
    },
  },

  -- Search/replace across project
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in Files (Spectre)",
      },
    },
  },

  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `toggle()`.
      { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
    },
    config = function()
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
      }

      -- Required for `vim.g.opencode_opts.auto_reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps
      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask about this" })
      vim.keymap.set({ "n", "x" }, "<leader>os", function()
        require("opencode").select()
      end, { desc = "Select prompt" })
      vim.keymap.set({ "n", "x" }, "<leader>o+", function()
        require("opencode").prompt("@this")
      end, { desc = "Add this" })
      vim.keymap.set("n", "<leader>ot", function()
        require("opencode").toggle()
      end, { desc = "Toggle embedded" })
      vim.keymap.set("n", "<leader>oc", function()
        require("opencode").command()
      end, { desc = "Select command" })
      vim.keymap.set("n", "<leader>on", function()
        require("opencode").command("session_new")
      end, { desc = "New session" })
      vim.keymap.set("n", "<leader>oi", function()
        require("opencode").command("session_interrupt")
      end, { desc = "Interrupt session" })
      vim.keymap.set("n", "<leader>oA", function()
        require("opencode").command("agent_cycle")
      end, { desc = "Cycle selected agent" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("messages_half_page_up")
      end, { desc = "Messages half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("messages_half_page_down")
      end, { desc = "Messages half page down" })
    end,
  },

  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.auto_reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<C-a>", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "x" }, "ga", function()
        require("opencode").prompt("@this")
      end, { desc = "Add to opencode" })
      vim.keymap.set({ "n", "t" }, "<C-.>", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "opencode half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "opencode half page down" })
      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
  },

  {
    "ccaglak/phptools.nvim",
    keys = {
      { "<leader>lm", "<cmd>PhpTools Method<cr>" },
      { "<leader>lc", "<cmd>PhpTools Class<cr>" },
      { "<leader>ls", "<cmd>PhpTools Scripts<cr>" },
      { "<leader>ln", "<cmd>PhpTools Namespace<cr>" },
      { "<leader>lg", "<cmd>PhpTools GetSet<cr>" },
      { "<leader>lf", "<cmd>PhpTools Create<cr>" },
      { "<leader>ld", "<cmd>PhpTools DrupalAutoLoader<cr>" },
      { mode = "v", "<leader>lr", "<cmd>PhpTools Refactor<cr>" },
    },
    dependencies = {
      -- "ccaglak/namespace.nvim", -- optional - php namespace resolver
      -- "ccaglak/larago.nvim", -- optional -- laravel goto blade/components
      -- "ccaglak/snippets.nvim", -- optional -- native snippet expander
    },
    config = function()
      require("phptools").setup({
        ui = {
          enable = true, -- default:true; false only if you have a UI enhancement plugin
          fzf = false, -- default:false; tests requires fzf used only in tests module otherwise there might long list  of tests
        },
        drupal_autoloader = { -- delete if you dont use it
          enable = false, -- default:false
          scan_paths = { "/web/modules/contrib/" }, -- Paths to scan for modules
          root_markers = { ".git" }, -- Project root markers
          autoload_file = "/vendor/composer/autoload_psr4.php", -- Autoload file path
        },
        custom_toggles = { -- delete if you dont use it
          enable = false, -- default:false
          -- { "foo", "bar", "baz" }, -- Add more custom toggle groups here
        },
      })

      local map = vim.keymap.set

      local ide_helper = require("phptools.ide_helper") -- delete if you dont use it
      -- Laravel IDE Helper keymaps
      map("n", "<leader>lha", ide_helper.generate_all, { desc = "Generate all IDE helpers" })
      map("n", "<leader>lhm", ide_helper.generate_models, { desc = "Generate model helpers" })
      map("n", "<leader>lhf", ide_helper.generate_facades, { desc = "Generate facade helpers" })
      map("n", "<leader>lht", ide_helper.generate_meta, { desc = "Generate meta helper" })
      map("n", "<leader>lhi", ide_helper.install, { desc = "Install IDE Helper package" })

      local tests = require("phptools.tests") -- delete if you have a test plugin
      map("n", "<Leader>ta", tests.test.all, { desc = "Run all tests" })
      map("n", "<Leader>tf", tests.test.file, { desc = "Run current file tests" })
      map("n", "<Leader>tl", tests.test.line, { desc = "Run test at cursor" })
      map("n", "<Leader>ts", tests.test.filter, { desc = "Search and run test" })
      map("n", "<Leader>tp", tests.test.parallel, { desc = "Run tests in parallel" })
      map("n", "<Leader>tr", tests.test.rerun, { desc = "Rerun last test" })
      map("n", "<Leader>ti", tests.test.selected, { desc = "Run selected test file" })
    end,
  },
}
