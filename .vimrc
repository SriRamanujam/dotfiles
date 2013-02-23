set t_Co=256
syntax on
colo Monokai
set number
set encoding=utf-8
set hidden
set tabstop=4
set autoindent
set copyindent
set smarttab
set smartcase
set incsearch
set hlsearch
set nobackup
set noswapfile


set wrapscan
"set spell
"set spelllang=en

" Vundle settings
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

"let vundle manage vundle, REQUIRED!!
Bundle 'gmarik/vundle'
" other bundles
Bundle 'scrooloose/nerdtree'
"Bundle 'scrooloose/syntastic'
Bundle 'majutsushi/tagbar'

" NERDTree settings
autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <C-n> :NERDTreeToggle<CR>

" Tagbar settings
nmap <F8> :TagbarToggle<CR>

filetype plugin indent on
