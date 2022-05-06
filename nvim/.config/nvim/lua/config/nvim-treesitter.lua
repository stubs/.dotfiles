require('nvim-treesitter.configs').setup{
    ensure_installed = {'python', 'bash', 'lua', 'typescript', 'rust' },
    highlight = {
        enable = true
    }
}
