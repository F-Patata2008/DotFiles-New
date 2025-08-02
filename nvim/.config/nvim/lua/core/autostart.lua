-- Set editor options
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Set the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Diagnostic settings
-- Disable inline error messages (virtual text), but keep the signs in the gutter.
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
