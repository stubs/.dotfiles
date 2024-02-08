-- autocmd to source when this file is written to.
vim.cmd([[
    autocmd BufWritePost key_maps.lua source <afile> | source $MYVIMRC
    autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

local opts = { noremap=true, silent=true }
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = ' '                                                                                   -- Rebind leader key
keymap('', '<C-h>', '<C-w>h', opts)                                                                     -- bind Ctrl+<movement> keys to move around the windows/splits
keymap('', '<C-j>', '<C-w>j', opts)
keymap('', '<C-k>', '<C-w>k', opts)
keymap('', '<C-l>', '<C-w>l', opts)
keymap('n', '<Left>', ':-tabnext<CR>', opts)
keymap('n', '<Right>', ':+tabnext<CR>', opts)
keymap('i', '<C-s>', '<esc>:update<CR>', opts)
keymap('', '<Leader>x', ':%s/\\s\\+$//', opts)                                                          -- Alternate File
keymap('n', '<C-s>', ':update<CR>', opts)                                                               -- Quick save
keymap('n', '<Leader>`', '<C-^>', opts)                                                                 -- Alternate File
-- keymap('n', '<Leader>d', 'oimport ipdb; ipdb.set_trace()  # <<<<<<<<<< BREAKPOINT<esc>', opts)       -- Ipdb breakpoint
keymap('n', '<Leader>n', ':nohl<CR>', opts)                                                             -- 86 highlight
keymap('n', '<bar>', '<C-w><bar>', opts)                                                                -- max vertical split
keymap('n', '=', '<C-w>=', opts)                                                                        -- equalize split areas
keymap('n', '_', '<C-w>_', opts)                                                                        -- max horizontal split
keymap('n', '<S-Tab>', '<C-o>', opts)                                                                   -- Previous Jump
keymap('v', '<', '<gv', opts)                                                                           -- indent viz blocks of code
keymap('v', '>', '>gv', opts)
keymap('v', '<C-s>', '<esc>:update<CR>', opts)
keymap('v', '<Leader>S', ':sort!<CR>', opts)
keymap('v', '<Leader>s', ':sort<CR>', opts)                                                             -- Quick sort

-- function keybindings
-- keymap('n', '<Leader>D', ':lua require("functions").delta_git_status()<CR>', opts)
-- keymap('n', '<F1>', ':lua require "functions".python_run() <CR>', opts)  -- DEPRECATE in favor of nvim-dap continue()

-- telescope key bindings
keymap('n', '<Leader>af', ':lua require "telescope.builtin".find_files() <CR>', opts)
keymap('n', '<Leader>p', ':lua require "telescope.builtin".git_files() <CR>', opts)
keymap('n', '<Leader>b', ':lua require "telescope.builtin".buffers() <CR>', opts)
keymap('n', '<Leader>f', ':lua require "telescope.builtin".live_grep() <CR>', opts)
keymap('n', '<Leader>gc', ':lua require "telescope.builtin".git_commits() <CR>', opts)
keymap('n', '<Leader>gb', ':lua require "telescope.builtin".git_bcommits() <CR>', opts)
keymap('n', '<Leader>aa', ':lua require "telescope".extensions.aerial.aerial() <CR>', opts)

-- trouble key bindings
keymap("n", "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
keymap("n", "gr", "<cmd>Trouble lsp_references<cr>", opts)
keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
keymap("n", "<leader>xt", "<cmd>TodoTrouble<cr>", opts)
-- keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)

-- goto preview
keymap('n', 'gd', ':lua require("goto-preview").goto_preview_definition()<CR>', opts)
keymap('n', 'gD', ':lua require("goto-preview").close_all_win()<CR>', opts)

-- lsp key bindings
keymap('n', '<Leader>[', '<cmd>lua vim.diagnostic.goto_prev({ float = true })<CR>', opts)
keymap('n', '<Leader>]', '<cmd>lua vim.diagnostic.goto_next({ float = true })<CR>', opts)
--keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
--keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
--keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

-- luasnip
keymap("i", "<c-n>", "<cmd>lua require'luasnip'.change_choice(1)<CR>", opts)
keymap("s", "<c-n>", "<cmd>lua require'luasnip'.change_choice(1)<CR>", opts)
keymap("i", "<c-p>", "<cmd>lua require'luasnip'.change_choice(-1)<CR>", opts)
keymap("s", "<c-p>", "<cmd>lua require'luasnip'.change_choice(-1)<CR>", opts)

-- dap
keymap('n', '<F1>', ':lua require("dap").continue()<CR>', opts)
keymap('n', '<F2>', ':lua require("dap").toggle_breakpoint()<CR>', opts)
keymap('n', '<F3>', ':lua require("dap").run_last()<CR>', opts)

-- gitsigns
keymap('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', opts)
keymap('n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
keymap('n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
keymap('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', opts)
keymap('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', opts)

-- diffview
-- keymap('n', '<leader>D', ':DiffviewOpen<CR>', opts)
