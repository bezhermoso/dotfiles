" Auto-source vimrc on save
"autocmd! bufwritepost .vimrc source %


set nocompatible

syntax on
set synmaxcol=500

" Set comma as leader key
let mapleader="\<Space>"

let g:plug_timeout=180
call plug#begin('~/.vim/plugged')
" Plug 'tpope/vim-fugitive'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plug 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plug 'user/L9', {'name': 'newL9'}
Plug 'vim-scripts/L9'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFocus', 'NERDTreeClose'] }
Plug 'ctrlpvim/ctrlp.vim', { 'on': ['CtrlP', 'CtrlPMRUFiles']  }
Plug 'chriskempson/base16-vim'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'guns/xterm-color-table.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
"Plug 'StanAngeloff/php.vim'
Plug 'rstacruz/vim-closer'
Plug 'austintaylor/vim-commaobject'
Plug 'easymotion/vim-easymotion'
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'
Plug 'chrisbra/unicode.vim'
Plug 'majutsushi/tagbar'
"Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'kchmck/vim-coffee-script'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/argtextobj.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock', {'for': 'ruby'}
Plug 'rizzatti/dash.vim'
Plug 'vim-scripts/groovy.vim', {'for': 'groovy'}
Plug 'dag/vim2hs', {'for': 'haskell'}
Plug 'vim-scripts/netrw.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-commentary'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'kylef/apiblueprint.vim'
Plug 'evidens/vim-twig'
Plug 'junegunn/vim-easy-align'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make -f make_mac.mak'}
Plug 'pangloss/vim-javascript'
Plug 'stephpy/vim-yaml'
Plug 'vim-scripts/python.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jwalton512/vim-blade'
Plug 'jiangmiao/auto-pairs'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install()  }, 'for': ['markdown', 'vim-plug'] }
Plug 'leafgarland/typescript-vim'
Plug 'vim-scripts/textobj-syntax'
Plug 'tpope/vim-vinegar'
Plug 'vim-scripts/restore_view.vim'
Plug 'vim-scripts/SyntaxRange'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-sleuth'
Plug 'NLKNguyen/papercolor-theme'
Plug 'algotech/ultisnips-php'
Plug 'airblade/vim-gitgutter'
Plug 'jamessan/vim-gnupg'
"Plug 'w0rp/ale'
Plug 'gregsexton/gitv', {'on': ['Gitv']}
Plug 'tpope/vim-rhubarb'
Plug 'rstacruz/vim-remux'
Plug 'posva/vim-vue'
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
Plug 'fatih/vim-go'
Plug 'mustache/vim-mustache-handlebars'
Plug 'chr4/nginx.vim'
Plug 'andymass/vim-tradewinds'
Plug 'dhruvasagar/vim-table-mode'
Plug 'mzlogin/vim-markdown-toc'
Plug 'RRethy/vim-illuminate'
Plug 'luochen1990/rainbow'
Plug 'wlangstroth/vim-racket'
Plug 'zivyangll/git-blame.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'
Plug 'hashivim/vim-terraform'
Plug 'isobit/vim-caddyfile'
Plug 'ludovicchabant/vim-gutentags'
"if has('nvim')
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
  "Plug 'Shougo/deoplete.nvim'
  "Plug 'roxma/nvim-yarp'
  "Plug 'roxma/vim-hug-neovim-rpc'
"endif

"Plug 'phpactor/phpactor' ,  {'do': 'composer install --no-ansi', 'for': 'php'}
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

filetype plugin indent on
"set exrc
"set secure

"let g:unite_source_history_yank_enable = 1
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"let g:unite_source_rec_async_command = [ 'ag', '-l', '-g', '', '--nocolor' ]

let g:startify_bookmarks = ['~/.dotfiles/zsh/.zprezto/runcoms/zshrc', '~/.dotfiles/vim/init.vim']
let g:startify_change_to_dir=0

let NERDTreeCascadeOpenSingleChildDir=0

let g:python_host_prog=$HOME.'/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog=$HOME.'/.pyenv/versions/neovim3/bin/python'
let g:ycm_server_python_interpreter=$HOME.'/.pyenv/versions/neovim2/bin/python'

let g:NERDCustomDelimiters = { 'yaml': { 'left': '# ','right': '' } }

set tabstop=2

set grepprg=rg\ --vimgrep
set rtp+=/usr/local/opt/fzf

