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
set listchars=tab:>─,trail:·
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
set wildmode=longest:full,full
set showcmd
" set digraph not necessary, use CTRL-K
"set esckeys

" Text options
set fo=cqrt
set ls=2
"set textwidth=80
set cc=100

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
autocmd BufRead, BufNewFile *.py set cc=120
autocmd BufRead, BufNewFile *.less set filetype=less
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css

" vim-plug settings
filetype off
call plug#begin('~/.config/nvim/plugged')

"Plug 'scrooloose/syntastic'
Plug 'w0rp/ale'
Plug 'majutsushi/tagbar', {'for': 'c'}
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/Gundo'
Plug 'airblade/vim-gitgutter'
Plug 'groenewege/vim-less', {'for': 'less'}
Plug 'rust-lang/rust.vim'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'kchmck/vim-coffee-script', {'for': 'coffeescript'}
Plug 'Townk/vim-autoclose'
Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-syntax-extra'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'rking/ag.vim'
"Plug 'jelera/vim-javascript-syntax'
Plug 'StanAngeloff/php.vim', {'for' : 'php'}
Plug 'hdima/python-syntax', {'for': 'python'}
Plug 'mxw/vim-jsx'
Plug 'justinmk/molokai'
Plug 'saltstack/salt-vim', {'for': 'sls'}
Plug 'godlygeek/tabular', {'for' : 'mkd'}
Plug 'plasticboy/vim-markdown', {'for': 'mkd'}
Plug 'solarnz/thrift.vim'
Plug 'posva/vim-vue'
"Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim', { 'do' : ':UpdateRemotePlugins' }

call plug#end()
filetype plugin indent on

" turn syntax highlighting on after plugins load
set termguicolors
colorscheme molokai
syntax on

" Ag.vim settings
let g:ag_working_path_mode="r"

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
let g:airline#extensions#ale#enabled = 1 
let g:airline_theme="hybridline"
" Syntastic settings
"let g:syntastic_check_on_open = 1
"let g:syntastic_auto_loc_list = 1

" Tagbar settings
let g:tagbar_show_linenumbers = 1

" Gundo mapping
nmap <F12> :GundoToggle<CR>

" Markdown settings
let g:vim_markdown_frontmatter=1

" Racer settings
let g:racer_experimental_completion = 1
let g:racer_cmd = "~/.cargo/bin/racer"
au FileType rust nmap <leader>] <Plug>(rust-def)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#complete_method = "complete"

" language client
let g:LanguageClient_serverCommands = {
    \ 'rust' : ['rustup', 'run', 'nightly', 'rls']
    \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

"let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
"let g:LanguageClient_loggingLevel = 'INFO'
"let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
