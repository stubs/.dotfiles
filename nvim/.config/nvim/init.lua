-- show trailing whitespaces
vim.cmd[[
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
]]

require("plugins")

-- plugin configs
require("config/aerial")
require("config/comment")
-- require("config/diffview")
require("config/gitsigns")
require("config/goto-preview")
require("config/leap")
require("config/lualine")
require("config/luasnip")
require("config/luatab")
require("config/mason") -- mason before nvim-lspconfig required
require("config/mini-indentscope")
require("config/noice")
require("config/null-ls")
require("config/nvim-cmp")
require("config/nvim-dap")
require("config/nvim-dap-python")
require("config/nvim-dap-ui")
require("config/nvim-lspconfig")
require("config/nvim-tmux-navigation")
require("config/nvim-treesitter")
require("config/oil")
require("config/sg")
require("config/telescope")
require("config/todo-comments")
require("config/trouble")
require("config/venv-selector")
-- require("config/yaml-companion")

require("settings")
require("key_maps")
require("functions")
