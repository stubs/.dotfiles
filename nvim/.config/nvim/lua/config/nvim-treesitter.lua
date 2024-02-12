require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'bash',
        'lua',
        'python',
        "markdown",
        "markdown_inline",
        "regex",
    },
    highlight = {
        enable = true
    }
})
