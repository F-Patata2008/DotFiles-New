==================================================================
 DUMP DE CONFIGURACIÓN: nvim/.config/nvim
 Fecha: Sat Jan 24 09:01:18 PM -03 2026
==================================================================


################################################################################
ARCHIVO: nvim/.config/nvim/init.lua
################################################################################

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
--[[
-- Set up Arduino file type detection
vim.api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    callback = function()
        require("Arduino-Nvim")
    end
})
]]
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "ipynb"
  end,
})


################################################################################
ARCHIVO: nvim/.config/nvim/lua/core/autostart.lua
################################################################################

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

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.filetype ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

################################################################################
ARCHIVO: nvim/.config/nvim/lua/core/current-theme.lua
################################################################################

vim.cmd("colorscheme tokyonight-night")
################################################################################
ARCHIVO: nvim/.config/nvim/lua/core/keybinds.lua
################################################################################

local map = vim.keymap.set

-- Open Telescope theme chooser with <leader>th
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Choose Theme" })

map('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})

-- Save file with Ctrl + s
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save File" })

-- Select all text with Ctrl + g
-- gg goes to the first line, V enters visual line mode, G goes to the last line
map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- Quit Neovim with Ctrl + q
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })

map('n', '<C-l>', '<Cmd>VimtexCompile<CR>', {
                noremap = true,
                silent = true,
                desc = "Compile LaTeX (Vimtex)"
            })

-- Trouble plugin keymaps
-- Use <cmd>...<CR> for robustness, as it doesn't require the plugin to be loaded beforehand.
map("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle Trouble List" })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Workspace Diagnostics" })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Document Diagnostics" })

map("n", "<leader>mp", "<cmd>RenderMarkdownToggle<CR>", { desc = "Toggle Markdown Render" })



################################################################################
ARCHIVO: nvim/.config/nvim/lua/custom/copilot.lua
################################################################################

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, -- disable ghost text inline
        panel = { enabled = false },      -- disable side panel
        filetypes = { ["*"] = true },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = "copilot.lua",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },  -- use copilot.lua as backend
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup({})
      vim.keymap.set("n", "<C-c>", ":CopilotChat<CR>", { noremap = true, silent = true })
    end,
  },
}


################################################################################
ARCHIVO: nvim/.config/nvim/lua/dkjson.lua
################################################################################

-- Module options:
local always_use_lpeg = false
local register_global_module_table = false
local global_module_name = 'json'

--[==[

David Kolf's JSON module for Lua 5.1 - 5.4

Version 2.8


For the documentation see the corresponding readme.txt or visit
<http://dkolf.de/dkjson-lua/>.

You can contact the author by sending an e-mail to 'david' at the
domain 'dkolf.de'.


Copyright (C) 2010-2024 David Heiko Kolf

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]==]

-- global dependencies:
local pairs, type, tostring, tonumber, getmetatable, setmetatable =
      pairs, type, tostring, tonumber, getmetatable, setmetatable
local error, require, pcall, select = error, require, pcall, select
local floor, huge = math.floor, math.huge
local strrep, gsub, strsub, strbyte, strchar, strfind, strlen, strformat =
      string.rep, string.gsub, string.sub, string.byte, string.char,
      string.find, string.len, string.format
local strmatch = string.match
local concat = table.concat

local json = { version = "dkjson 2.8" }

local jsonlpeg = {}

if register_global_module_table then
  if always_use_lpeg then
    _G[global_module_name] = jsonlpeg
  else
    _G[global_module_name] = json
  end
end

local _ENV = nil -- blocking globals in Lua 5.2 and later

pcall (function()
  -- Enable access to blocked metatables.
  -- Don't worry, this module doesn't change anything in them.
  local debmeta = require "debug".getmetatable
  if debmeta then getmetatable = debmeta end
end)

json.null = setmetatable ({}, {
  __tojson = function () return "null" end
})

local function isarray (tbl)
  local max, n, arraylen = 0, 0, 0
  for k,v in pairs (tbl) do
    if k == 'n' and type(v) == 'number' then
      arraylen = v
      if v > max then
        max = v
      end
    else
      if type(k) ~= 'number' or k < 1 or floor(k) ~= k then
        return false
      end
      if k > max then
        max = k
      end
      n = n + 1
    end
  end
  if max > 10 and max > arraylen and max > n * 2 then
    return false -- don't create an array with too many holes
  end
  return true, max
end

