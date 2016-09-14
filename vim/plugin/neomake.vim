autocmd! BufWritePost * Neomake

let g:neomake_logfile = $HOME . '/neomake.log'
let g:neomake_open_list = 2
let g:neomake_javascript_enabled_markers = ['eslint']
let g:neomake_list_height = 5

let g:neomake_javascript_eslint_maker = {
    \ 'args': ['--no-color', '--format', 'compact'],
    \ 'errorformat': '%f: line %l\, col %c\, %m'
    \ }

function! neomake#makers#ft#typescript#tsc()
    return {
                \ 'args': [
                \ '-m', 'commonjs',
                \ '--noEmit', '--experimentalDecorators',
                \ '--target', 'es6'
                \ ],
                \ 'errorformat':
                \ '%E%f %#(%l\,%c): error %m,' .
                \ '%E%f %#(%l\,%c): %m,' .
                \ '%Eerror %m,' .
                \ '%C%\s%\+%m'
                \ }
endfunction
