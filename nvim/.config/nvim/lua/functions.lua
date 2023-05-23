vim.cmd([[
    autocmd BufWritePost functions.lua source <afile> | source $MYVIMRC
]])

local M = {}
M.nvim_config_find = function()
    require('telescope.builtin').find_files({
        prompt_title = '~ NeoVim Configs ~',
        cwd = '~/.config/nvim/'
    })
end

M.workon_ethelhawk = function()
    vim.cmd [[:tabnew | tcd ~/dev/density/ethelhawk/]]
    require('telescope.builtin').git_files({ prompt_title = '~ ethelhawk ~', cwd = '~/dev/density/ethelhawk/' })
end

M.workon_datahawk = function()
    vim.cmd [[:tabnew | tcd ~/dev/density/datahawk/]]
    require('telescope.builtin').git_files({ prompt_title = '~ datahawk ~', cwd = '~/dev/density/datahawk/' })
end

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
