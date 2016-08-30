
if !exists("g:lorem_executable")
  let g:lorem_executable="lorem-ipsum"
endif

if !executable(g:lorem_executable)

  finish
endif

function! LoremIpsum(args)
  let cmd = g:lorem_executable
  if type(a:args) == 1
    let cmd = cmd . ' ' . a:args
  endif
  return systemlist(cmd)
endfunction

function! LoremIpsumInsert(args)
  let outlist = LoremIpsum(a:args)
  let outlist_copy = copy(outlist)
  call filter(outlist_copy, 'strlen(v:val) > 0')
  if len(outlist_copy) == 1
    put =outlist_copy[0]
  else
    put =outlist
  endif
endfunction

command! -nargs=* Lorem call LoremIpsumInsert('<args>')

