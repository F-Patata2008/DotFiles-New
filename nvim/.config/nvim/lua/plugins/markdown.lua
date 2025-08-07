-- lua/plugins/markdown-autocompile.lua
return {
  -- This is not a plugin, but a way to organize our autocmd
  {
    "akinsho/toggleterm.nvim", -- A placeholder, this can be any name or even empty
    event = "BufWritePost *.md", -- Only load this file when a markdown file is saved
    config = function()
      -- This command runs after you save any file ending in .md
      local group = vim.api.nvim_create_augroup("MarkdownAutoCompile", { clear = true })
            -- ~/.config/nvim/after/ftplugin/markdown.lua

-- Create a user command called :MarkdownCompile
vim.api.nvim_create_user_command(
  'MarkdownCompile',
  function()
    -- Get the current file name
    local file = vim.fn.expand('%:p') -- ':p' gets the full path
    local pdf_file = vim.fn.fnamemodify(file, ':r') .. '.pdf' -- Replaces extension with .pdf

    local cmd = string.format("pandoc %s -o %s && zathura %s &",
      vim.fn.shellescape(file),
      vim.fn.shellescape(pdf_file),
      vim.fn.shellescape(pdf_file)
    )

    -- Use vim.fn.jobstart to run the command in the background
    vim.fn.jobstart(cmd)
    print("Starting initial compilation and Zathura...")
  end,
  { desc = "Compile Markdown with Pandoc and open in Zathura" }
)
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.md",
        group = group,
        callback = function(args)
          -- We get the filename from the autocmd arguments
          local file = args.file
          local pdf_file = file .. ".pdf"
          local cmd = string.format("pandoc %s -o %s", vim.fn.shellescape(file), vim.fn.shellescape(pdf_file))

          -- Run pandoc asynchronously
          vim.fn.jobstart(cmd, {
            on_exit = function()
              print("Pandoc finished compiling " .. pdf_file)
              -- Zathura will auto-refresh if it's already open
            end,
          })
        end,
      })
      print("Markdown auto-compilation enabled.")
    end
  }
}
