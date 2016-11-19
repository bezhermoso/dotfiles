autocmd! BufWritePost * Neomake

let g:neomake_logfile = $HOME . '/neomake.log'
let g:neomake_open_list = 2
let g:neomake_javascript_enabled_markers = ['eslint']
let g:neomake_list_height = 5

let g:neomake_javascript_eslint_maker = {
    \ 'args': ['--no-color', '--format', 'compact'],
    \ 'errorformat': '%f: line %l\, col %c\, %m'
    \ }

function! neomake#makers#ft#typescript#tsc() abort
    " tsc should not be passed a single file.  Changing to the file's dir will
    " make it look upwards for a tsconfig.json file.
    return {
        \ 'args': ['--noEmit', '--experimentalDecorators'],
        \ 'append_file': 0,
        \ 'cwd': '%:p:h',
        \ 'errorformat':
            \ '%E%f %#(%l\,%c): error %m,' .
            \ '%E%f %#(%l\,%c): %m,' .
            \ '%Eerror %m,' .
            \ '%C%\s%\+%m'
        \ }
endfunction
