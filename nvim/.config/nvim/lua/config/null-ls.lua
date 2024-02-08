require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.shellcheck,
        require("null-ls").builtins.diagnostics.hadolint,
        require("null_ls").builtins.diagnostics.selene
        -- require("null-ls").builtins.diagnostics.flake8
    }
})
