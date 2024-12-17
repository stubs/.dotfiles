require("noice").setup({
    cmdline = {
    view = "cmdline",
    },
    messages = {
        enabled = false
    },
    lsp = {
        progress = {
            enabled = false
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        long_message_to_split = false, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    redirect = {
        view = "mini",
        filter = {
            event = "msg_show",
            min_height = 20
        },
    },
    routes = {
        {
            filter = {
                event = "msg_show",
                kind = "",
                find = "written",
            },
            opts = { skip = true },
        },
        {
            filter = {
                event = "msg_show",
                find = "line"
            },
            opts = { skip = true },
        },
    },
    views = {
        cmdline_popup = {
            position = {
                row = 5,
                col = "50%",
            },
            size = {
                width = 60,
                height = "auto",
            },
        },
        popupmenu = {
            relative = "editor",
            zindex = 65,
            position = "auto", -- when auto, then it will be positioned to the cmdline or cursor
            size = {
                width = "auto",
                height = "auto",
                max_height = 20,
                min_width = 20,
            },
            win_options = {
                winbar = "",
                foldenable = false,
                cursorline = true,
                cursorlineopt = "line",
                winhighlight = {
                    Normal = "NormalFloat", -- change to NormalFloat to make it look like other floats
                    FloatBorder = "DiagnosticInfo", -- border highlight
                    CursorLine = "NoicePopupmenuSelected", -- used for highlighting the selected item
                    PmenuMatch = "NoicePopupmenuMatch", -- used to highlight the part of the item that matches the input
                },
            },
            border = {
                padding = { 0, 1 },
            },
        },

        -- popupmenu = {
        --     win_options = {
        --         winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        --     },
        -- },
    },
})
