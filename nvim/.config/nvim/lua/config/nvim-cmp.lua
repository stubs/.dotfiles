local cmp = require('cmp')
local luasnip = require('luasnip')
local check_backspace = function()
local col = vim.fn.col "." - 1
return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end
local kind_icons = {
Text = "",
Method = "m",
Function = "",
Constructor = "",
Field = "",
Variable = "",
Class = "",
Interface = "",
Module = "",
Property = "",
Unit = "",
Value = "",
Enum = "",
Keyword = "",
Snippet = "",
Color = "",
File = "",
Reference = "",
Folder = "",
EnumMember = "",
Constant = "",
Struct = "",
Event = "",
Operator = "",
TypeParameter = "",
}

cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- ['C-j'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
        -- ['C-k'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
        -- ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        -- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- local luasnip = require('luasnip')
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            -- local luasnip = require('luasnip')
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
        "i",
        "s",
        }),
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
        })[entry.source.name]
        return vim_item
        end,
    },
    sources = cmp.config.sources{
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'path' },
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    window = {
        documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        }
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    }
}
