
"set clipboard=unnamed
set pastetoggle=<F2>
set autoread

set showtabline=1
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set hlsearch incsearch ignorecase smartcase
set showmatch
set wildmode=list:longest
set relativenumber
set title

set ruler
set laststatus=2
set scrolloff=8

set guioptions-=T
set guioptions-=r
set go-=L
set linespace=1
set showmode
set visualbell
set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevel=1
"set ttimeoutlen=50
set timeoutlen=1000 ttimeoutlen=0
set backspace=indent,eol,start
"set listchars=tab:▸\ ,eol:¬
set listchars=tab:▸\ ,trail:∙
  
set list
set ruler
set showcmd
set incsearch
set laststatus=2

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
set cursorline
set ttyfast
set undofile
" set ignorecase
set smartcase

" Text wrapping
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=+1
set fo-=t

" http://stackoverflow.com/a/9528322
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
"set viminfo+=n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

if has('persistent_undo')
  set undolevels=5000
endif
set updatecount=10

set wrap
set linebreak


if has("nvim")
  set inccommand=nosplit
endif
