
set rtp+=/usr/local/opt/fzf

command! -bang -nargs=* Agu call fzf#vim#ag(<q-args>, '--skip-vcs-ignores', {'down': '~40%'})
command! -bang -nargs=* AgU call fzf#vim#ag(<q-args>, '--skip-vcs-ignores --hidden', {'down': '~40%'})

nnoremap <leader>f :NERDTreeClose <bar> Files<cr>
nnoremap <leader>F :NERDTreeClose <bar> History<cr>
nnoremap <leader>gf :HERDTreeClose <bar> GitFiles<cr>

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=1 ctermbg=7
  highlight fzf2 ctermfg=0 ctermbg=7
  highlight fzf3 ctermfg=0 ctermbg=7
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

"let g:fzf_colors =
  "\ { 'fg':      ['fg', 'Normal'],
  "\ 'bg':      ['bg', 'Normal'],
  "\ 'hl':      ['fg', 'Statement'],
  "\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  "\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  "\ 'hl+':     ['fg', 'Statement'],
  "\ 'info':    ['fg', 'PreProc'],
  "\ 'prompt':  ['fg', 'Conditional'],
  "\ 'pointer': ['fg', 'Exception'],
  "\ 'marker':  ['fg', 'Keyword'],
  "\ 'spinner': ['fg', 'Label'],
  "\ 'header':  ['fg', 'Comment'] }
