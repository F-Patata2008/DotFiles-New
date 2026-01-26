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