local escapecodes = {
  ["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f",
  ["\n"] = "\\n",  ["\r"] = "\\r",  ["\t"] = "\\t"
}

local function escapeutf8 (uchar)
  local value = escapecodes[uchar]
  if value then
    return value
  end
  local a, b, c, d = strbyte (uchar, 1, 4)
  a, b, c, d = a or 0, b or 0, c or 0, d or 0
  if a <= 0x7f then
    value = a
  elseif 0xc0 <= a and a <= 0xdf and b >= 0x80 then
    value = (a - 0xc0) * 0x40 + b - 0x80
  elseif 0xe0 <= a and a <= 0xef and b >= 0x80 and c >= 0x80 then
    value = ((a - 0xe0) * 0x40 + b - 0x80) * 0x40 + c - 0x80
  elseif 0xf0 <= a and a <= 0xf7 and b >= 0x80 and c >= 0x80 and d >= 0x80 then
    value = (((a - 0xf0) * 0x40 + b - 0x80) * 0x40 + c - 0x80) * 0x40 + d - 0x80
  else
    return ""
  end
  if value <= 0xffff then
    return strformat ("\\u%.4x", value)
  elseif value <= 0x10ffff then
    -- encode as UTF-16 surrogate pair
    value = value - 0x10000
    local highsur, lowsur = 0xD800 + floor (value/0x400), 0xDC00 + (value % 0x400)
    return strformat ("\\u%.4x\\u%.4x", highsur, lowsur)
  else
    return ""
  end
end

local function fsub (str, pattern, repl)
  -- gsub always builds a new string in a buffer, even when no match
  -- exists. First using find should be more efficient when most strings
  -- don't contain the pattern.
  if strfind (str, pattern) then
    return gsub (str, pattern, repl)
  else
    return str
  end
end

local function quotestring (value)
  -- based on the regexp "escapable" in https://github.com/douglascrockford/JSON-js
  value = fsub (value, "[%z\1-\31\"\\\127]", escapeutf8)
  if strfind (value, "[\194\216\220\225\226\239]") then
    value = fsub (value, "\194[\128-\159\173]", escapeutf8)
    value = fsub (value, "\216[\128-\132]", escapeutf8)
    value = fsub (value, "\220\143", escapeutf8)
    value = fsub (value, "\225\158[\180\181]", escapeutf8)
    value = fsub (value, "\226\128[\140-\143\168-\175]", escapeutf8)
    value = fsub (value, "\226\129[\160-\175]", escapeutf8)
    value = fsub (value, "\239\187\191", escapeutf8)
    value = fsub (value, "\239\191[\176-\191]", escapeutf8)
  end
  return "\"" .. value .. "\""
end
json.quotestring = quotestring

local function replace(str, o, n)
  local i, j = strfind (str, o, 1, true)
  if i then
    return strsub(str, 1, i-1) .. n .. strsub(str, j+1, -1)
  else
    return str
  end
end

-- locale independent num2str and str2num functions
local decpoint, numfilter

local function updatedecpoint ()
  decpoint = strmatch(tostring(0.5), "([^05+])")
  -- build a filter that can be used to remove group separators
  numfilter = "[^0-9%-%+eE" .. gsub(decpoint, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "]+"
end

updatedecpoint()

local function num2str (num)
  return replace(fsub(tostring(num), numfilter, ""), decpoint, ".")
end

local function str2num (str)
  local num = tonumber(replace(str, ".", decpoint))
  if not num then
    updatedecpoint()
    num = tonumber(replace(str, ".", decpoint))
  end
  return num
end

local function addnewline2 (level, buffer, buflen)
  buffer[buflen+1] = "\n"
  buffer[buflen+2] = strrep ("  ", level)
  buflen = buflen + 2
  return buflen
end

function json.addnewline (state)
  if state.indent then
    state.bufferlen = addnewline2 (state.level or 0,
                           state.buffer, state.bufferlen or #(state.buffer))
  end
end

local encode2 -- forward declaration

local function addpair (key, value, prev, indent, level, buffer, buflen, tables, globalorder, state)
  local kt = type (key)
  if kt ~= 'string' and kt ~= 'number' then
    return nil, "type '" .. kt .. "' is not supported as a key by JSON."
  end
  if prev then
    buflen = buflen + 1
    buffer[buflen] = ","
  end
  if indent then
    buflen = addnewline2 (level, buffer, buflen)
  end
  -- When Lua is compiled with LUA_NOCVTN2S this will fail when
  -- numbers are mixed into the keys of the table. JSON keys are always
  -- strings, so this would be an implicit conversion too and the failure
  -- is intentional.
  buffer[buflen+1] = quotestring (key)
  buffer[buflen+2] = ":"
  return encode2 (value, indent, level, buffer, buflen + 2, tables, globalorder, state)
end

local function appendcustom(res, buffer, state)
  local buflen = state.bufferlen
  if type (res) == 'string' then
    buflen = buflen + 1
    buffer[buflen] = res
  end
  return buflen
end

local function exception(reason, value, state, buffer, buflen, defaultmessage)
  defaultmessage = defaultmessage or reason
  local handler = state.exception
  if not handler then
    return nil, defaultmessage
  else
    state.bufferlen = buflen
    local ret, msg = handler (reason, value, state, defaultmessage)
    if not ret then return nil, msg or defaultmessage end
    return appendcustom(ret, buffer, state)
  end
end

function json.encodeexception(reason, value, state, defaultmessage)
  return quotestring("<" .. defaultmessage .. ">")
end

encode2 = function (value, indent, level, buffer, buflen, tables, globalorder, state)
  local valtype = type (value)
  local valmeta = getmetatable (value)
  valmeta = type (valmeta) == 'table' and valmeta -- only tables
  local valtojson = valmeta and valmeta.__tojson
  if valtojson then
    if tables[value] then
      return exception('reference cycle', value, state, buffer, buflen)
    end
    tables[value] = true
    state.bufferlen = buflen
    local ret, msg = valtojson (value, state)
    if not ret then return exception('custom encoder failed', value, state, buffer, buflen, msg) end
    tables[value] = nil
    buflen = appendcustom(ret, buffer, state)
  elseif value == nil then
    buflen = buflen + 1
    buffer[buflen] = "null"
  elseif valtype == 'number' then
    local s
    if value ~= value or value >= huge or -value >= huge then
      -- This is the behaviour of the original JSON implementation.
      s = "null"
    else
      s = num2str (value)
    end
    buflen = buflen + 1
    buffer[buflen] = s
  elseif valtype == 'boolean' then
    buflen = buflen + 1
    buffer[buflen] = value and "true" or "false"
  elseif valtype == 'string' then
    buflen = buflen + 1
    buffer[buflen] = quotestring (value)
  elseif valtype == 'table' then
    if tables[value] then
      return exception('reference cycle', value, state, buffer, buflen)
    end
    tables[value] = true
    level = level + 1
    local isa, n = isarray (value)
    if n == 0 and valmeta and valmeta.__jsontype == 'object' then
      isa = false
    end
    local msg
    if isa then -- JSON array
      buflen = buflen + 1
      buffer[buflen] = "["
      for i = 1, n do
        buflen, msg = encode2 (value[i], indent, level, buffer, buflen, tables, globalorder, state)
        if not buflen then return nil, msg end
        if i < n then
          buflen = buflen + 1
          buffer[buflen] = ","
        end
      end
      buflen = buflen + 1
      buffer[buflen] = "]"
    else -- JSON object
      local prev = false
      buflen = buflen + 1
      buffer[buflen] = "{"
      local order = valmeta and valmeta.__jsonorder or globalorder
      if order then
        local used = {}
        n = #order
        for i = 1, n do
          local k = order[i]
          local v = value[k]
          if v ~= nil then
            used[k] = true
            buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder, state)
            if not buflen then return nil, msg end
            prev = true -- add a seperator before the next element
          end
        end
        for k,v in pairs (value) do
          if not used[k] then
            buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder, state)
            if not buflen then return nil, msg end
            prev = true -- add a seperator before the next element
          end
        end
      else -- unordered
        for k,v in pairs (value) do
          buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder, state)
          if not buflen then return nil, msg end
          prev = true -- add a seperator before the next element
        end
      end
      if indent then
        buflen = addnewline2 (level - 1, buffer, buflen)
      end
      buflen = buflen + 1
      buffer[buflen] = "}"
    end
    tables[value] = nil
  else
    return exception ('unsupported type', value, state, buffer, buflen,
      "type '" .. valtype .. "' is not supported by JSON.")
  end
  return buflen
