
nnoremap z<Space> :Goyo<cr>

let g:goyo_width=120
function! s:goyo_enter()
  set relativenumber
  set number
  set wrap
  "set colorcolumn=80
  set textwidth=79
  set formatoptions=qrn1
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
