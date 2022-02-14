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

M.python_run = function()
    vim.cmd [[
        :exec '!clear; python ' shellescape(@%, 1)
    ]]
end



return M
