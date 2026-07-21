local M = {}

local Terminal = require("toggleterm.terminal").Terminal
local pest_term = nil
local last_cmd = nil

local function find_root()
  local laravel = vim.fs.root(0, { "artisan" })
  if laravel then
    return laravel
  end
  return vim.fs.root(0, { "composer.json", "tests/Pest.php" })
end

local function pest_bin(root)
  if root then
    return "./vendor/bin/pest"
  end
  return "vendor/bin/pest"
end

local function build_cmd(args)
  local root = find_root()
  local bin = pest_bin(root)
  if root and root ~= vim.uv.cwd() then
    return string.format("cd %s && %s %s", vim.fn.shellescape(root), bin, args)
  end
  return string.format("%s %s", bin, args)
end

local function rel_to_root(file)
  local root = find_root()
  if not root then
    return file
  end
  return vim.fn.fnamemodify(file, ":.")
end

local function nearest_test_name()
  local patterns = { "test(", "it(" }
  local best_line = 0
  local best_name = nil
  for _, p in ipairs(patterns) do
    local lnum = vim.fn.search(p, "bnW")
    if lnum > 0 and lnum > best_line then
      local line = vim.fn.getline(lnum)
      local s = line:match("%b''") or line:match('%b""')
      if s then
        best_line = lnum
        best_name = s:sub(2, -2)
      end
    end
  end
  return best_name
end

local function ensure_term()
  if not pest_term then
    pest_term = Terminal:new({
      direction = "float",
      float_opts = { border = "single" },
      close_on_exit = false,
      hidden = true,
      on_open = function(t)
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = t.bufnr, silent = true })
      end,
    })
  end
  return pest_term
end

local function run(cmd)
  last_cmd = cmd
  local term = ensure_term()
  term:open()
  vim.defer_fn(function()
    term:send(cmd, true)
  end, 60)
end

function M.run_file()
  local file = rel_to_root(vim.fn.expand("%:p"))
  local cmd = build_cmd(vim.fn.shellescape(file))
  run(cmd)
  vim.notify("Pest: " .. file, vim.log.levels.INFO)
end

function M.run_nearest()
  local name = nearest_test_name()
  local file = rel_to_root(vim.fn.expand("%:p"))
  if not name then
    local cmd = build_cmd(vim.fn.shellescape(file))
    run(cmd)
    vim.notify("Pest: no nearest test, running file " .. file, vim.log.levels.INFO)
    return
  end
  local cmd = build_cmd(vim.fn.shellescape(file) .. " --filter=" .. vim.fn.shellescape(name))
  run(cmd)
  vim.notify("Pest: " .. name, vim.log.levels.INFO)
end

function M.run_last()
  if not last_cmd then
    vim.notify("Pest: no last run", vim.log.levels.WARN)
    return
  end
  run(last_cmd)
  vim.notify("Pest: re-running last", vim.log.levels.INFO)
end

function M.toggle_output()
  local term = ensure_term()
  term:toggle()
end

return M
