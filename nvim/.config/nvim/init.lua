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


-- THIS IS THE SETUP RECOMMENDED BY THE Arduino-Nvim PLUGIN
-- We are putting it back.

-- Load LSP configuration first
require("Arduino-Nvim.lsp").setup()

-- Set up Arduino file type detection
vim.api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    callback = function()
        require("Arduino-Nvim")
    end
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "ipynb"
  end,
})


