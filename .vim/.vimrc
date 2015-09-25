" Auto-source vimrc on save
autocmd! bufwritepost .vimrc source %

if has("gui_macvim")
  set background=dark
endif

let shell_background=$BACKGROUND

set background=dark
if shell_background == 'light'
  set background=light
endif

set nocompatible
filetype plugin indent on 

set clipboard=unnamed

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Don’t reset cursor to start of line when moving around.
"set nostartofline

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
Plugin 'L9'
" Plugin 'FuzzyFinder'
" Plugin 'airblade/FuzzyFinder_Textmate'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" Plugin 'bling/vim-airline'
Plugin 'powerline/powerline'
"Plugin 'Valloricw/YouCompleteMe'
Plugin 'scrooloose/nerdcommenter'
Plugin 'guns/xterm-color-table.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'unblevable/quick-scope'
Plugin 'lsdr/monokai'
Plugin 'altercation/vim-colors-solarized'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-endwise'
Plugin 'mattn/flappyvird-vim'
Plugin 'shawncplus/phpcomplete.vim'
Plugin 'StanAngeloff/php.vim'
Plugin 'vim-scripts/ZoomWin'

call vundle#end()

" Set comma as leader key
let mapleader=","
"nnoremap ; :
filetype plugin indent on
syntax on

set showtabline=1
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set hlsearch
set incsearch
set showmatch
set wildmode=list:longest
set relativenumber
set title

set ruler
set laststatus=2
set scrolloff=3

" powerline-status setup
set guioptions-=T
set guioptions-=r
set go-=L
set linespace=1
set showmode
set visualbell
set foldmethod=indent
set foldnestmax=10
set nofoldenable 
set foldlevel=1
set ttimeoutlen=50
set shell=$SHELL
set backspace=indent,eol,start
set listchars=tab:▸\ ,eol:¬,nbsp:.      
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

" Default color scheme
let base16colorspace=256 " Access colors present in 256 colorspace
set t_Co=256 " 256 color mode

colorscheme base16-eighties

python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

nnoremap <C-S> <C-W>
" Unmap arrow keys in normal mode
nnoremap <up> :m-2<CR>
nnoremap <down> :m+1<CR>
nnoremap <left> <Nop>
nnoremap <right> <Nop>
"nnoremap j gj
"nnoremap k gk

" Tame vim's regex
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
nnoremap <leader>s <esc>:%s/\v
vnoremap <leader>s <esc>:%s/\v

" Clear search
nnoremap <leader><space> :noh<cr>

nnoremap <tab> %
vnoremap <tab> %

" Text wrapping
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=80

" Unmap mouse scrolls
nnoremap <ScrollWheelUp> <Nop>
nnoremap <S-ScrollWheelUp> <Nop>
nnoremap <C-ScrollWheelUp> <Nop>
nnoremap <ScrollWheelDown> <Nop>
nnoremap <S-ScrollWheelDown> <Nop>
nnoremap <C-ScrollWheelDown> <Nop>
nnoremap <ScrollWheelLeft> <Nop>
nnoremap <S-ScrollWheelLeft> <Nop>
nnoremap <C-ScrollWheelLeft> <Nop>
nnoremap <ScrollWheelRight> <Nop>
nnoremap <S-ScrollWheelRight> <Nop>
nnoremap <C-ScrollWheelRight> <Nop>

" Tabbing on normal and visual modes
nnoremap <S-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprevious<CR>
inoremap <C-Tab> <ESC>:tabprevious<CR>
vnoremap <S-Tab> :tabnext<CR>
vnoremap <C-S-Tab> :tabprevious<CR>

nnoremap <leader>m :NERDTreeToggle<cr>
nnoremap <leader>n :CtrlP<cr>
nnoremap <leader>N :CtrlPMRUFiles<cr>
nnoremap <leader>a :Ag

" Common wraps
inoremap <leader>' ''<ESC>i
inoremap <leader>( ()<ESC>i
inoremap <leader>" ""<ESC>i
inoremap <leader>{ {}<ESC>i
inoremap <leader>[ []<ESC>i
"let g:CommandTMaxHeight = 15 
"let g:CommandTHighlightColor = "Visual"

" Highlight colors 
"hi Search ctermfg=0 ctermbg=11 guifg=Black 
"hi LineNr ctermfg=242
"hi ColorColumn ctermbg=black
if shell_background == 'dark'
  hi CursorLine cterm=NONE ctermbg=239
endif

" Toggle cursorline
nnoremap <Leader>h :set cursorline!<CR>

" Map backspace to delete line without overwriting pasteboard
nnoremap <leader><BS> "_dd
vnoremap <leader><BS> "_dd
nnoremap <BS> "_d
vnoremap <BS> "_d

" Toggle `set list`
nmap <leader>l :set list!<CR>

" Toggle between relative & absolute file number
function! NumberToggle()
  if(&relativenumber == 1)
    set number
    set relativenumber!
  else
    set relativenumber
    set number!
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<CR>
" Toggle YouCompleteMe
nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" Resize panes
nnoremap + <C-w>+
nnoremap - <C-w>-
"Execute current line in shell and paste output into buffer
nnoremap Q !!bash


" Save when vim buffer lose focus
au FocusLost * :wa

" Activate cursor line on current buffer only
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

nnoremap <leader>C "+y
xnoremap <leader>C "+y
nnoremap <leader>x "+d
xnoremap <leader>x "+d
nnoremap <leader>p "+p
xnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>P "+P

nnoremap <leader>/<Space> :call NERDComment(0, "toggle")<CR>
xnoremap <leader>/<Space> :call NERDComment(0, "toggle")<CR>

" Special file type associations
autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
autocmd BufNewFile,BufRead Gemfile set filetype=ruby
autocmd BufNewFile,BufRead Berksfile set filetype=ruby
autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

nnoremap <leader>a :Ag 

"Another enhanced script from
"http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <C-x> :call <SID>ExecuteInShell(getline('.'))<CR>

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
set viminfo+=n~/.vim/viminfo

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

" Ident entire file. Uses 'i' as mark so that it goes back to the current line.
nnoremap <leader>= migg=G'i
nnoremap <silent> <C-w>z :ZoomWin<cr>
