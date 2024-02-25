
" Toggle cursorline
nnoremap <Leader>h :set cursorline!<CR>

" Toggle `set list`
nmap <leader>l :set list!<CR>

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" Resize panes
"nnoremap + <C-w>+
"nnoremap - <C-w>-
"Execute current line in shell and paste output into buffer
nnoremap <leader>Q !!bash

"nnoremap <silent> <C-w>z :ZoomWin<cr>
inoremap kj <esc>

nnoremap ,o o<esc>
nnoremap ,O O<esc>

nnoremap Q @@

nnoremap <C-h> gt
nnoremap <C-k> gT
nnoremap <C-e>n :tabnew<cr>
nnoremap <C-e>x :tabc<cr>
nnoremap gp `[v`]


command! Trailing :%s/\s\+$//e
command! Blankl :g/^$/d
nnoremap <C-w>z :tab split<cr>
nnoremap <C-w>o <Nop>

nnoremap <left> :cprev<cr>
nnoremap <right> :cnext<cr>

command! W <cr>

noremap <leader>t2 :set shiftwidth=2 softtabstop=2<CR>
noremap <leader>t4 :set shiftwidth=4 softtabstop=4<CR>
