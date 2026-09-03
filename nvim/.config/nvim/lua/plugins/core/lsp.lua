-- plugins/core/lsp.lua
-- Termux-safe LSP setup:
-- - On PC: use Mason + mason-lspconfig ensure_installed
-- - On Termux: DO NOT let Mason manage/install servers; use system binaries from pkg/npm

return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP installer/manager
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- nvim-cmp LSP source (capabilities)
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local is_termux = os.getenv("TERMUX_VERSION") ~= nil

      -- When an LSP attaches to a buffer
      local on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end

        -- Keybindings for LSP features.
        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("gK", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- Formatting (only if server supports it)
        if client.supports_method("textDocument/formatting") then
          nmap("<leader>gf", vim.lsp.buf.format, "[G]o [F]ormat Buffer")
          vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            vim.lsp.buf.format()
          end, { desc = "Format current buffer with LSP" })
        end
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- Helper: check if an executable exists (so Termux won’t “scream”)
      local function has(bin)
        return vim.fn.executable(bin) == 1
      end

      -- Helper: auto-detect Python virtualenv
      local function get_python_path(workspace)
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
          return venv .. "/bin/python"
        end
        if workspace then
          for _, name in ipairs({ ".venv", "venv", "env", ".env" }) do
            local match = workspace .. "/" .. name .. "/bin/python"
            if vim.fn.executable(match) == 1 then
              return match
            end
          end
        end
        return vim.fn.exepath("python3") or "python"
      end

      local pyright_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = get_python_path(config.root_dir or vim.fn.getcwd())
        end,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "basic",
            },
          },
        },
      }

      -- =========================
      -- PC / Normal (Mason-managed)
      -- =========================
      if not is_termux then
        require("mason-lspconfig").setup({
          ensure_installed = {
            "lua_ls",
            "clangd",
            "pyright",
            "texlab",
            "hyprls",
            "marksman",
            "arduino_language_server",
          },
          handlers = {
            function(server_name)
              lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
              })
            end,
            ["pyright"] = function()
              lspconfig.pyright.setup(pyright_opts)
            end,
            ["arduino_language_server"] = function()
              -- Intentionally left empty
            end,
          },
        })
        return
      end

      -- =========================
      -- TERMUX (System binaries only)
      -- =========================
      -- IMPORTANT:
      -- We DO NOT call mason-lspconfig.setup() here.
      -- Mason binaries are often incompatible on Android.

      -- C/C++
      if has("clangd") then
        lspconfig.clangd.setup({
          cmd = { "clangd", "--background-index", "--clang-tidy" },
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- Python (installed via: npm i -g pyright)
      if has("pyright-langserver") then
        local termux_pyright = vim.tbl_deep_extend("force", pyright_opts, {
          cmd = { "pyright-langserver", "--stdio" },
        })
        lspconfig.pyright.setup(termux_pyright)
      end

      -- LaTeX (installed via: pkg install texlab)
      if has("texlab") then
        lspconfig.texlab.setup({
          cmd = { "texlab" },
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            texlab = {
              -- You said you don’t want latexmk/TeXLive on Termux:
              build = { onSave = false },
              -- Optional: reduce extra checks/noise
              chktex = { onOpenAndSave = false, onEdit = false },
              diagnosticsDelay = 300,
            },
          },
        })
      end

      -- Lua (installed via: pkg install lua-language-server)
      if has("lua-language-server") then
        lspconfig.lua_ls.setup({
          cmd = { "lua-language-server" },
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = { enable = false },
            },
          },
        })
      end

      -- hyprls:
      -- Don’t start on Termux; even with Termux X11 you likely don’t have Hyprland configs here.
      -- If you *really* want it on Termux later, install the server and add it like the others.
    end,
  },
}
