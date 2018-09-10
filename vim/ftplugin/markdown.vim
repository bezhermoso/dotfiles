
nnoremap <leader>h1<Space> yypV$r=
nnoremap <leader>h2<Space> yypV$r-
nnoremap <leader>h3<Space> I### <esc>
nnoremap <leader>h4<Space> I#### <esc>
nnoremap <leader>h5<Space> I##### <esc>
nnoremap <leader>h6<Space> I###### <esc>
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
"nnoremap <leader>H<Space> :HeaderDecrease<cr>
"nnoremap <leader>h<Space> :HeaderDecrease<cr>
inoremap <buffer> <Plug>SparkupExecute <c-g>u<Esc>:call <SID>Sparkup()<cr>
inoremap <buffer> <Plug>SparkupNext    <c-g>u<Esc>:call <SID>SparkupNext()<cr>

