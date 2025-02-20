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
    use {
        "L3MON4D3/LuaSnip",
        commit = " 33b06d72d220aa56a7ce80a0dd6f06c70cd82b9d",
        lock = true
    }
    use {
        "Raimondi/delimitMate",
        commit = " becbd2d353a2366171852387288ebb4b33a02487",
        lock = true
    }
    use {
        "alvarosevilla95/luatab.nvim",
        commit = " 7bc6e0f6957fbaa93c98529f2cf28052329002e0",
        lock = true,
        requires = "nvim-tree/nvim-web-devicons"
    }
    use {
        "folke/todo-comments.nvim",
        commit = "ae0a2afb47cf7395dc400e5dc4e05274bf4fb9e0",
        lock = true,
        requires = "nvim-lua/plenary.nvim"
    }
    use {
        "folke/trouble.nvim",
        commit = "46cf952fc115f4c2b98d4e208ed1e2dce08c9bf6",
        lock = true,
        requires = "nvim-tree/nvim-web-devicons"
    }
    use {
        "folke/twilight.nvim",
        commit = "1584c0b0a979b71fd86b18d302ba84e9aba85b1b",
        lock = true
    }
    use {"github/copilot.vim", disable = true}
    use {
        "hrsh7th/nvim-cmp",
        requires = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/cmp-nvim-lsp", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets"},
        commit = "98e8b9d593a5547c126a39212d6f5e954a2d85dd",
        lock = true
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        commit = "0010ea927ab7c09ef0ce9bf28c2b573fc302f5a7",
        lock = true,
        requires = "nvim-lua/plenary.nvim"
    }
    use {
        "lewis6991/gitsigns.nvim",
        commit = "5f808b5e4fef30bd8aca1b803b4e555da07fc412",
        lock = true,
        requires = "nvim-lua/plenary.nvim"
    }
    use {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        commit = "e82594274bf7b54387f9a2abe65f74909ac66e97",
        lock = true,
        requires = {"neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim"}
    }
    use {"mfussenegger/nvim-dap", disable = true}
    use {"mfussenegger/nvim-dap-python", disable = true, requires = "mfussenegger/nvim-dap"}
    use {
        "morhetz/gruvbox",
        commit = "f1ecde848f0cdba877acb0c740320568252cc482",
        lock = true
    }
    use {
        "neovim/nvim-lspconfig",
        commit = "9f2c279cf9abe584f03bfeb37c6658d68e3ff49d",
        lock = true
    }
    use {
        "numToStr/Comment.nvim",
        commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
        lock = true
    }
    use {
        "nvim-lua/plenary.nvim",
        commit = "2d9b06177a975543726ce5c73fca176cedbffe9d",
        lock = true
    }
    use {
        "nvim-lualine/lualine.nvim",
        commit = "2a5bae925481f999263d6f5ed8361baef8df4f83",
        lock = true,
        requires = "nvim-tree/nvim-web-devicons"
    }
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make"
    }
    use {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        requires = "nvim-lua/plenary.nvim"
    }
    use {
        "nvim-treesitter/nvim-treesitter",
        commit = "556ac68cd33973a38d3f2abac47f361432593fe2",
        lock = true,
        run = ":TSUpdate"
    }
    use {
        "rcarriga/nvim-dap-ui",
        requires = "mfussenegger/nvim-dap",
        disable = true
    }
    use {
        "rebelot/kanagawa.nvim",
        commit = "ad3dddecd606746374ba4807324a08331dfca23c",
        lock = true
    }
    use {
        "rmagatti/goto-preview",
        commit = "4972fcd01c568c2ae981f3f48182e7832ed544ec",
        lock = true
    }
    use {
        "simrat39/rust-tools.nvim",
        disable = true
    }
    use {
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
        disable = true
    }
    use {
        "someone-stole-my-name/yaml-companion.nvim",
        requires = {"neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"},
        disable = true
    }
    use {
        "sourcegraph/sg.nvim",
        disable = true,
        tag = "v1.0.8",
        run = "nvim -l build/init.lua"
    }
    use {
        "stevearc/aerial.nvim",
        commit = "fd7fbe36772d7a955815c90ff9b58523bfdb410d",
        lock = true
    }
    use {
        "stevearc/oil.nvim",
        commit = "dba037598843973b8c54bc5ce0318db4a0da439d",
        lock = true
    }
    use {
        "tpope/vim-fugitive",
        commit = "fcb4db52e7f65b95705aa58f0f2df1312c1f2df2",
        lock = true
    }
    use {
        "tpope/vim-surround",
        commit = "3d188ed2113431cf8dac77be61b842acb64433d9",
        lock = true
    }
    use {
        "wbthomason/packer.nvim",
        commit = "ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3",
        lock = true
    }  -- have packer manage itself
    use {
        "williamboman/mason-lspconfig.nvim",
        commit = "8e46de9241d3997927af12196bd8faa0ed08c29a",
        lock = true
    }
    use {
        "williamboman/mason.nvim",
        commit = "e2f7f9044ec30067bc11800a9e266664b88cda22",
        lock = true
    }
    use {
        "echasnovski/mini.indentscope",
        commit = "da9af64649e114aa79480c238fd23f6524bc0903",
        lock = true
    }
    use {
        "folke/noice.nvim",
        commit = "eaed6cc9c06aa2013b5255349e4f26a6b17ab70f",
        lock = true,
        requires = {"rcarriga/nvim-notify", "MunifTanjim/nui.nvim"}
    }
    use {
        "ggandor/leap.nvim",
        commit = "c6bfb191f1161fbabace1f36f578a20ac6c7642c",
        lock = true
    }
    use {
        "alexghergh/nvim-tmux-navigation",
        commit = "4898c98702954439233fdaf764c39636681e2861",
        lock = true
    }
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        commit = "ad8f0a472148c3e0ae9851e26a722ee4e29b1595",
        lock = true,
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter"
    }
    use {
        "nvim-focus/focus.nvim",
        commit = "d76338e58e49f844e8f6a7aff16a74a2a55a80ef",
        lock = true
    }
    use {"vim-pandoc/vim-pandoc"}
    use {"vim-pandoc/vim-pandoc-syntax"}
    use {"ThePrimeagen/git-worktree.nvim", disable = true}
    use {"polarmutex/git-worktree.nvim", disable = true, tag = "2.0.0"}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
