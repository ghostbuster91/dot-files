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

let g:tmux_resizer_no_mappings = 1

nnoremap <silent> <C-Left> :TmuxResizeLeft<CR>
nnoremap <silent> <C-Down> :TmuxResizeDown<CR>
nnoremap <silent> <C-Up> :TmuxResizeUp<CR>
nnoremap <silent> <C-Right> :TmuxResizeRight<CR>
