-- Set <leader> BEFORE lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from both plugins/ and custom/
require("lazy").setup({
  { import = "plugins" },
  { import = "custom" }
})

-- 🟢 AHORA SÍ: carga tus opciones y atajos
require("core.autostart")
require("core.keybinds")


-- Defer Arduino-Nvim setup until plugins are loaded
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("ArduinoNvimManualSetup", { clear = true }),
  callback = function()
    -- This code runs AFTER lazy.nvim has loaded your plugins.

    -- We only need to set up the filetype detection for Arduino-Nvim.
    -- The LSP part is now handled entirely by mason-lspconfig in your plugins.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "arduino",
        callback = function()
            -- This will load the main part of the Arduino-Nvim plugin,
            -- which might provide commands or other non-LSP features.
            pcall(require, "Arduino-Nvim")
        end
    })
  end,
})
