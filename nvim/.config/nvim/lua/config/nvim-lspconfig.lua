vim.lsp.config('bashls', {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' }
})
vim.lsp.enable('bashls')

vim.lsp.config('dockerls', {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' }
})
vim.lsp.enable('dockerls')

vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' }
})
vim.lsp.enable('lua_ls')

vim.lsp.config('marksman', {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' }
})
vim.lsp.enable('marksman')

vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' }
})
vim.lsp.enable('pyright')

vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' }
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('terraformls', {
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars' }
})
vim.lsp.enable('terraformls')
