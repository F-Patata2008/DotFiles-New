-- ==========================================================================
-- INIT.LUA - Modularized for PC & Tablet (Termux)
-- ==========================================================================

-- 1. Set global options BEFORE loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Neovim 0.11/0.12 Treesitter compatibility shim:
-- In Nvim 0.11+, Query:_apply_directives passes table<integer, TSNode[]> (a list of nodes)
-- instead of a single TSNode per capture. Unwrap node tables so predicates and get_node_text don't crash.
local function unwrap_ts_node(node)
  if type(node) == "table" and node[1] and type(node[1]) == "userdata" then
    return node[1]
  end
  return node
end

local orig_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
  return orig_get_node_text(unwrap_ts_node(node), source, opts)
end

local orig_get_range = vim.treesitter.get_range
vim.treesitter.get_range = function(node, source, metadata)
  return orig_get_range(unwrap_ts_node(node), source, metadata)
end

local orig_add_directive = vim.treesitter.query.add_directive
vim.treesitter.query.add_directive = function(name, handler, opts)
  local wrapped = function(match, pattern, bufnr, pred, metadata)
    local proxy = setmetatable({}, {
      __index = function(_, k) return unwrap_ts_node(match[k]) end,
      __newindex = function(_, k, v) match[k] = v end,
    })
    return handler(proxy, pattern, bufnr, pred, metadata)
  end
  return orig_add_directive(name, wrapped, opts)
end

local orig_add_predicate = vim.treesitter.query.add_predicate
vim.treesitter.query.add_predicate = function(name, handler, opts)
  local wrapped = function(match, pattern, bufnr, pred)
    local proxy = setmetatable({}, {
      __index = function(_, k) return unwrap_ts_node(match[k]) end,
      __newindex = function(_, k, v) match[k] = v end,
    })
    return handler(proxy, pattern, bufnr, pred)
  end
  return orig_add_predicate(name, wrapped, opts)
end

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
pcall(require, "core.current-theme")

-- 7. Conditional Core Logic
-- (Arduino environment, lcd, config reloading & LSP setup are handled modularly in plugins.extras.arduino)

