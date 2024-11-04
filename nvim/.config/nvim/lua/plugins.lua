local fn = vim.fn

local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

-- autocmd to sync deps when this file is written to.
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | source $MYVIMRC | PackerSync
augroup end
]])

return require("packer").startup(function(use)
    use {"L3MON4D3/LuaSnip"}
    use {"Raimondi/delimitMate"}
    use {"alvarosevilla95/luatab.nvim", requires = "nvim-tree/nvim-web-devicons"}
    use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}
    use {"folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons"}
    use {"folke/twilight.nvim"}
    use {"github/copilot.vim", disable = true}
    use {"hrsh7th/nvim-cmp", requires = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/cmp-nvim-lsp", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets"}}
    use {"jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim"}
    use {"lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim"}
    use {"linux-cultist/venv-selector.nvim", branch = "regexp", requires = {"neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python"}}
    use {"mfussenegger/nvim-dap"}
    use {"mfussenegger/nvim-dap-python", requires = "mfussenegger/nvim-dap"}
    use {"morhetz/gruvbox"}
    use {"neovim/nvim-lspconfig"}
    use {"numToStr/Comment.nvim"}
    use {"nvim-lua/plenary.nvim"}
    use {"nvim-lualine/lualine.nvim", requires = "nvim-tree/nvim-web-devicons"}
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
    use {"nvim-telescope/telescope.nvim", tag = "0.1.5", requires = "nvim-lua/plenary.nvim"}
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    use {"rcarriga/nvim-dap-ui", requires = "mfussenegger/nvim-dap", disable = true}
    use {"rebelot/kanagawa.nvim"}
    use {"rmagatti/goto-preview"}
    use {"simrat39/rust-tools.nvim", disable = true}
    use {"sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim", disable = true}
    use {"someone-stole-my-name/yaml-companion.nvim", requires = {"neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"}}
    use {"sourcegraph/sg.nvim", run = "nvim -l build/init.lua"}
    use {"stevearc/aerial.nvim"}
    use {"stevearc/oil.nvim"}
    use {"tpope/vim-fugitive"}
    use {"tpope/vim-surround"}
    use {"wbthomason/packer.nvim"}  -- have packer manage itself
    use {"williamboman/mason-lspconfig.nvim"}
    use {"williamboman/mason.nvim"}
    use {"echasnovski/mini.indentscope"}
    use {"folke/noice.nvim", requires = {"rcarriga/nvim-notify", "MunifTanjim/nui.nvim"}}
    use {"ggandor/leap.nvim"}
    use {"alexghergh/nvim-tmux-navigation"}
    use {"nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter", requires = "nvim-treesitter/nvim-treesitter"}
    use {"nvim-focus/focus.nvim"}
    use {"vim-pandoc/vim-pandoc"}
    use {"vim-pandoc/vim-pandoc-syntax"}
    -- use {"ThePrimeagen/git-worktree.nvim"}
    use {"polarmutex/git-worktree.nvim", tag = "2.0.0"}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
