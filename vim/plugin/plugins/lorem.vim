
if !exists("g:lorem_executable")
  let g:lorem_executable="lorem-ipsum"
endif

if !executable(g:lorem_executable)
  finish
endif

let lorem = {}
function! LoremIpsum(args)
  let cmd = g:lorem_executable
  if type(a:args) == 1
    let cmd = cmd . ' ' . a:args
  endif
  let outlist = systemlist(cmd)
  let outlist_copy = copy(outlist)
  call filter(outlist_copy, 'strlen(v:val) > 0')
  if len(outlist_copy) == 1
    return outlist_copy[0]
  else
    return outlist
  endif
endfunction

function! LoremIpsumInsert(args)
  let ln = line('.')
  let col = col('.')
  let output = LoremIpsum(a:args)
  put =output
endfunction

command! -nargs=* Lorem call LoremIpsumInsert('<args>')
