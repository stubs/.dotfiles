require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "dockerls",
        "lua_ls",
        "pyright",
        "yamlls",
    },
})
