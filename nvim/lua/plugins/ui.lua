-- UI enhancements
return {
  -- Colorscheme - gruvbox for that warm beer-in-hand vibe
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      terminal_colors = true,
      contrast = "hard",
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        folds = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- Better UI for vim.ui.select and vim.ui.input
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        enabled = true,
        win_options = {
          winblend = 0,
        },
      },
      select = {
        backend = { "telescope", "builtin" },
      },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "neo-tree",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "compact",
      stages = "fade",
    },
  },

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "gruvbox",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "filename",
            path = 1,  -- relative path
          },
        },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return " " .. table.concat(names, ", ")
            end,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    opts = {
      theme = "doom",
      config = {
        header = {
          [[                                                    ]],
          [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
          [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
          [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
          [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
          [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
          [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          [[                                                    ]],
        },
        center = {
          {
            icon = "  ",
            desc = "Find File           ",
            key = "f",
            action = "Telescope find_files",
          },
          {
            icon = "  ",
            desc = "Recent Files        ",
            key = "r",
            action = "Telescope oldfiles",
          },
          {
            icon = "  ",
            desc = "Find Text           ",
            key = "g",
            action = "Telescope live_grep",
          },
          {
            icon = "  ",
            desc = "Config              ",
            key = "c",
            action = "edit ~/.config/nvim/init.lua",
          },
          {
            icon = "  ",
            desc = "Lazy                ",
            key = "l",
            action = "Lazy",
          },
          {
            icon = "  ",
            desc = "Quit                ",
            key = "q",
            action = "qa",
          },
        },
      },
    },
  },

  -- Highlight colors in code
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        names = false,  -- disable named colors like "blue"
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        tailwind = true,
      },
    },
  },

  -- Show keybindings
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = true,
        registers = true,
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
    },
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
    },
  },

  -- Highlight TODO/FIXME comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
        PERF = { icon = " ", color = "default", alt = { "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "SPEC" } },
      },
    },
  },

  -- Show context breadcrumbs
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      separator = " > ",
      highlight = true,
      depth_limit = 5,
    },
    config = function(_, opts)
      local navic = require("nvim-navic")
      navic.setup(opts)
      
      -- Attach to LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, args.buf)
          end
        end,
      })
    end,
  },
}
