local telescope_custom_actions = {}
local action_state = require("telescope.actions.state")
local actions = require('telescope.actions')

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    -- local selected_entry = action_state.get_selected_entry()
    local num_selections = #picker:get_multi_selection()
    if not num_selections or num_selections <= 1 then
        actions.add_selection(prompt_bufnr)
    end
    actions.send_selected_to_qflist(prompt_bufnr)
    vim.cmd("cfdo " .. open_cmd)
end
function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "split")
end
function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "tabe")
end
function telescope_custom_actions.multi_selection_open(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

require('telescope').setup{
    defaults = {
        -- path_display = {'smart'},
        layout_strategy="vertical",
        mappings = {
            i = {
                ["<TAB>"] = actions.toggle_selection,
                ["<CR>"] = telescope_custom_actions.multi_selection_open,
                ["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
                ["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
                ["<C-t>"] = telescope_custom_actions.multi_selection_open_tab,
            },
            n = i,
        },
    },
    pickers = {
        git_files = {
            prompt_title=" GIT FILES ",
        },
        buffers = {
            sort_mru = true
        },
        find_files = {
            find_command = {'rg', '--files', '--hidden', '-g', '!.git'}
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = 'smart_case'         -- or 'ignore_case' or 'respect_case' the default case_mode is 'smart_case'
        }
    }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('aerial')
-- require("telescope").load_extension("yaml_schema")
