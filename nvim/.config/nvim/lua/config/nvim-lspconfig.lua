
-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local buf_keymap = vim.api.nvim_buf_set_keymap
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_keymap(bufnr, 'n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_keymap(bufnr, 'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

end
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').bashls.setup{
    capabilities = capabilities,
    on_attach=on_attach
}

require('lspconfig').dockerls.setup{
    capabilities = capabilities,
    on_attach=on_attach
}

-- for lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
require'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
    on_attach=on_attach,
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

require('lspconfig').pyright.setup{
    capabilities = capabilities,
    on_attach=on_attach
}


local cfg = require("yaml-companion").setup({
  -- Built in file matchers
  builtin_matchers = {
    -- Detects Kubernetes files based on content
    kubernetes = { enabled = true },
    cloud_init = { enabled = true }
  },

  -- Additional schemas available in Telescope picker
  schemas = {
    {
        name = "dbt yml files",
        uri = "https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/dbt_yml_files.json",
    },
  },

  -- Pass any additional options that will be merged in the final LSP config
  lspconfig = {
    capabilities = capabilities,
    on_attach=on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        validate = true,
        format = { enable = true },
        hover = true,
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemaDownload = { enable = true },
        schemas = {},
        trace = { server = "debug" },
      },
    },
  },
})
require("lspconfig").yamlls.setup(cfg)
