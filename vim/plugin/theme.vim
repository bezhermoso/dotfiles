
let shell_background=$BACKGROUND


" Default color scheme
let base16colorspace=256
" Access colors present in 256 colorspace
set t_Co=256
" 256 color mode

if !empty($VIM_COLOR)
    colorscheme $VIM_COLOR
else
    colorscheme base16-bright
endif
"let g:airline_theme="term"
let g:airline_theme="base16_mod"
let g:airline_powerline_fonts=0
"let g:airline_symbols={}
"let g:airline_symbols.linenr = '␤'

" COLORS
"hi Search ctermfg=0 ctermbg=11 guifg=Black
"hi LineNr ctermfg=242
"hi Comment ctermfg=245
"hi MatchParen ctermbg=105
"hi TabLineSel ctermbg=24 ctermfg=4
"hi ColorColumn ctermbg=black
if shell_background == 'dark'
"  hi CursorLine cterm=NONE ctermbg=239
endif

hi StartifyHeader ctermfg=6
hi StartifyNumber ctermfg=2
hi StartifyBracket ctermfg=16
hi StartifyFile ctermfg=15
hi StartifyPath ctermfg=8
hi StartifySection ctermfg=4

" let g:gruvbox_italic=1
" "let g:gruvbox_contrast_dark="medium"
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