end

function json.encode (value, state)
  state = state or {}
  local oldbuffer = state.buffer
  local buffer = oldbuffer or {}
  state.buffer = buffer
  updatedecpoint()
  local ret, msg = encode2 (value, state.indent, state.level or 0,
                   buffer, state.bufferlen or 0, state.tables or {}, state.keyorder, state)
  if not ret then
    error (msg, 2)
  elseif oldbuffer == buffer then
    state.bufferlen = ret
    return true
  else
    state.bufferlen = nil
    state.buffer = nil
    return concat (buffer)
  end
end

local function loc (str, where)
  local line, pos, linepos = 1, 1, 0
  while true do
    pos = strfind (str, "\n", pos, true)
    if pos and pos < where then
      line = line + 1
      linepos = pos
      pos = pos + 1
    else
      break
    end
  end
  return strformat ("line %d, column %d", line, where - linepos)
end

local function unterminated (str, what, where)
  return nil, strlen (str) + 1, "unterminated " .. what .. " at " .. loc (str, where)
end

local function scanwhite (str, pos)
  while true do
    pos = strfind (str, "%S", pos)
    if not pos then return nil end
    local sub2 = strsub (str, pos, pos + 1)
    if sub2 == "\239\187" and strsub (str, pos + 2, pos + 2) == "\191" then
      -- UTF-8 Byte Order Mark
      pos = pos + 3
    elseif sub2 == "//" then
      pos = strfind (str, "[\n\r]", pos + 2)
      if not pos then return nil end
    elseif sub2 == "/*" then
      pos = strfind (str, "*/", pos + 2)
      if not pos then return nil end
      pos = pos + 2
    else
      return pos
    end
  end
end

local escapechars = {
  ["\""] = "\"", ["\\"] = "\\", ["/"] = "/", ["b"] = "\b", ["f"] = "\f",
  ["n"] = "\n", ["r"] = "\r", ["t"] = "\t"
}

local function unichar (value)
  if value < 0 then
    return nil
  elseif value <= 0x007f then
    return strchar (value)
  elseif value <= 0x07ff then
    return strchar (0xc0 + floor(value/0x40),
                    0x80 + (floor(value) % 0x40))
  elseif value <= 0xffff then
    return strchar (0xe0 + floor(value/0x1000),
                    0x80 + (floor(value/0x40) % 0x40),
                    0x80 + (floor(value) % 0x40))
  elseif value <= 0x10ffff then
    return strchar (0xf0 + floor(value/0x40000),
                    0x80 + (floor(value/0x1000) % 0x40),
                    0x80 + (floor(value/0x40) % 0x40),
                    0x80 + (floor(value) % 0x40))
  else
    return nil
  end
end

local function scanstring (str, pos)
  local lastpos = pos + 1
  local buffer, n = {}, 0
  while true do
    local nextpos = strfind (str, "[\"\\]", lastpos)
    if not nextpos then
      return unterminated (str, "string", pos)
    end
    if nextpos > lastpos then
      n = n + 1
      buffer[n] = strsub (str, lastpos, nextpos - 1)
    end
    if strsub (str, nextpos, nextpos) == "\"" then
      lastpos = nextpos + 1
      break
    else
      local escchar = strsub (str, nextpos + 1, nextpos + 1)
      local value
      if escchar == "u" then
        value = tonumber (strsub (str, nextpos + 2, nextpos + 5), 16)
        if value then
          local value2
          if 0xD800 <= value and value <= 0xDBff then
            -- we have the high surrogate of UTF-16. Check if there is a
            -- low surrogate escaped nearby to combine them.
            if strsub (str, nextpos + 6, nextpos + 7) == "\\u" then
              value2 = tonumber (strsub (str, nextpos + 8, nextpos + 11), 16)
              if value2 and 0xDC00 <= value2 and value2 <= 0xDFFF then
                value = (value - 0xD800)  * 0x400 + (value2 - 0xDC00) + 0x10000
              else
                value2 = nil -- in case it was out of range for a low surrogate
              end
            end
          end
          value = value and unichar (value)
          if value then
            if value2 then
              lastpos = nextpos + 12
            else
              lastpos = nextpos + 6
            end
          end
        end
      end
      if not value then
        value = escapechars[escchar] or escchar
        lastpos = nextpos + 2
      end
      n = n + 1
      buffer[n] = value
    end
  end
  if n == 1 then
    return buffer[1], lastpos
  elseif n > 1 then
    return concat (buffer), lastpos
  else
    return "", lastpos
  end
end

local scanvalue -- forward declaration

