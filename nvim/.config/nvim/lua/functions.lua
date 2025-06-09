vim.cmd([[
    autocmd BufWritePost functions.lua source <afile> | source $MYVIMRC
]])

local autocmd_group = vim.api.nvim_create_augroup(
    "Custom auto-commands",
    {clear = true})
vim.api.nvim_create_autocmd({"BufWritePost"},
    {
        pattern = {"*.py"},
        desc = "Auto ufmt Python files prior to saving",
        callback = function()
            local file_name = vim.api.nvim_buf_get_name(0) -- Get file name of file in current buffer
            -- TODO: ufmt all py files if .venv/ in repo root has it or ~/.virtualenvs/
            vim.cmd(':silent !"$(git rev-parse --show-toplevel)"/.venv/bin/ufmt format ' .. file_name)
            vim.cmd(':silent !~/.virtualenvs/"$(basename $(git rev-parse --show-toplevel))"/bin/ufmt format ' .. file_name)
            -- vim.cmd(":silent !~/.virtualenvs/conductor-dev/bin/ufmt -q format " .. file_name)
        end,
        group = autocmd_group,
    })

-- TODO update this to run automatically on all occasions.
vim.cmd([[
    augroup NvimStartupAutocmd
    autocmd!
    autocmd VimEnter * lua require('venv-selector').retrieve_from_cache()
    " autocmd VimEnter * lua require("twilight").toggle()
    augroup END
]])

local M = {}
M.python_run = function()
    vim.cmd [[
        :exec '!clear; python ' shellescape(@%, 1)
    ]]
end

local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local builtin    = require('telescope.builtin')
local delta = previewers.new_termopen_previewer {
    get_command = function(entry)
        -- this is for status
        -- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
        -- just do an if and return a different command
        if entry.status == '??' or 'A ' then
            return {'git', 'diff', entry.path}
        end

        -- note we can't use pipes
        -- this command is for git_commits and git_bcommits
        return {'git', 'diff', entry.path .. '^!'}

    end
}
M.delta_git_status = function(opts)
    opts = opts or {}
    opts.previewer = delta
    -- opts.layout_strategy = 'vertical'
    builtin.git_status(opts)
end

return M
