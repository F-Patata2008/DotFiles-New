local function find_sketch_dir(filepath)
  if not filepath or filepath == "" then
    return nil
  end

  local full_path = vim.fs.normalize(vim.fn.fnamemodify(filepath, ":p"))
  local dir = vim.fs.dirname(full_path)

  -- 1. Check if the file's direct directory contains an Arduino sketch
  if #vim.fn.globpath(dir, "*.ino", false, true) > 0
    or vim.fn.filereadable(dir .. "/sketch.yaml") == 1
    or vim.fn.filereadable(dir .. "/.arduino_config.lua") == 1
  then
    return dir
  end

  -- 2. Traverse upwards to find the sketch root directory
  local root_marker = vim.fs.find(function(name, _)
    return name:match("%.ino$") or name == "sketch.yaml" or name == ".arduino_config.lua"
  end, { upward = true, path = dir, stop = vim.env.HOME })

  if root_marker and #root_marker > 0 then
    return vim.fs.dirname(root_marker[1])
  end

  return dir
end

local function setup_arduino_sketch(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    return
  end

  local sketch_dir = find_sketch_dir(filepath)
  if not sketch_dir or sketch_dir == "" then
    return
  end

  -- 1. Automatically change window-local working directory (lcd) to the sketch root
  vim.cmd("silent! lcd " .. vim.fn.fnameescape(sketch_dir))

  -- 2. Load / reload Arduino-Nvim config from the sketch directory
  local ok_arduino, arduino = pcall(require, "Arduino-Nvim")
  if ok_arduino and arduino and type(arduino.load_or_create_config) == "function" then
    arduino.load_or_create_config()
  end

  -- 3. Set up the Arduino LSP with the sketch directory as the active root
  local ok_lsp, arduino_lsp = pcall(require, "Arduino-Nvim.lsp")
  if ok_lsp and arduino_lsp and type(arduino_lsp.setup) == "function" then
    arduino_lsp.setup()
  end
end

return {
  {
    "yuukiflow/Arduino-Nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local group = vim.api.nvim_create_augroup("ArduinoSketchAutoSetup", { clear = true })

      -- Hook into FileType arduino
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "arduino",
        callback = function(args)
          setup_arduino_sketch(args.buf)
        end,
      })

      -- Hook into BufEnter for .ino files (ensures window-local lcd when switching buffers/windows)
      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "*.ino",
        callback = function(args)
          setup_arduino_sketch(args.buf)
        end,
      })

      -- If an Arduino file is already open upon plugin loading, execute immediately
      if vim.bo.filetype == "arduino" or vim.fn.expand("%:e") == "ino" then
        setup_arduino_sketch(vim.api.nvim_get_current_buf())
      end
    end,
  },
}
