set t_Co=256
syntax on
colo Monokai
set number

set wrapscan
"set spell
"set spelllang=en

" Vundle settings
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

"let vundle manage vundle, REQUIRED!!
Bundle 'gmarik/vundle'

filetype plugin indent on
