autocmd! BufWritePost * Neomake

let g:neomake_logfile = $HOME . '/neomake.log'
let g:neomake_open_list = 2
let g:neomake_javascript_enabled_markers = ['eslint']
let g:neomake_list_height = 5

let g:neomake_javascript_eslint_maker = {
    \ 'args': ['--no-color', '--format', 'compact', '--config', '~/.eslintrc.json'],
    \ 'errorformat': '%f: line %l\, col %c\, %m'
    \ }

