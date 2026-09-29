 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#131315',
    base01 = '#201f21',
    base02 = '#2a2a2c',
    base03 = '#929097',
    base04 = '#c8c5ce',
    base05 = '#e5e1e4',
    base06 = '#e5e1e4',
    base07 = '#e5e1e4',
    base08 = '#ffb4ab',
    base09 = '#e3bbd2',
    base0A = '#c7c5d3',
    base0B = '#c5c3e4',
    base0C = '#e3bbd2',
    base0D = '#c5c3e4',
    base0E = '#c7c5d3',
    base0F = '#e4e1ef',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#e5e1e4',          bg = '#131315' })
  hi('TelescopeBorder',         { fg = '#929097',             bg = '#131315' })
  hi('TelescopePromptNormal',   { fg = '#e5e1e4',          bg = '#131315' })
  hi('TelescopePromptBorder',   { fg = '#929097',             bg = '#131315' })
  hi('TelescopePromptPrefix',   { fg = '#c5c3e4',             bg = '#131315' })
  hi('TelescopePromptCounter',  { fg = '#c8c5ce',  bg = '#131315' })
  hi('TelescopePromptTitle',    { fg = '#131315',             bg = '#c5c3e4' })
  hi('TelescopePreviewTitle',   { fg = '#131315',             bg = '#c7c5d3' })
  hi('TelescopeResultsTitle',   { fg = '#131315',             bg = '#e3bbd2' })
  hi('TelescopeSelection',      { fg = '#e5e1e4',          bg = '#2a2a2c' })
  hi('TelescopeSelectionCaret', { fg = '#c5c3e4',             bg = '#2a2a2c' })
  hi('TelescopeMatching',       { fg = '#c5c3e4',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#e5e1e4',          bg = '#131315' })
  hi('MiniPickBorder',         { fg = '#929097',             bg = '#131315' })
  hi('MiniPickPrompt',   { fg = '#e5e1e4',          bg = '#131315' })
  hi('MiniPickPromptPrefix',   { fg = '#c5c3e4',             bg = '#131315' })
  hi('MiniPickBorderText',    { fg = '#131315',             bg = '#c5c3e4' })
  hi('MiniPickMatchCurrent',      { fg = '#e5e1e4',          bg = '#2a2a2c' })
  hi('MiniPickPromptCaret', { fg = '#c5c3e4',             bg = '#2a2a2c' })
  hi('MiniPickMatchRanges',       { fg = '#c5c3e4',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
