
let shell_background=$BACKGROUND


" Default color scheme
let base16colorspace=256
" Access colors present in 256 colorspace
set t_Co=256
" 256 color mode

if !empty($VIM_COLOR)
    colorscheme $VIM_COLOR
else
    colorscheme base16-default-dark
endif

"let g:airline_theme="term"
let g:airline_theme="badcat"
let g:airline_powerline_fonts=0

"let g:airline_symbols={}
"let g:airline_symbols.linenr = '␤'


hi StartifyHeader ctermfg=6
hi StartifyNumber ctermfg=2
hi StartifyBracket ctermfg=16
hi StartifyFile ctermfg=15
hi StartifyPath ctermfg=8
hi StartifySection ctermfg=4

" let g:gruvbox_italic=1
" let g:gruvbox_contrast_dark="medium"
" let g:gruvbox_contrast_light="hard"
" let g:gruvbox_invert_selection=0
" let g:gruvbox_italicize_comments=0
" let g:gruvbox_invert_tabline=1
" let g:gruvbox_invert_indent_guides=1
" let g:gruvbox_invert_signs=1
" colorscheme gruvbox


set background=dark
if shell_background == 'light'
  set background=light
endif

"if &diff
    "colorscheme gruvbox
"endif

" Override the diff-mode highlights of base16.
highlight DiffAdd    term=bold ctermfg=0 ctermbg=2
highlight DiffDelete term=bold ctermfg=0 ctermbg=1
highlight DiffChange ctermfg=0 ctermbg=4 term=none
highlight DiffText   ctermfg=232 ctermbg=3 term=none


hi Search ctermfg=0 ctermbg=4
hi IncSearch ctermfg=0 ctermbg=5
hi CursorLineNr ctermfg=7
hi Error ctermfg=15 cterm=bold,undercurl


" COLORS
"hi LineNr ctermfg=242
"hi Comment ctermfg=245
"hi MatchParen ctermbg=105
"hi TabLineSel ctermbg=24 ctermfg=4
"hi ColorColumn ctermbg=black
if shell_background == 'dark'
"  hi CursorLine cterm=NONE ctermbg=239
endif
