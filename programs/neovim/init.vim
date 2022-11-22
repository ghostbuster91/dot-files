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
nnoremap <ESC> :noh<ESC>

" decrease width
nnoremap <C-Left> <C-W><
" increase width
nnoremap <C-Right> <C-W>>
" decrease height
nnoremap <C-Up> <C-W>-
" increase height
nnoremap <C-Down> <C-W>+

