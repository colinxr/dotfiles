-- UI enhancements
return {
  -- Colorscheme - dracula, palette-matched to the tmux status line (triadic muted):
  --   purple #bd93f9 workspace · cyan #8be9fd system · orange #ffb86c anchor
  -- bg is pinned to the status-bar segment bg (#21222c) so nvim's background
  -- matches the bar rather than stock dracula's #282a36.
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    opts = {
      transparent_bg = false,
      italic_comment = true,
      term_colors = true,
      colors = {
        bg = "#21222c",
        selection = "#44475a",
      },
      overrides = function(colors)
        return {
          Visual = { bg = "#44475a" },
          CursorLineNr = { fg = colors.orange },
          -- snacks dashboard: orange header = the session-block anchor colour
          SnacksDashboardHeader = { fg = colors.orange },
          SnacksDashboardIcon = { fg = colors.purple },
          SnacksDashboardKey = { fg = colors.cyan },
        }
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
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

  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = {
        border = "single",
      },
    },
  },
}
