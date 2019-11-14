" get Vundle
let iCanHazVundle=1
let vundle_readme=expand("~/.vim/bundle/vundle/README.md")
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif

filetype off
filetype plugin indent on
syntax on

set ai                  " always set autoindenting on
set bs=2
set clipboard=unnamed
set colorcolumn=80
set expandtab
set fo-=t
set laststatus=2
set mouse=a
set nobackup
set nocompatible	    " Use Vim defaults (much better!)
set noswapfile
set nowrap
set nowritebackup
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim
set shiftround
set shiftwidth=4
set softtabstop=4
set splitright          " Remap new splits to always open right of current buffer
set tabstop=4
set tw=0
set hlsearch
set incsearch
set ignorecase
set smartcase
set foldmethod=indent   " fold based on indent
set foldnestmax=3       " deepest fold is 3 levels
set nofoldenable        " dont fold by default
set viminfo='20,\"50    " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set grepprg=egrep\ -ni\ $*\ /dev/null
set wildignore+=*/tmp/*,*.swp " Linux/MacOSX
"set wildignore+=*\\tmp\\*, *.swp, *.zip, *.exe " Windows
"set bs=indent,eol,start        " allow backspacing over everything in insert mode
"set runtimepath^=~/.vim/bundle/ctrlp.vim
"set runtimepath^=~/.vim/bundle/ag

"Custom Left/Right movement
noremap t <Left>

" Rebind leader key
let mapleader = ","

" VIM-Indent Guide stuff
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" Show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
map <Leader>x :%s/\s\+$//

" bind F to grep word under the cursor
nnoremap F :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Bind nohl
noremap <Leader>n :nohl<CR>
vnoremap <Leader>n :nohl<CR>
inoremap <Leader>n :nohl<CR>

" My quick save command
noremap <C-z> :update<CR>
vnoremap <C-z> <esc>:update<CR>
inoremap <C-z> <esc>:update<CR>

" bind Ctrl+<movement> keys to move around the windows/splits
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-h> <C-w>h

" map sort function to a key
vnoremap <Leader>s :sort<CR>
vnoremap <Leader>S :sort!<CR>

" easier moving of code blocks
vnoremap < <gv
vnoremap > >gv

" Awesome line number magic
function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

nnoremap <Leader>l :call NumberToggle()<cr>
:au FocusLost * set number
:au FocusGained * set relativenumber
autocmd InsertEnter * set number
autocmd InsertLeave * set relativenumber
set relativenumber
" End of awesome line number magic

highlight colorcolumn ctermbg=233

call vundle#begin()     " All plugins between these two call statements
Plugin 'VundleVim/Vundle.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'powerline/powerline' ", {'rtp': 'powerline/bindings/vim/'}
Plugin 'tpope/vim-surround'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'rking/ag.vim'

"If fresh install of vundle, install my plugins
if iCanHazVundle == 0
    echo "Installing Vundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
call vundle#end()

" CTRL-P stuff************************************
let g:ctrlp_map = '<c-p>'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](Applications|Documents|Library|Movies|Music|Pictures)$'
    \ }

" Powerline stuff*********************************
set guifont=Inconsolata\ for\ Powerline:h12
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8

if has ("gui_running")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        set guifont =Inconsolata\ for\ Powerline:h12
    endif
endif

" Solarized colorscheme settings
set background=dark
colorscheme solarized

" Python******************************************
nnoremap <F1> :exec '!clear; python' shellescape(@%, 1)<cr>

" AG stuff************************************
"if executable('ag')
" Note we extract the column as well as the file and line number
"    set grepprg=ag\ --nogroup\ --nocolor\ --column
"    set grepformat=%f:%l:%c%m
"    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"    let g:ctrlp_use_caching = 0
"endif
"nmap <silent> <RIGHT> :cnext<CR>
"nmap <silent> <LEFT> :cprev<CR>
