-- Set editor options
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Diagnostic settings
-- Disable inline error messages (virtual text), but keep the signs in the gutter.
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})


vim.filetype.add({
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang"
  }
})

-- Auto-populate new or empty Arduino (.ino) files with setup() and loop() skeleton
local arduino_template = {
  "void setup() {",
  "    ",
  "}",
  "",
  "void loop() {",
  "    ",
  "}",
  "",
}

local arduino_skeleton_group = vim.api.nvim_create_augroup("ArduinoSkeletonTemplate", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = arduino_skeleton_group,
  pattern = "*.ino",
  callback = function(args)
    -- Only inject template if the buffer is brand new or completely empty (0 bytes)
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    if #lines == 0 or (#lines == 1 and lines[1] == "") then
      vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, arduino_template)
      vim.bo[args.buf].modified = false
      if vim.api.nvim_get_current_buf() == args.buf then
        pcall(vim.api.nvim_win_set_cursor, 0, { 2, 4 })
      end
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.filetype ~= "" then
      vim.cmd("silent! write")
    end
  end,
})
