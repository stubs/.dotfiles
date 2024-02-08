-- autocmd to source when this file is written to.
vim.cmd([[
    autocmd BufWritePost settings.lua source <afile> | source $MYVIMRC
]])

-- Settings
vim.g.colors_name = 'kanagawa'
vim.o.ai = true                         -- always vim.o.autoindenting on
vim.o.background = 'dark'
vim.o.backup = false
vim.o.compatible = false	    	-- Use Vim defaults (much better!)
vim.o.expandtab = true                  -- use the appropriate number of spaces to insert a <Tab>
vim.o.foldenable = false        	-- dont fold by default
vim.o.foldmethod = 'indent'              -- fold based on indent
vim.o.foldnestmax = 3                  -- deepest fold is 3 levels
vim.o.grepprg= 'rg --vimgrep --no-heading --smart-case'
-- vim.o.guifont='FiraCode_Nerd_Font_Mono'
vim.o.hidden = true
vim.o.history = 50                      -- keep 50 lines of command line history
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.opt.laststatus = 3
vim.o.listchars='tab:▷▷⋮,trail:-,space:.'
vim.o.mouse = 'a'
vim.o.nu = true
vim.o.rnu = true
vim.o.cursorline = true
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.softtabstop = 4
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime=300
vim.o.wrap = false
vim.o.writebackup = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.wildignore:append {"*/tmp/*","*.swp"}  -- Linux/MacOSX

-- LSP diagnostic config
vim.diagnostic.config({
  virtual_text = false,
  float = { source = true }
})

local function lspSymbol(name, icon)
vim.fn.sign_define(
	'DiagnosticSign' .. name,
	{ text = icon, texthl = 'DiagnosticSign' .. name }
)
end
lspSymbol('Error', '')
lspSymbol('Information', '')
lspSymbol('Hint', '')
lspSymbol('Info', '')
lspSymbol('Warn', '')

-- nicer win sep
vim.cmd([[hi WinSeparator guibg=None]])

-- For working with Jenkinsfiles
vim.cmd([[
    autocmd BufNewFile,BufRead Jenkinsfile set syntax=groovy
]])