local function scantable (what, closechar, str, startpos, nullval, objectmeta, arraymeta)
  local tbl, n = {}, 0
  local pos = startpos + 1
  if what == 'object' then
    setmetatable (tbl, objectmeta)
  else
    setmetatable (tbl, arraymeta)
  end
  while true do
    pos = scanwhite (str, pos)
    if not pos then return unterminated (str, what, startpos) end
    local char = strsub (str, pos, pos)
    if char == closechar then
      return tbl, pos + 1
    end
    local val1, err
    val1, pos, err = scanvalue (str, pos, nullval, objectmeta, arraymeta)
    if err then return nil, pos, err end
    pos = scanwhite (str, pos)
    if not pos then return unterminated (str, what, startpos) end
    char = strsub (str, pos, pos)
    if char == ":" then
      if val1 == nil then
        return nil, pos, "cannot use nil as table index (at " .. loc (str, pos) .. ")"
      end
      pos = scanwhite (str, pos + 1)
      if not pos then return unterminated (str, what, startpos) end
      local val2
      val2, pos, err = scanvalue (str, pos, nullval, objectmeta, arraymeta)
      if err then return nil, pos, err end
      tbl[val1] = val2
      pos = scanwhite (str, pos)
      if not pos then return unterminated (str, what, startpos) end
      char = strsub (str, pos, pos)
    else
      n = n + 1
      tbl[n] = val1
    end
    if char == "," then
      pos = pos + 1
    end
  end
end

scanvalue = function (str, pos, nullval, objectmeta, arraymeta)
  pos = pos or 1
  pos = scanwhite (str, pos)
  if not pos then
    return nil, strlen (str) + 1, "no valid JSON value (reached the end)"
  end
  local char = strsub (str, pos, pos)
  if char == "{" then
    return scantable ('object', "}", str, pos, nullval, objectmeta, arraymeta)
  elseif char == "[" then
    return scantable ('array', "]", str, pos, nullval, objectmeta, arraymeta)
  elseif char == "\"" then
    return scanstring (str, pos)
  else
    local pstart, pend = strfind (str, "^%-?[%d%.]+[eE]?[%+%-]?%d*", pos)
    if pstart then
      local number = str2num (strsub (str, pstart, pend))
      if number then
        return number, pend + 1
      end
    end
    pstart, pend = strfind (str, "^%a%w*", pos)
    if pstart then
      local name = strsub (str, pstart, pend)
      if name == "true" then
        return true, pend + 1
      elseif name == "false" then
        return false, pend + 1
      elseif name == "null" then
        return nullval, pend + 1
      end
    end
    return nil, pos, "no valid JSON value at " .. loc (str, pos)
  end
end

local function optionalmetatables(...)
  if select("#", ...) > 0 then
    return ...
  else
    return {__jsontype = 'object'}, {__jsontype = 'array'}
  end
end

function json.decode (str, pos, nullval, ...)
  local objectmeta, arraymeta = optionalmetatables(...)
  return scanvalue (str, pos, nullval, objectmeta, arraymeta)
end

function json.use_lpeg ()
  local g = require ("lpeg")

  if type(g.version) == 'function' and g.version() == "0.11" then
    error "due to a bug in LPeg 0.11, it cannot be used for JSON matching"
  end

  local pegmatch = g.match
  local P, S, R = g.P, g.S, g.R

  local function ErrorCall (str, pos, msg, state)
    if not state.msg then
      state.msg = msg .. " at " .. loc (str, pos)
      state.pos = pos
    end
    return false
  end

  local function Err (msg)
    return g.Cmt (g.Cc (msg) * g.Carg (2), ErrorCall)
  end

  local function ErrorUnterminatedCall (str, pos, what, state)
    return ErrorCall (str, pos - 1, "unterminated " .. what, state)
  end

  local SingleLineComment = P"//" * (1 - S"\n\r")^0
  local MultiLineComment = P"/*" * (1 - P"*/")^0 * P"*/"
  local Space = (S" \n\r\t" + P"\239\187\191" + SingleLineComment + MultiLineComment)^0

  local function ErrUnterminated (what)
    return g.Cmt (g.Cc (what) * g.Carg (2), ErrorUnterminatedCall)
  end

  local PlainChar = 1 - S"\"\\\n\r"
  local EscapeSequence = (P"\\" * g.C (S"\"\\/bfnrt" + Err "unsupported escape sequence")) / escapechars
  local HexDigit = R("09", "af", "AF")
  local function UTF16Surrogate (match, pos, high, low)
    high, low = tonumber (high, 16), tonumber (low, 16)
    if 0xD800 <= high and high <= 0xDBff and 0xDC00 <= low and low <= 0xDFFF then
      return true, unichar ((high - 0xD800)  * 0x400 + (low - 0xDC00) + 0x10000)
    else
      return false
    end
  end
  local function UTF16BMP (hex)
    return unichar (tonumber (hex, 16))
  end
  local U16Sequence = (P"\\u" * g.C (HexDigit * HexDigit * HexDigit * HexDigit))
  local UnicodeEscape = g.Cmt (U16Sequence * U16Sequence, UTF16Surrogate) + U16Sequence/UTF16BMP
  local Char = UnicodeEscape + EscapeSequence + PlainChar
  local String = P"\"" * (g.Cs (Char ^ 0) * P"\"" + ErrUnterminated "string")
  local Integer = P"-"^(-1) * (P"0" + (R"19" * R"09"^0))
  local Fractal = P"." * R"09"^0
  local Exponent = (S"eE") * (S"+-")^(-1) * R"09"^1
  local Number = (Integer * Fractal^(-1) * Exponent^(-1))/str2num
  local Constant = P"true" * g.Cc (true) + P"false" * g.Cc (false) + P"null" * g.Carg (1)
  local SimpleValue = Number + String + Constant
  local ArrayContent, ObjectContent

  -- The functions parsearray and parseobject parse only a single value/pair
  -- at a time and store them directly to avoid hitting the LPeg limits.
  local function parsearray (str, pos, nullval, state)
    local obj, cont
    local start = pos
    local npos
    local t, nt = {}, 0
    repeat
      obj, cont, npos = pegmatch (ArrayContent, str, pos, nullval, state)
      if cont == 'end' then
        return ErrorUnterminatedCall (str, start, "array", state)
      end
      pos = npos
      if cont == 'cont' or cont == 'last' then
        nt = nt + 1
        t[nt] = obj
      end
    until cont ~= 'cont'
    return pos, setmetatable (t, state.arraymeta)
  end

  local function parseobject (str, pos, nullval, state)
    local obj, key, cont
    local start = pos
    local npos
    local t = {}
    repeat
      key, obj, cont, npos = pegmatch (ObjectContent, str, pos, nullval, state)
      if cont == 'end' then
        return ErrorUnterminatedCall (str, start, "object", state)
      end
      pos = npos
      if cont == 'cont' or cont == 'last' then
        t[key] = obj
      end
    until cont ~= 'cont'
    return pos, setmetatable (t, state.objectmeta)
  end

  local Array = P"[" * g.Cmt (g.Carg(1) * g.Carg(2), parsearray)
  local Object = P"{" * g.Cmt (g.Carg(1) * g.Carg(2), parseobject)
  local Value = Space * (Array + Object + SimpleValue)
  local ExpectedValue = Value + Space * Err "value expected"
  local ExpectedKey = String + Err "key expected"
  local End = P(-1) * g.Cc'end'
  local ErrInvalid = Err "invalid JSON"
  ArrayContent = (Value * Space * (P"," * g.Cc'cont' + P"]" * g.Cc'last'+ End + ErrInvalid)  + g.Cc(nil) * (P"]" * g.Cc'empty' + End  + ErrInvalid)) * g.Cp()
  local Pair = g.Cg (Space * ExpectedKey * Space * (P":" + Err "colon expected") * ExpectedValue)
  ObjectContent = (g.Cc(nil) * g.Cc(nil) * P"}" * g.Cc'empty' + End + (Pair * Space * (P"," * g.Cc'cont' + P"}" * g.Cc'last' + End + ErrInvalid) + ErrInvalid)) * g.Cp()
  local DecodeValue = ExpectedValue * g.Cp ()

  jsonlpeg.version = json.version
  jsonlpeg.encode = json.encode
  jsonlpeg.null = json.null
  jsonlpeg.quotestring = json.quotestring
  jsonlpeg.addnewline = json.addnewline
  jsonlpeg.encodeexception = json.encodeexception
  jsonlpeg.using_lpeg = true

  function jsonlpeg.decode (str, pos, nullval, ...)
    local state = {}
    state.objectmeta, state.arraymeta = optionalmetatables(...)
    local obj, retpos = pegmatch (DecodeValue, str, pos, nullval, state)
    if state.msg then
      return nil, state.pos, state.msg
    else
      return obj, retpos
    end
  end

  -- cache result of this function:
  json.use_lpeg = function () return jsonlpeg end
  jsonlpeg.use_lpeg = json.use_lpeg

  return jsonlpeg
