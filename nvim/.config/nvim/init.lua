-- ==========================================================================
-- INIT.LUA - Modularized for PC & Tablet (Termux)
-- ==========================================================================

-- 1. Set global options BEFORE loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Detect Environment (PC vs Tablet)
-- Check if we are running in Termux via environment variable
local is_termux = os.getenv("TERMUX_VERSION") ~= nil
-- Optional: Allow manual override via NVIM_PROFILE env var (e.g. export NVIM_PROFILE=light)
local is_light_mode = os.getenv("NVIM_PROFILE") == "light" or is_termux

if is_light_mode then
    print("📱 Mobile/Light Mode Detected: Heavy plugins disabled.")
end

-- 3. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- 4. Build the Plugin Spec dynamically
local lazy_spec = {
    -- Always load the CORE plugins (Telescope, Themes, Treesitter, etc.)
    { import = "plugins.core" },
}

-- Only load EXTRAS and CUSTOM (Copilot) if NOT in light mode
if not is_light_mode then
    table.insert(lazy_spec, { import = "plugins.extras" }) -- Arduino, Latex, Debug, Jupyter
    table.insert(lazy_spec, { import = "custom" })         -- Copilot (Heavy on battery/network)
end

-- 5. Setup Lazy
require("lazy").setup(lazy_spec, {
    change_detection = { notify = false } -- Reduces notification spam on reload
})

-- 6. Load Core Configs
require("core.autostart")
require("core.keybinds")

-- 7. Conditional Core Logic
-- Some autocommands might refer to plugins that are now disabled.
-- We wrap them in pcall or checks if necessary.

-- Example: Only setup Arduino LSP logic if not in light mode
if not is_light_mode then
    -- We use pcall to avoid errors if the module isn't loaded
    pcall(function() require("Arduino-Nvim.lsp").setup() end)
end

-- Ipynb detection is fine to keep global, but won't do much without the jupyter plugin
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "ipynb"
  end,
})
