vim.cmd([[
    autocmd BufWritePost functions.lua source <afile> | source $MYVIMRC
]])

local M = {}
M.nvim_config_find = function()
    require('telescope.builtin').find_files({
        prompt_title = '~ NeoVim Configs ~',
        cwd = '/Users/agonzalez/.config/nvim/'
    })
end

M.workon_curator = function()
    vim.cmd [[:tabnew | tcd /opt/dotdash/dataops/curator/]]
    require('telescope.builtin').git_files({ prompt_title = '~ Curator ~', cwd = '/opt/dotdash/dataops/curator/' })
end

M.workon_aqueduct = function()
    vim.cmd [[:tabnew | tcd /opt/dotdash/dataops/aqueduct/]]
    require('telescope.builtin').git_files({ prompt_title = '~ Aqueduct ~', cwd = '/opt/dotdash/dataops/aqueduct/' })
end

M.workon_dotfiles = function()
    vim.cmd [[:tabnew | tcd /opt/dotdash/dataops/dotfiles/]]
    require('telescope.builtin').git_files({ prompt_title = '~ work dotfiles ~', cwd = '/opt/dotdash/dataops/dotfiles/' })
end

M.workon_nebula = function()
    vim.cmd [[:tabnew | tcd /opt/dotdash/dataops/nebula/]]
    require('telescope.builtin').git_files({ prompt_title = '~ Nebula ~', cwd = '/opt/dotdash/dataops/nebula/' })
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
