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
set foldmethod=indent
set foldlevelstart=99
set hidden
set wildmenu
set showcmd
set digraph
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

" Vundle settings
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"let vundle manage vundle, REQUIRED!!
Plugin 'gmarik/Vundle.vim'
" other bundles
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'wellle/targets.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/Gundo'
Plugin 'airblade/vim-gitgutter'
Plugin 'groenewege/vim-less'
Plugin 'kchmck/vim-coffee-script'
Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-vinegar'

call vundle#end()
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
let AirlineTheme="molokai"
let g:airline#extensions#tabline#enabled = 1

" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_auto_loc_list = 1

" Easymotion settings
"let g:EasyMotion_do_mapping = 0 "Disable default mapping
"nmap <Leader><Leader> <Plug>(easymotion-jumptoanywhere)

" Tagbar settings
let g:tagbar_show_linenumbers = 1
