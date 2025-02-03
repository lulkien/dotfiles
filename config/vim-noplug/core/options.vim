set number
set relativenumber
set numberwidth=3
set ruler

set clipboard="unnamedplus"

set cursorline
set cursorlineopt=number

set autoindent
set smartindent
set ignorecase
set smartcase

set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab

set scrolloff=30
set sidescrolloff=8

set cmdheight=1
" set termguicolors
set pumheight=10

set showtabline=2

set signcolumn=yes
set splitbelow
set splitright
set timeoutlen=400

set nobackup
set noswapfile

if version >= 703
  set undodir=~/.cache/vim/undo
  set undofile
  set undoreload=10000
else
  set noundofile
endif

set whichwrap=b,s,<,>,[,],h,l

set fileencoding=utf-8

set incsearch
set hlsearch
set showmatch

filetype on
filetype indent on
syntax on
