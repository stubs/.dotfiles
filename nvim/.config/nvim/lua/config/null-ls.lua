require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.shellcheck,
        require("null-ls").builtins.diagnostics.hadolint,
        require("null-ls").builtins.diagnostics.selene,
        require("null-ls").builtins.diagnostics.checkmake,
        -- require("null-ls").builtins.diagnostics.sqlfluff.with({
        --     extra_args = { "--config", "PATH_TO_CONFIG" }
        -- }),
        -- require("null-ls").builtins.diagnostics.flake8
    }
})
