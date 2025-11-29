-- Laravel-specific development tools
return {
  -- PHP and Laravel snippets
  {
    "molleweide/LuaSnip-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/php" } })
    end,
  },

  -- Laravel artisan commands integration
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Laravel" },
    keys = {
      { "<leader>la", "<cmd>Laravel artisan<cr>", desc = "Laravel Artisan" },
      { "<leader>lr", "<cmd>Laravel routes<cr>", desc = "Laravel Routes" },
      { "<leader>lm", "<cmd>Laravel related<cr>", desc = "Laravel Related Files" },
      { "<leader>lc", "<cmd>Laravel controllers<cr>", desc = "Laravel Controllers" },
      { "<leader>lC", "<cmd>Laravel components<cr>", desc = "Laravel Components" },
      { "<leader>lv", "<cmd>Laravel views<cr>", desc = "Laravel Views" },
      { "<leader>lM", "<cmd>Laravel models<cr>", desc = "Laravel Models" },
      { "<leader>lR", "<cmd>Laravel relationships<cr>", desc = "Laravel Relationships" },
    },
    config = function()
      require("laravel").setup({
        environments = {
          {
            name = "local",
            host = "localhost",
            port = 8000,
            command = "php artisan serve",
          },
        },
        features = {
          route_info = {
            enabled = true,
            position = "right",
          },
          model_info = {
            enabled = true,
            position = "right",
          },
        },
      })
    end,
  },

  -- PHP refactoring tools
  {
    "phpactor/phpactor",
    ft = "php",
    build = "composer install --no-dev -o",
    keys = {
      { "<leader>pm", "<cmd>PhpactorContextMenu<cr>", desc = "Phpactor Context Menu" },
      { "<leader>pn", "<cmd>PhpactorClassNew<cr>", desc = "New Class" },
      { "<leader>pi", "<cmd>PhpactorImportClass<cr>", desc = "Import Class" },
      { "<leader>pu", "<cmd>PhpactorImportMissingClasses<cr>", desc = "Import Missing Classes" },
    },
    config = function()
      vim.opt.updatetime = 300
      vim.cmd([[autocmd CursorHold * call phpactor#AutoUpdate()]])
    end,
  },

  -- Auto import for PHP
  {
    "phpactor/phpactor",
    ft = "php",
    config = function()
      -- Auto import on completion
      vim.api.nvim_create_autocmd("CompleteDone", {
        pattern = "*.php",
        callback = function()
          if vim.fn.pumvisible() == 0 then
            vim.cmd("PhpactorImportMissingClasses")
          end
        end,
      })
    end,
  },

  -- PHP CS Fixer integration
  {
    "stephpy/vim-php-cs-fixer",
    ft = "php",
    keys = {
      { "<leader>pf", "<cmd>PhpCsFixerFixFile<cr>", desc = "PHP CS Fixer" },
    },
    config = function()
      vim.g.php_cs_fixer_rules = "@PSR12,@Symfony"
      vim.g.php_cs_fixer_config_file = ".php-cs-fixer.php"
      vim.g.php_cs_fixer_php_path = "php"
    end,
  },

  -- Laravel goto view
  {
    "tyru/open-browser.vim",
    ft = "php",
    keys = {
      { "gv", "<cmd>call laravel#goto_view()<cr>", desc = "Go to View" },
    },
    config = function()
      -- Custom function to open views
      vim.cmd([[
        function! laravel#goto_view()
          let view_name = expand("<cword>")
          let view_path = "resources/views/" . substitute(view_name, "\\.", "/", "g") . ".blade.php"
          if filereadable(view_path)
            execute "edit " . view_path
          else
            echo "View not found: " . view_path
          endif
        endfunction
      ]])
    end,
  },
}