end

if always_use_lpeg then
  return json.use_lpeg()
end

return json


################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/alpha.lua
################################################################################

return {
     {
   'goolord/alpha-nvim',
    dependencies = { 'echasnovski/mini.icons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },
 }

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/arduino.lua
################################################################################

return {
    {
      "yuukiflow/Arduino-Nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        -- Load Arduino plugin for .ino files
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "arduino",
          callback = function()
            require("Arduino-Nvim")
          end,
        })
      end,
    }
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/autopairs.lua
################################################################################

return {
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- Will use default configuration
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    }
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/comments.lua
################################################################################

return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/completion.lua
################################################################################

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      -- Copilot source for nvim-cmp
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          --{ name = 'copilot', group_index = 2 }, -- copilot first
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            menu = {
              copilot = "[Copilot]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            }
          }),
        },
      })
    end
  }
}


################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/debugging.lua
################################################################################

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- Optional, but good to have
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Initialize the UI
      dapui.setup()

      -- UI autocommands (your code was perfect here)
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Keymaps (added more for a better experience)
      vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = "Continue" })
      vim.keymap.set('n', '<Leader>dl', dap.launch, { desc = "Launch" })
      vim.keymap.set('n', '<Leader>dso', dap.step_over, { desc = "Step Over" })
      vim.keymap.set('n', '<Leader>dsi', dap.step_into, { desc = "Step Into" })
      vim.keymap.set('n', '<Leader>dsu', dap.step_out, { desc = "Step Out" })


      -- 1. ADAPTER DEFINITION (your code was correct)
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }

      -- 2. LAUNCH CONFIGURATION (this is the missing part)
      dap.configurations.cpp = {
        {
          name = "Launch with GDB",
          type = "gdb", -- Use the adapter you defined above
          request = "launch",
          program = function()
            -- Ask for the executable path when you start debugging
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}", -- Run the program in the project root
          stopOnEntry = false, -- Don't stop at the program's entry point
        },
      }
      
      -- You can reuse the C++ configuration for C and Rust if using GDB
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

    end,
  },
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/formatter.lua
################################################################################

return {
    {
      "mhartington/formatter.nvim",
      -- Load the plugin when you open or create a file.
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        -- This setup function runs and registers the :Format command.
        require("formatter").setup({
          logging = false,
          filetype = {
            tex = { require("formatter.defaults").latexindent },
            lua = { require("formatter.defaults").stylua },
            c = { require("formatter.defaults").clang_format },
            cpp = { require("formatter.defaults").clang_format },
            objc = { require("formatter.defaults").clang_format },
            python = {
              require("formatter.defaults").isort,
              require("formatter.defaults").black,
            },
            javascript = { require("formatter.defaults").prettier },
            typescript = { require("formatter.defaults").prettier },
            javascriptreact = { require("formatter.defaults").prettier },
            typescriptreact = { require("formatter.defaults").prettier },
            html = { require("formatter.defaults").prettier },
            css = { require("formatter.defaults").prettier },
            scss = { require("formatter.defaults").prettier },
            json = { require("formatter.defaults").prettier },
            markdown = { require("formatter.defaults").prettier },
            ["*"] = {
              require("formatter.filetypes.any").remove_trailing_whitespace,
            },
          },
        })

        -- KEY CHANGE: Use the command, not the Lua function.
        -- This is the stable way to call the formatter.
        vim.keymap.set({ "n", "v" }, "<leader>gf", "<cmd>Format<cr>", { desc = "[G]o [F]ormat Buffer" })

        -- Use the plugin's recommended command for format-on-save.
        local augroup = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          pattern = "*",
          -- The :Format command will now work reliably here as well.
          command = "Format",
        })
      end,
    },
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/git.lua
################################################################################

