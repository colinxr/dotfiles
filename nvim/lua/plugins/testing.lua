-- Disable neotest and neotest-pest entirely
-- Use direct pest runner via keybindings instead (set up in keymaps.lua)
return {
  { "nvim-neotest/neotest", enabled = false },
  { "V13Axel/neotest-pest", enabled = false },
}
