
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

"let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8, 'yoffset':0.5, 'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

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

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"function! FilesAndBuffers(dir)
"  let files_cmd = $FZF_DEFAULT_COMMAND
"  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
"  let files = systemlist(files_cmd)
"  call fzf#run({'source':buffers,
"        \ 'options': '--no-preview'
"        \ })
"endfunction
"call FilesAndBuffers("")
