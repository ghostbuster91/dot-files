set mouse=a
      	
syntax on

set relativenumber
set number
set wildcharm=<C-Z>

set termguicolors

cnoremap <expr> <Up>    pumvisible() ? "\<Left>"  : "\<Up>"
cnoremap <expr> <Down>  pumvisible() ? "\<Right>" : "\<Down>"
cnoremap <expr> <Left>  pumvisible() ? "\<Up>"    : "\<Left>"
cnoremap <expr> <Right> pumvisible() ? "\<Down>"  : "\<Right>"

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <ESC> :noh<ESC>

set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

"Persist undotree history in /tmp
let s:undodir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undodir)
    call mkdir(s:undodir, "", 0700)
endif
let &undodir=s:undodir
set undofile

