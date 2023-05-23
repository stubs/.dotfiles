local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- autocmd to sync deps when this file is written to.
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | source $MYVIMRC | PackerSync
augroup end
]])

return require('packer').startup(function(use)
    -- My plugins here
  use {'Raimondi/delimitMate'}
  use {'morhetz/gruvbox'}
  use {'stevearc/aerial.nvim'}    -- setup in key_maps with on_attach
  use {'tpope/vim-fugitive'}
  use {'tpope/vim-surround'}
  use {'wbthomason/packer.nvim'}  -- have packer manage itself
  use {'nvim-lua/plenary.nvim'}
  use {'nvim-tree/nvim-web-devicons'}
  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config= function()
        require('config/diffview')
    end,
    disable=true
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
        require("config/gitsigns")
    end,
    after = 'nvim-dap',
    disable=false
  }
  use {
     'mfussenegger/nvim-dap' ,
     config = function()
         require("config/nvim-dap")
     end,
    disable=false
  }
  use {
    'rcarriga/nvim-dap-ui',
    requires  = { 'mfussenegger/nvim-dap' },
    config = function()
        require("config/nvim-dap-ui")
    end,
    disable=false
  }
  use {
    'mfussenegger/nvim-dap-python',
    requires  = { 'mfussenegger/nvim-dap' },
     config = function()
        require('config/nvim-dap-python')
      end,
    disable=false
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use {
    'rmagatti/goto-preview',
    config = function()
        require('config/goto-preview')
    end,
    disable=false
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end,
    disable=false
  }
  use {
    'L3MON4D3/LuaSnip',
    -- after = 'nvim-cmp',
    config = function ()
        require('config/luasnip')
    end,
    disable=false
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
    config = function()
        require('config/nvim-cmp')
    end,
    disable=false
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
        require("config/nvim-treesitter")
    end,
    run = ':TSUpdate',
    disable=false
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
        require("config/lualine")
    end
  }
  use {
    'folke/trouble.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("config/trouble")
    end,
    disable=false
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
        require("config/telescope")
    end,
    disable=false
  }
  use {
    'neovim/nvim-lspconfig', -- Collection of configurations for the built-in LSP client
    run = function()
        require("config/nvim-lspconfig")
    end,
    disable=false
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
        require("config/null-ls")
    end,
    disable=false
  }
  use {
    'alvarosevilla95/luatab.nvim',
    requires='nvim-tree/nvim-web-devicons',
    config = function()
        require("config/luatab")
    end
  }
  use {
    'rebelot/kanagawa.nvim'
  }
  use {
    'simrat39/rust-tools.nvim',
    disable=false
  }
  use {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
        require("lsp_lines").setup()
    end,
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
        require("nvim-tree").setup()
    end,
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
