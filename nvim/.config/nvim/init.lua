-- show trailing whitespaces
vim.cmd[[
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
]]

require('plugins')
require('settings')
require('key_maps')
require('functions')
