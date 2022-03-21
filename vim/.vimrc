" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" get Vundle
" let iCanHazVundle=1
" let vundle_readme=expand("~/.vim/bundle/vundle/README.md")
" if !filereadable(vundle_readme)
"     echo "Installing Vundle.."
"     echo ""
"     silent !mkdir -p ~/.vim/bundle
"     silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/vundle
"     let iCanHazVundle=0
" endif
"
" call vundle#begin()     " All plugins between these two call statements
" Plugin 'VundleVim/Vundle.vim'
" Plugin 'Raimondi/delimitMate'
" Plugin 'nathanaelkane/vim-indent-guides'
" Plugin 'tpope/vim-surround'
" Plugin 'junegunn/fzf'
" Plugin 'junegunn/fzf.vim'
" Plugin 'tpope/vim-fugitive'
" Plugin 'vim-airline/vim-airline'
" Plugin 'morhetz/gruvbox'
"
" "If fresh install of vundle, install my plugins
" if iCanHazVundle == 0
"     echo "Installing Vundles, please ignore key map error messages"
"     echo ""
"     :PluginInstall
" endif
" call vundle#end()

filetype off
filetype plugin indent on
syntax enable

" Rebind leader key
let mapleader = " "
set ai                  " always set autoindenting on
set clipboard=unnamed
set expandtab           " Use the appropriate number of spaces to insert a <Tab>
set fo-=t
set foldmethod=indent   " fold based on indent
set foldnestmax=3       " deepest fold is 3 levels
set grepprg=egrep\ -ni\ $*\ /dev/null
set hidden
set history=50          " keep 50 lines of command line history
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set nobackup
set nocompatible        " Use Vim defaults (much better!)
set nofoldenable        " dont fold by default
set noswapfile
set nowrap
set nowritebackup
set nu
" set rtp+=~/.vim/bundle/Vundle.vim
set rnu
set ruler               " show the cursor position all the time
set shiftround
set shiftwidth=4
set smartcase
set softtabstop=4
set splitbelow
set splitright
set tabstop=4
set viminfo='20,\"50    " read/write a .viminfo file, don't store more than 50 lines of registers
set wildignore+=*/tmp/*,*.swp " Linux/MacOSX
"set wildignore+=*\\tmp\\*, *.swp, *.zip, *.exe " Windows

" Jumps
noremap <S-Tab> <C-o>

" Alternate File
noremap <Leader>` <C-^>

" nohl
noremap <Leader>n :nohl<CR>

" My quick save command
noremap <C-z> :update<CR>
vnoremap <C-z> <esc>:update<CR>
inoremap <C-z> <esc>:update<CR>

" maximize horizontal/vertical splits
nnoremap _ <C-w>_
nnoremap <bar> <C-w><bar>
nnoremap = <C-w>=

" map sort function to a key
vnoremap <Leader>s :sort<CR>
vnoremap <Leader>S :sort!<CR>

" easier moving of code blocks
vnoremap < <gv
vnoremap > >gv

" FZF-Vim
" let g:fzf_preview_window = ['up:60%'] " always have preview window
" nnoremap <leader>p :GFiles! <CR>
"
" Buffer selecting with FZF
" nnoremap <leader>b :Buffers<cr>
"
" " FZF-Vim's Ag
" nnoremap <leader>f :Ag! <CR>
" " command! -bang -nargs=* Ag
" " \ call fzf#vim#ag(<q-args>,
" " \                 <bang>0 ? fzf#vim#with_preview('up:60%')
" " \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
" " \                 <bang>0)
"
" " Python Stuff******************************************
" function! PythonRun()
"     redir @s
"     :!clear; python %
" endfunction
"
" nnoremap <F1> :call PythonRun()<cr>
nnoremap <F1> :exec '!clear; python ' shellescape(@%, 1)<cr>
nnoremap <leader>d Oimport ipdb; ipdb.set_trace()  # <<<<<<<<<< BREAKPOINT
" End Python Stuff******************************************

" bind Ctrl+<movement> keys to move around the windows/splits
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-h> <C-w>h

" VIM-Indent Guide stuff
" let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_guide_size = 1

" Show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
map <Leader>x :%s/\s\+$//

" colorscheme settings
set background=light
" colorscheme gruvbox

" highlight colorcolumn ctermbg=233
