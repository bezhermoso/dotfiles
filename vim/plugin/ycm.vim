
" Toggle YouCompleteMe
nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>

let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers.php =
\ ['->', '::', '(', 'use ', 'namespace ', '\']
