" Basic settings
set nocompatible
set t_Co=256

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
set foldmethod=indent
set foldlevelstart=99
set hidden
set wildmenu
set showcmd
" set digraph not necessary, use CTRL-K
set esckeys

" Text options
set fo=cqrt
set ls=2
"set textwidth=80
set cc=80

" Tab and split settings
set splitbelow
set splitright


""" KEYBINDINGS
" set mapleader
let mapleader = " "
" Make cursor move as expected with wrapped lines
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
" Set up buffer movement hotkeys
map <Leader>j :bprev<Enter>
map <Leader>k :bnext<Enter>
map <Leader>h <C-w>h
map <Leader>t <C-w>j
map <Leader>n <C-w>k
map <Leader>s <C-w>l


set wrapscan
"set spell
"set spelllang=en

" Filetype-specific settings
"autocmd BufRead, BufNewFile *.py setlocal foldmethod=indent
autocmd BufRead, BufNewFile *.less set filetype=less

" vim-plug settings
filetype off
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar', {'for': 'c'}
Plug 'bling/vim-airline'
Plug 'kien/ctrlp.vim'
"Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/Gundo'
Plug 'airblade/vim-gitgutter'
Plug 'groenewege/vim-less', {'for': 'less'}
Plug 'kchmck/vim-coffee-script', {'for': 'coffeescript'}
Plug 'Townk/vim-autoclose'
Plug 'tpope/vim-vinegar'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}
Plug 'jelera/vim-javascript-syntax'
Plug 'hdima/python-syntax', {'for': 'python'}
Plug 'mxw/vim-jsx'
Plug 'sickill/vim-monokai'

Plug 'godlygeek/tabular', {'for' : 'mkd'}
Plug 'plasticboy/vim-markdown', {'for': 'mkd'}

call plug#end()
filetype plugin indent on

" turn syntax highlighting on after plugins load
syntax on
" NERDTree settings
"autocmd vimenter * NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"map <C-n> :NERDTreeToggle<CR>

" Tagbar settings
nmap <F8> :TagbarToggle<CR>

" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode= 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_extensions = ['buffertag', 'dir']

" Airline symbols
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme="hybridline"
" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_auto_loc_list = 1

" Easymotion settings
"let g:EasyMotion_do_mapping = 0 "Disable default mapping
"nmap <Leader><Leader> <Plug>(easymotion-jumptoanywhere)

" Tagbar settings
let g:tagbar_show_linenumbers = 1

" Gundo mapping
nmap <F12> :GundoToggle<CR>

" Markdown settings
let g:vim_markdown_frontmatter=1

" need to put colorscheme after plugin load
colorscheme monokai

