-- Laravel-specific development tools
return {
  -- PHP import class via LSP code action
  {
    "neovim/nvim-lspconfig",
    ft = "php",
    keys = {
      {
        "<leader>pi",
        function()
          vim.lsp.buf.code_action({
            filter = function(action)
              return action.title:match("Import")
            end,
            apply = true,
          })
        end,
        desc = "Import Class",
        ft = "php",
      },
    },
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
}