return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup()
        end
    }
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/jupyter.lua
################################################################################

return {
  -- For transparently editing ipynb files as text
  {
     "GCBallesteros/jupytext.nvim",
  config = true,
  -- Depending on your nvim distro or config you may need to make the loading not lazy
  -- lazy=false,
  },

  -- For running cells and interacting with the kernel
  {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
        end,
    },
    {
        -- see the image.nvim readme for more information about configuring this plugin
        "3rd/image.nvim",
        opts = {
            backend = "kitty", -- whatever backend you would like to use
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
    }
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/key.lua
################################################################################

return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/latex.lua
################################################################################

-- Tu archivo de configuración de vimtex
return { 
    {
        "lervag/vimtex",
        ft = { "tex", "latex", "bib" },
        init = function()
            vim.g.vimtex_compiler_method = "latexmk"
            -- vim.g.vimtex_compiler_latexmk = { pdflatex = 'lualatex -interaction=nonstopmode %O %S' }

            vim.g.vimtex_view_zathura = {
                wayland = 1,
                nvim_instance = vim.v.servername,
            }

            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_spell_enabled = 1
        end,

        config = function()
            local map = vim.keymap.set
            local opts = { silent = true, noremap = true }
        end,
    }
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/lsp.lua
################################################################################

-- plugins/lsp.lua (or your equivalent file)
return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- This is the cmp source for LSP, and it provides the capabilities
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- This is the function that will be called when an LSP attaches to a buffer.
      local on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end

        -- Keybindings for LSP features.
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('gK', vim.lsp.buf.signature_help, 'Signature Documentation')

        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- ADDED: Keymap for formatting. This will use null-ls or any other LSP that supports formatting.
        if client.supports_method("textDocument/formatting") then
            nmap('<leader>gf', vim.lsp.buf.format, '[G]o [F]ormat Buffer')
        end

        -- The original command is also great to have.
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- The main setup function for mason-lspconfig
      require('mason-lspconfig').setup({
        ensure_installed = {"lua_ls", "clangd", "arduino_language_server", "texlab", "pyright", "hyprls", "marksman"},
        handlers = {
          -- The default handler.
          function(server_name)
            require('lspconfig')[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
            ["arduino_language_server"] = function ()
            -- Intentionally left empty
            end,
        },
      })
      
         end
  }
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/lualine.lua
################################################################################

return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require('lualine').setup({
			options = {
				theme = 'catppuccin'
			}
		})
	end
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/luasnip.lua
################################################################################

return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            -- Cargar snippets desde lua/custom/snippets
            require("luasnip.loaders.from_lua").lazy_load({
                paths = vim.fn.stdpath("config") .. "/lua/snippets"
            })

            -- También cargar snippets tipo vscode friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    }
}


################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/markdown.lua
################################################################################

-- plugins/markdown.lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({
        -- Your custom configuration goes here
      })
    end,
  },
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/mini.lua
################################################################################

-- lua/plugins/mini.lua
return {
  {
    "echasnovski/mini.indentscope",
    version = false, -- usually not needed unless you are tracking nightly Neovim
    event = "BufReadPre",
    opts = {
      -- symbol = "▏", -- Puedes cambiar el caracter de la línea si quieres
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/neo-tree.lua
################################################################################

return {
	"nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {                                     
                        "nvim-lua/plenary.nvim",
                        "nvim-tree/nvim-web-devicons",
                        "MunifTanjim/nui.nvim",},
	config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                visible = true,  -- Show filtered items (like dotfiles)
                hide_dotfiles = false,  -- Do not hide dotfiles
                hide_gitignored = true, -- Optional: Show gitignored files too
                },
            },
        })
	end
}   

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/telescope.lua
################################################################################

return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
      telescope.setup({}) -- Use default Telescope settings
      -- Load the themes extension
      telescope.load_extension('themes')
    end
  },
  {
    -- This is the plugin that provides the theme chooser
    'andrewberty/telescope-themes',
    dependencies = { 'nvim-telescope/telescope.nvim' }
  },
    {
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup {
  			extensions = {
    				["ui-select"] = {
				      require("telescope.themes").get_dropdown {}
    					}
	  			}
			}
			require("telescope").load_extension("ui-select")
		end
	}
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/themes.lua
################################################################################

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
                term_colors = true,
                styles = {
                    comments = { "italic" },
                    functions = { "italic" },
                    keywords = { "italic" },
                    variables = { "italic" },
                },
                integrations = {
                    treesitter = true,
                    telescope = true,
                    gitsigns = true,
                    lsp_trouble = true,
                    cmp = true,
                    which_key = true,
                    dashboard = true,
                    neotree = true,
                },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/treesitter.lua
################################################################################

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.hyprlang = {
        install_info = {
          url = "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "hyprlang",
      }

      require('nvim-treesitter.configs').setup({
        ensure_installed = { 
                    "c",
                    "lua", 
                    "vim", 
                    "vimdoc", 
                    "cpp", 
                    "hyprlang", 
                    "latex", 
                    "markdown", 
                    "markdown_inline",
                    "html",
                    "css",
                    "scss",
                    "json",
                    "bash",
                    "javascript",
                },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      })
    end,
  },
}


################################################################################
ARCHIVO: nvim/.config/nvim/lua/plugins/trouble.lua
################################################################################

return {
  {
    "folke/trouble.nvim",
    -- "nvim-tree/nvim-web-devicons" is an optional dependency for nice icons.
    -- We don't need to install it ourselves as it's a dependency of other plugins.
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, -- Use default settings
  },

}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/snippets/cpp.lua
################################################################################

local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t

