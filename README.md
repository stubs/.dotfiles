#New Machine Setup:

0) This assumes that you are running from a stock zshell.  aka a brand new mac.
1) git clone to your home dir: ~/.dotfiles
2) from the root of the repo run `./bootsrap.sh`
	a) See the comments for general description of actions taken.
    b) a restart will most likely be required.
3) neovim setup outline
    a) in init.lua comment out all after require plugins.
    b) `nvim nvim/.config/nvim/lua/plugins.lua` and save to trigger plugins install.
    c) in init.lua un-comment out all after require plugins.
