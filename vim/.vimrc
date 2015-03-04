" Basic settings
set nocompatible
set t_Co=256
syntax on

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
"set showmatch this is broken with Luna theme, unfortunately :(
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

""" KEYBINDINGS
" Make cursor move as expected with wrapped lines
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
" Set up buffer movement hotkeys
map <Leader>j :bprev<Enter>
map <Leader>k :bnext<Enter>

set wrapscan
"set spell
"set spelllang=en

" Filetype-specific settings
autocmd BufRead, BufNewFile *.py setlocal foldmethod=indent
autocmd BufRead, BufNewFile *.less set filetype=less

" vim-plug settings
filetype off
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar', {'for': 'c'}
Plug 'bling/vim-airline'
Plug 'pychimp/vim-luna'
Plug 'kien/ctrlp.vim'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/Gundo'
Plug 'airblade/vim-gitgutter'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'Townk/vim-autoclose'
Plug 'tpope/vim-vinegar'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

call plug#end()
filetype plugin indent on
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
let g:airline_theme="luna"
" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_auto_loc_list = 1

" Easymotion settings
"let g:EasyMotion_do_mapping = 0 "Disable default mapping
"nmap <Leader><Leader> <Plug>(easymotion-jumptoanywhere)

" Tagbar settings
let g:tagbar_show_linenumbers = 1

" need to put colorscheme after plugin load
colorscheme luna-term