return {
  s(
    "Patata",
    {
      t({
        "#include <bits/stdc++.h>",
        "using namespace std;",
        "",
        "typedef long long ll;",
        "typedef string str;",
        "#define vec vector",
        "",
        "int main() {",
        "    int t;",
        "    cin >> t;",
        "    while (t--) {",
        "        ",
      }),
      i(0), -- cursor inside while loop
      t({
        "",
        "    }",
        "    return 0;",
        "}",
      }),
    },
    {
      description = "Competitive Programming Template (With test cases)",
    }
  ),

  -- New snippet "Papa" without test cases
  s(
    "Papa",
    {
      t({
        "#include <bits/stdc++.h>",
        "using namespace std;",
        "",
        "typedef long long ll;",
        "typedef string str;",
        "#define vec vector",
        "",
        "int main() {",
        "    ",
      }),
      i(0), -- cursor inside main
      t({
        "",
        "    return 0;",
        "}",
      }),
    },
    {
      description = "Competitive Programming Template (Without test cases)",
    }
  ),
    s(
        "for",
        {
            t({
                "for (int i = 0; i < n; i++) {",
            }),
                i(0),
                t({"}"
            })
        }
    )
}

################################################################################
ARCHIVO: nvim/.config/nvim/lua/snippets/tex.lua
################################################################################

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- ===== HELPER FUNCTIONS (reusable for multiple snippets) =====

-- Function to create the symbolic link to the central images folder.
local function create_symlink()
  os.execute("test -e images || ln -s ~/Apunte/images/ ./images")
  return "" -- This function inserts no text
end

-- Function to create an empty bibliography file.
local function create_bib_file()
  os.execute("test -e bibliografia.bib || touch bibliografia.bib")
  return "" -- This function inserts no text
end

-- NEW: A single function to call both setup functions.
-- This solves the "Unused argument" error.
local function setup_project_files()
  create_symlink()
  create_bib_file()
  return ""
end


-- ===== SNIPPETS =====

return {
  -- Snippet 1: Your original "Documento" snippet (corrected)
  s("Documento", fmt([[
\documentclass[11pt]{{article}}
\usepackage[spanish]{{babel}}
\usepackage{{amsmath}}
\usepackage{{amssymb}}
\usepackage{{graphicx}}
\graphicspath{{ {{./images/}}, {{~/Apunte/images/}} }}
\usepackage[utf8]{{inputenc}}
\usepackage[T1]{{fontenc}}
\usepackage[margin=1in]{{geometry}}
\usepackage{{fancyhdr}}
\usepackage{{hyperref}}

\hypersetup{{
    pdftitle={{{}}},
    pdfauthor={{{}}},
    colorlinks=true,
    linkcolor=black,
    urlcolor=cyan
}}

\pagestyle{{fancy}}
\fancyhf{{}}
\fancyfoot[C]{{\footnotesize Felipe Colli, Todos los Derechos Reservados}}
\fancyfoot[R]{{\thepage}}
\renewcommand{{\headrulewidth}}{{0pt}}

\title{{{}}}
\author{{{}}}
\date{{\today}}

\begin{{document}}

\maketitle
\thispagestyle{{fancy}}

{}

\end{{document}}
{}
]], {
    i(1, "Tu Título"),
    i(2, "Felipe Colli Olea"),
    i(1), -- Reuses node 1
    i(2), -- Reuses node 2
    i(0, "Empieza a escribir aquí..."),
    f(create_symlink), -- Only one function, so it's fine here
  })),

  -- Snippet 2: The "Informe" snippet (corrected)
  s("Informe", fmt([[
\documentclass[12pt, letterpaper]{{article}}

% ----- PAQUETES BÁSICOS Y DE IDIOMA -----
\usepackage[utf8]{{inputenc}}
\usepackage[T1]{{fontenc}}
\usepackage[spanish]{{babel}}
\usepackage{{graphicx}}

% ----- PAQUETES DE FORMATO Y GEOMETRÍA -----
\usepackage{{geometry}}
\usepackage{{setspace}}
\usepackage{{enumitem}}
\usepackage{{microtype}}
\graphicspath{{ {{./images/}}, {{~/Apunte/images/}} }}

% ----- PAQUETE DE CITAS Y BIBLIOGRAFÍA -----
\usepackage{{csquotes}}
\usepackage[style=verbose-trad1, bibstyle=numeric, backend=biber]{{biblatex}}
\addbibresource{{bibliografia.bib}}

% ----- CONFIGURACIÓN DE LA PÁGINA -----
\geometry{{
    letterpaper,
    left=2.5cm,
    right=2.5cm,
    top=2.5cm,
    bottom=3cm
}}
\setstretch{{1.5}}

% ----- HIPERVÍNCULOS -----
\usepackage{{fancyhdr}}
\usepackage{{hyperref}}
\hypersetup{{
    colorlinks=true,
    linkcolor=black,
    urlcolor=blue,
    pdftitle={{{}}},
    pdfauthor={{Felipe Colli Olea, {}, {}, {}, {}}},
    pdfsubject={{{}}}
}}

% --- INICIO DEL DOCUMENTO ---
\begin{{document}}

% --- CONFIGURACIÓN DEL PIE DE PÁGINA ---
\pagestyle{{fancy}}
\fancyhf{{}}
\fancyfoot[C]{{\footnotesize {}}}
\fancyfoot[R]{{\thepage}}
\renewcommand{{\headrulewidth}}{{0pt}}

% --- PORTADA ---
\begin{{titlepage}}
	\centering
	\includegraphics[width=2cm]{{IN.png}}\\[1.5cm]
	\textsc{{\LARGE  Instituto Nacional General José Miguel Carrera}}\\[0.5cm]
	\textsc{{\Large Departamento de Filosofía}}\\[1cm]
	\rule{{\textwidth}}{{1.5pt}}\vspace{{0.4cm}}
	{{ \Huge \bfseries {} }}\\[0.4cm]
	\rule{{\textwidth}}{{1.5pt}}\\[1cm]
	{{ \Large \textit{{{}}} }}\\[2cm]
	\begin{{minipage}}{{0.45\textwidth}}
		\begin{{flushleft}} \large
			\textbf{{Autores:}}\\
			Felipe Colli Olea\\
			{}\\
			{}\\
			{}\\
			{}
		\end{{flushleft}}
	\end{{minipage}}
	\hfill
	\begin{{minipage}}{{0.45\textwidth}}
		\begin{{flushright}} \large
			\textbf{{Profesora:}}\\
			{}
		\end{{flushright}}
	\end{{minipage}}
	\vfill
	{{ \large Santiago, Chile \\[0.5cm] \today }}
\end{{titlepage}}

\newpage
\tableofcontents
\newpage
\section*{{Introducción}}
\thispagestyle{{fancy}}
{}

\newpage
\section*{{Desarrollo}}
\subsection*{{China: Un Pacto de Prosperidad a Cambio de Lealtad}}
\subsection*{{Vietnam: Renovación Económica bajo Control Político}}
\subsection*{{Kerala: Comunismo Democrático y Desarrollo Social}}
\subsection*{{Experiencias cercanas al comunismo en las regiones de China, Vietnam y Kerala}}

\newpage
\section*{{Conclusión}}

\newpage
\printbibliography[title=Bibliografía]

\end{{document}}
{}
]], {
    -- Nodes for metadata and title page
    i(1, "Título del Informe"),
    i(2, "Otro Autor 1"),
    i(3, "Otro Autor 2"),
    i(4, "Otro Autor 3"),
    i(5, "Otro Autor 4"),
    i(6, "Asignatura"),
    i(6),                          -- Re-use for footer
    i(1),                          -- Re-use for main title
    i(6),                          -- Re-use for subtitle
    i(2),                          -- Re-use author
    i(3),                          -- Re-use author
    i(4),                          -- Re-use author
    i(5),                          -- Re-use author
    i(7, "Nombre de la Profesora"),
    
    -- Final cursor position
    i(0, "% Empieza a escribir aquí..."),

    -- A SINGLE function node that runs all setup tasks
    f(setup_project_files),
  })),
}

