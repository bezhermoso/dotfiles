
" Unmap arrow keys in normal mode
nnoremap <up> :m-2<CR>
nnoremap <down> :m+1<CR>
nnoremap <left> <Nop>
nnoremap <right> <Nop>

" Tame vim's regex
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
nnoremap <leader>s <esc>:%s//g<left><left>

" Keep search results centered
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

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
"nnoremap <S-Tab> :tabnext<CR>
"nnoremap <C-S-Tab> :tabprevious<CR>

" Toggle cursorline
nnoremap <Leader>h :set cursorline!<CR>

" Map backspace to delete line without overwriting pasteboard
"nnoremap <leader><BS> "_dd
"vnoremap <leader><BS> "_dd
nnoremap <BS> "_d
vnoremap <BS> "_d
nnoremap <BS><BS> "_dd
vnoremap <BS> "_d

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

" Copy/cut/paste from system buffer.
"nnoremap <leader>C "+y
"xnoremap <leader>C "+y
"nnoremap <leader>x "+d
"xnoremap <leader>x "+d
"nnoremap <leader>p "+p
"xnoremap <leader>p "+p
"nnoremap <leader>P "+P
"xnoremap <leader>P "+P

nnoremap <leader>a :Ag

vnoremap < <gv
vnoremap > >gv

"nnoremap <silent> <C-w>z :ZoomWin<cr>
inoremap kj <esc>

nnoremap ,o o<esc>
nnoremap ,O O<esc>

"cnoremap <C-j> <t_kd>
"cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

nnoremap Q @@

" use ,F to jump to tag in a vertical split
nnoremap <silent> ,F :let word=expand("<cword>")<CR>:vsp<CR>:exec("tag ". word)<cr>

" use ,gf to go to file in a vertical split
nnoremap <silent> ,gf :vertical botright wincmd f<CR>

nnoremap <C-l> gt
nnoremap <C-k> gT
nnoremap <C-e>n :tabnew<cr>
nnoremap gp `[v`]
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
vnoremap <F1> <Nop>


command! Trailing :%s/\s\+$//e
command! Blankl :g/^$/d
nnoremap <C-w>z :tab split<cr>
nnoremap <C-w>o <Nop>

nnoremap <left> :cprev<cr>
nnoremap <right> :cnext<cr>

nnoremap <leader><leader> :noh<cr>

nnoremap <Tab><Tab> za
nnoremap <S-Tab><S-Tab> zA

command! W <cr>
nnoremap + "+
vnoremap + "+

noremap <leader>t2 :set shiftwidth=2 softtabstop=2<CR>
noremap <leader>t4 :set shiftwidth=4 softtabstop=4<CR>

noremap <Up> :cnext<CR>
noremap <Down> :cprevious<CR>
