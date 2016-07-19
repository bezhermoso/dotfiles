
" Save when vim buffer lose focus
"au FocusLost * :wa

" Activate cursor line on current buffer only
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Special file type associations "autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
autocmd BufNewFile,BufRead {Vagrant,Gem,Berks}file set filetype=ruby
"autocmd BufNewFile,BufRead Berksfile set filetype=ruby
autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
autocmd BufNewFile,BufRead *.{handlebars,hbs} setlocal filetype=javascript
autocmd BufNewFile,BufRead *.{module,install,theme} setlocal filetype=php
autocmd BufNewFile,BufRead *.blade.php setlocal filetype=html
autocmd BufNewFile,BufRead *.twig setlocal filetype=html
autocmd BufNewFile,BufRead Dockerfile.* setlocal filetype=dockerfile

let g:jsx_ext_required=0
" Enable spellcheck on git commits & markdown files
autocmd BufRead COMMIT_EDITMSG setlocal spell!
autocmd BufRead *.{md,markdown} setlocal spell!
autocmd FileChangedShell * echo "Warning: File changed on disk"

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init({'wrap': 'soft'})
                            "\ | call lexical#init()
                            "\ | call litecorrect#init()
                            "\ | call textobj#quote#init()
                            "\ | call textobj#sentence#init()
augroup END

let g:padawan#composer_command="/usr/local/bin/composer"