################################################################################
ARCHIVO: nvim/.config/nvim/README.md
################################################################################

# 🐧 Configuración de Neovim para Programación Competitiva y Desarrollo General

![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Lazy.nvim](https://img.shields.io/badge/Plugin_Manager-Lazy.nvim-blue?style=for-the-badge)

Esta es mi configuración personal de Neovim, construida desde cero en Lua. Está diseñada para ser un IDE ligero y potente, con un enfoque especial en **C++ para Programación Competitiva**, desarrollo en **LaTeX** para la universidad y un entorno de scripting general para **Linux**.

## ✨ Filosofía
- **Modularidad:** Toda la configuración está dividida en archivos pequeños y cohesivos dentro de la carpeta `lua/`.
- **Carga Perezosa (Lazy Loading):** Se utiliza `lazy.nvim` para cargar plugins solo cuando son necesarios, garantizando un tiempo de inicio casi instantáneo.
- **Centrado en el Teclado:** Atajos de teclado (`keybinds`) optimizados para no tener que tocar el mouse.
- **"Baterías Incluidas":** Configuración completa para LSP, autocompletado, snippets, debugging y formato de código.

## 📂 Estructura de la Configuración

La configuración sigue una estructura moderna y fácil de mantener:

```
nvim/
├── init.lua          # Punto de entrada principal, carga Lazy.nvim y los módulos.
└── lua/
    ├── core/         # Configuraciones base de Neovim (opciones, atajos).
    │   ├── autostart.lua
    │   ├── current-theme.lua
    │   └── keybinds.lua
    ├── plugins/      # Cada archivo es una "spec" de Lazy para un plugin.
    └── snippets/     # Snippets personalizados para LuaSnip.
        ├── cpp.lua
        └── tex.lua
```

## 🌟 Características y Plugins Clave

| Característica         | Plugins Utilizados                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------- |
| **Gestor de Plugins**  | `folke/lazy.nvim`                                                                     |
| **Autocompletado**     | `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, `onsails/lspkind.nvim`                          |
| **Soporte LSP**        | `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `j-hui/fidget.nvim`                 |
| **Navegación**         | `nvim-telescope/telescope.nvim`, `nvim-neo-tree/neo-tree.nvim`                        |
| **Interfaz (UI)**      | `goolord/alpha-nvim`, `nvim-lualine/lualine.nvim`, `catppuccin/nvim`, `folke/tokyonight.nvim` |
| **Edición de Código**  | `nvim-treesitter/nvim-treesitter`, `windwp/nvim-autopairs`, `kylechui/nvim-surround`   |
| **Debugging**          | `mfussenegger/nvim-dap` y `rcarriga/nvim-dap-ui` (configurado para GDB en C++)          |
| **Formato**            | `mhartington/formatter.nvim` (con `clang-format`, `stylua`, `black`, `prettier`)      |
| **Git**                | `lewis6991/gitsigns.nvim`                                                             |
| **Lenguajes Específicos**| `lervag/vimtex` (LaTeX), `yuukiflow/Arduino-Nvim` (Arduino), `GCBallesteros/jupytext.nvim` (Jupyter) |
| **Utilidades de IA**   | `zbirenbaum/copilot.lua` y `CopilotChat.nvim`                                         |

## ⌨️ Atajos Esenciales

La tecla `<leader>` está mapeada a `Espacio`.

| Atajo               | Acción                                             |
| ------------------- | -------------------------------------------------- |
| `<C-n>`             | Abrir/Cerrar el explorador de archivos (`Neo-tree`)  |
| `<C-f>`             | Buscar texto en todo el proyecto (`Telescope`)       |
| `gd`                | Ir a la definición (LSP)                           |
| `gr`                | Buscar referencias (LSP)                            |
| `<leader>ca`        | Ver acciones de código disponibles (LSP)             |
| `<leader>gf`        | Formatear el buffer actual (`formatter.nvim`)        |
| `<leader>xx`        | Mostrar/Ocultar lista de errores (`trouble.nvim`)    |
| `<C-c>`             | Abrir chat con Copilot                             |

---
*Hecho para maximizar la velocidad y minimizar las distracciones.*
