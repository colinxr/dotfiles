-- Disable diagnostics for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Auto-reload files when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("silent! checktime")
    end
  end,
})

-- Refresh Neo-tree when files change
vim.api.nvim_create_autocmd({ "BufWritePost", "FileChangedShellPost" }, {
  pattern = "*",
  callback = function()
    local ok, neo_tree = pcall(require, "neo-tree")
    if ok and neo_tree.config then
      require("neo-tree.events").fire_event("filesystem_changed")
    end
  end,
})