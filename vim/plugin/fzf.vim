
set rtp+=/usr/local/opt/fzf

command! -bang -nargs=* Agu call fzf#vim#ag(<q-args>, '--skip-vcs-ignores', {'down': '~40%'})
command! -bang -nargs=* AgU call fzf#vim#ag(<q-args>, '--skip-vcs-ignores --hidden', {'down': '~40%'})

nnoremap <leader>f :NERDTreeClose <bar> Files<cr>
nnoremap <leader>F :NERDTreeClose <bar> History<cr>
nnoremap <leader>gf :HERDTreeClose <bar> GitFiles<cr>

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()
