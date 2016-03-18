
set rtp+=/usr/local/opt/fzf

command! -bang -nargs=* Agu call fzf#vim#ag(<q-args>, '--skip-vcs-ignores', {'down': '~40%'})

nnoremap <leader>f :Files<cr>
nnoremap <leader>F :History<cr>

