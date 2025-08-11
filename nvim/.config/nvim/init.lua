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

-- Load plugins (esto activa todos los plugins de lua/plugins/*.lua)
require("lazy").setup("plugins")

-- 🟢 AHORA SÍ: carga tus opciones y atajos
require("core.autostart")
require("core.keybinds")

require("init")
require("custom.copilot")
