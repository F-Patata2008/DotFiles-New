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
