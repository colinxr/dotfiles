return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "V13Axel/neotest-pest",
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch",
      },
    },
    opts = function()
      -- Custom adapter that extends neotest-pest to support describe() blocks
      local pest_adapter = require("neotest-pest")({
        pest_cmd = function()
          local laravel_root = vim.fs.root(0, { "artisan" })
          if laravel_root then
            return { "sh", "-c", "cd " .. laravel_root .. " && ./vendor/bin/pest \"$@\"", "--" }
          end
          return { "vendor/bin/pest" }
        end,
        root_files = { "artisan", "tests/Pest.php" },
        ignore_dirs = { "vendor", "node_modules" },
        parallel = 0,
      })

      -- Override discover_positions to support describe() blocks
      local lib = require("neotest.lib")
      pest_adapter.discover_positions = function(path)
        local query = [[
          ;; Match describe() blocks as namespaces
          ((function_call_expression
              function: (name) @func_name (#eq? @func_name "describe")
              arguments: (arguments . (argument (_ (string_content) @namespace.name)))
          )) @namespace.definition

          ;; Match test() and it() calls
          ((function_call_expression
              function: (name) @func_name (#match? @func_name "^(test|it)$")
              arguments: (arguments . (argument (_ (string_content) @test.name)))
          )) @test.definition
        ]]

        return lib.treesitter.parse_positions(path, query, {
          position_id = "require('neotest-pest.utils').make_test_id",
        })
      end

      return {
        adapters = { pest_adapter },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            vim.cmd("copen")
          end,
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, neotest_ns)

      require("neotest").setup(opts)
    end,
  },
}
