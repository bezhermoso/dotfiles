" Auto-source vimrc on save
"autocmd! bufwritepost .vimrc source %


set nocompatible

filetype plugin indent on
syntax on
set synmaxcol=500

" Set comma as leader key
let mapleader="\<Space>"

let g:plug_timeout=180
call plug#begin()
Plug 'tpope/vim-fugitive'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plug 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plug 'user/L9', {'name': 'newL9'}
Plug 'L9'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFocus'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/base16-vim'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
"Plug 'powerline/powerline'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdcommenter'
Plug 'guns/xterm-color-table.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'unblevable/quick-scope'
"Plug 'lsdr/monokai'
"Plug 'altercation/vim-colors-solarized'
Plug 'rking/ag.vim'
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
Plug 'mattn/flappyvird-vim'
"Plug 'shawncplus/phpcomplete.vim'
Plug 'StanAngeloff/php.vim'
" ZoomWin doesn't work well in neovim
"Plug 'vim-scripts/ZoomWin'
Plug 'rstacruz/vim-closer'
Plug 'austintaylor/vim-commaobject'
Plug 'beberlei/vim-php-refactor', { 'for': 'php' }
"Plug 'easymotion/vim-easymotion'
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/syntastic'
Plug 'chrisbra/unicode.vim'
"Plug 'majutsushi/tagbar'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'tpope/vim-vinegar'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'kchmck/vim-coffee-script'
"Plug 'Xuyuanp/nerdtreemce-EMAIL-git-plugin'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/argtextobj.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock', {'for': 'ruby'}
Plug 'rizzatti/dash.vim'
Plug 'vim-scripts/groovy.vim', {'for': 'groovy'}
Plug 'dag/vim2hs', {'for': 'haskell'}
Plug 'netrw.vim'
Plug 'ReplaceWithRegister'
Plug 'tpope/vim-commentary'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'kylef/apiblueprint.vim'
Plug 'evidens/vim-twig'
Plug 'junegunn/vim-easy-align'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make -f make_mac.mak'}
Plug 'pangloss/vim-javascript'
"Plug 'rstacruz/vim-node-import'
"Plug 'mxw/vim-jsx'
"Plug 'rstacruz/vim-hyperstyle'
Plug 'stephpy/vim-yaml'
Plug 'python.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'm2mdas/phpcomplete-extended', {'for': 'php'}
"Plug 'm2mdas/phpcomplete-extended-symfony', {'for': 'php'}
Plug 'arnaud-lb/vim-php-namespace', {'for': 'php'}
Plug 'jwalton512/vim-blade'
Plug 'jiangmiao/auto-pairs'
Plug 'benekastah/neomake'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'joeytwiddle/sexy_scroller.vim'
Plug 'junegunn/vim-xmark', {'do': 'make'}
Plug 'leafgarland/typescript-vim'
Plug '2072/PHP-Indenting-for-Vim'
Plug 'mkusher/padawan.vim'
Plug 'textobj-syntax'
Plug 'tpope/vim-vinegar'

"NEW PLUGINS HERE
call plug#end()

set shell=$SHELL

"if has("nvim")

"else
  "python from powerline.vim import setup as powerline_setup
  "python powerline_setup()
  "python del powerline_setup
"endif

runtime macros/matchit.vim

"set exrc
"set secure

"let g:unite_source_history_yank_enable = 1
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"let g:unite_source_rec_async_command = [ 'ag', '-l', '-g', '', '--nocolor' ]

let g:startify_bookmarks = ['~/.vimrc', '~/.zprofile', '~/.zshrc']
let g:startify_change_to_dir=0

let NERDTreeCascadeOpenSingleChildDir=0