" Basic settings
set nocompatible
set t_Co=256
syntax on
colo Monokai


" Line number settings
set ruler
set number
set relativenumber

" Whitespace settings
set encoding=utf-8
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set preserveindent
set listchars=tab:>─,trail:·,extends:┐
set list
set smarttab

" Search settings
set smartcase
set incsearch
set hlsearch
set ignorecase

" Swap/backup settings
set nobackup
set noswapfile

" UI settings
set foldenable
set showmatch
set laststatus=2
set foldmethod=syntax
set foldlevelstart=99


"Training myself to be a better vimmer
" inoremap <Esc> <NOP>
" inoremap jj <Esc>
" Make cursor move as expected with wrapped lines
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk


set wrapscan
"set spell
"set spelllang=en

" Filetype-specific settings
autocmd BufRead, BufNewFile *.py setlocal foldmethod=indent

" Vundle settings
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

"let vundle manage vundle, REQUIRED!!
Plugin 'gmarik/vundle'
" other bundles
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/Gundo'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'airblade/vim-gitgutter'
Plugin 'plasticboy/vim-markdown'

" NERDTree settings
autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <C-n> :NERDTreeToggle<CR>

" Tagbar settings
nmap <F8> :TagbarToggle<CR>

" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode= 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

filetype plugin indent on

" Airline symbols
let g:airline_powerline_fonts = 1
let AirlineTheme="molokai"

" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_auto_loc_list = 1
