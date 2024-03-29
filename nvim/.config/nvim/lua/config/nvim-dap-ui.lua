local dap, dapui = require("dap"), require("dapui")

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  layouts = {
    {
        -- You can change the order of elements in the sidebar
        elements = {
        -- Provide as ID strings or tables with "id" and "size" keys
        { id = "scopes", size = 0.60}, -- Can be float or integer > 1
        { id = "watches", size = 0.40 }
        -- { id = "stacks", size = 0.30 }
        -- { id = "breakpoints", size = 0.40 }
        },
        size = 60,
        position = "left", -- Can be "left", "right", "top", "bottom"
    },
    {
        elements = { "repl" },
        size = 20,
        position = "bottom", -- Can be "left", "right", "top", "bottom"
    }
},
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.after.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.after.event_exited["dapui_config"] = function()
  dapui.close()
end
