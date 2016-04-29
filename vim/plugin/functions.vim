
" Strip trailing whitespace (,ss)
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
"noremap <leader>ss :call StripWhitespace()<CR>

"Another enhanced script from
"http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>x<Space> :call <SID>ExecuteInShell(getline('.'))

" Ident entire file.
function! IndentEntireFile()
  let last_cursor = getpos('.')
  execute "normal! gg=G"
  call setpos('.', last_cursor)
endfunction
nnoremap <leader>= :call IndentEntireFile()<cr>

" https://www.reddit.com/r/vim/comments/4aab93/weekly_vim_tips_and_tricks_thread_1/d0yqb6z
function! SourceVimscript(type)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @"
  if a:type == 'line'
    silent execute "normal! '[V']y"
  elseif a:type == 'char'
    silent execute "normal! `[v`]y"
  elseif a:type == "visual"
    silent execute "normal! gvy"
  elseif a:type == "currentline"
    silent execute "normal! yy"
  endif
  let @" = substitute(@", '\n\s*\\', '', 'g')
  " source the content
  @"
  let &selection = sel_save
  let @" = reg_save
endfunction
nnoremap <silent> g: :set opfunc=SourceVimscript<cr>g@
vnoremap <silent> g: :<c-U>call SourceVimscript("visual")<cr>
nnoremap <silent> g:: :call SourceVimscript("currentline")<cr>

" Toggle between relative & absolute file number
set number
function! NumberToggle()
  if(&relativenumber == 1)
    set relativenumber!
  else
    set relativenumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<CR>

" Convert ```[lang] to {% higlight [lang] %} within range
function! ConvertToLiquidHighlighting() range
  silent! execute a:firstline . "," . a:lastline . 's/^```\([a-z]\+\)$/{% highlight \1 %}/g'
  silent! execute a:firstline . "," . a:lastline . 's/^```$/{% endhighlight %}/g'
endfunction

vnoremap <leader>H :call ConvertToLiquidHighlighting()<cr>
nnoremap <leader>H  :0,$call ConvertToLiquidHighlighting()<cr>

function! s:OpenPlugin(plugin, splittype)
  let dir='~/.dotfiles/vim/plugin/'
  if (a:splittype == 'v')
    execute "vsplit" . dir . a:plugin . ".vim"
  else
    execute "split" . dir . a:plugin . ".vim"
  endif
endfunc
command! -complete=shellcmd -nargs=+ Opp call s:OpenPlugin(<q-args>, "v")
