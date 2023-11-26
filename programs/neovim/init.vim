set mouse=a
      	
syntax on

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

set diffopt+=linematch:60
let g:undotree_WindowLayout = 2

autocmd VimEnter * :clearjumps

"When a file has been detected to have been changed outside of Vim
"and it has not been changed inside of Vim, automatically read it again.
:set autoread


let g:sandwich_no_default_key_mappings = 1

" add
nmap sa <Plug>(sandwich-add)
xmap sa <Plug>(sandwich-add)

" delete
nmap sd <Plug>(sandwich-delete)
xmap sd <Plug>(sandwich-delete)
nmap sdb <Plug>(sandwich-delete-auto)

" replace
nmap sr <Plug>(sandwich-replace)
xmap sr <Plug>(sandwich-replace)
nmap srb <Plug>(sandwich-replace-auto)
