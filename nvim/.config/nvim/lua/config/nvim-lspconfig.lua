local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- npm i -g pyright
require('lspconfig').pyright.setup{
    capabilities = capabilities
}

-- npm i -g bash-language-server
require('lspconfig').bashls.setup{
    capabilities = capabilities
}

-- for lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
-- SKIP: BREW INSTALLED
require'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
-- npm i -g typescript typescript-language-server
require'lspconfig'.tsserver.setup{}

-- SKIP: BREW INSTALLED
require'lspconfig'.rust_analyzer.setup{}
