let mapleader=" "
let maplocalleader=" "

nnoremap <Left>   <Nop>
nnoremap <Right>  <Nop>
nnoremap <Up>     <Nop>
nnoremap <Down>   <Nop>

inoremap <Left>   <Nop>
inoremap <Right>  <Nop>
inoremap <Up>     <Nop>
inoremap <Down>   <Nop>

vnoremap <Left>   <Nop>
vnoremap <Right>  <Nop>
vnoremap <Up>     <Nop>
vnoremap <Down>   <Nop>

" Wrapline toggle
nnoremap <leader>lw :set wrap!<CR>

" Indent mode
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Scroll and centered
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Find and centered
nnoremap n nzzzv
nnoremap N Nzzzv

" Clear highlight
nnoremap <Esc> :nohlsearch<CR>

" Line moving
vnoremap <C-j> :move '>+1<CR>gv=gv
vnoremap <C-k> :move '<-2<CR>gv=gv

" x: just cut and don't put into register
nnoremap x "_x
vnoremap x "_x
