
if !executable("lorem-ipsum")
  finish
endif

function! InsertLoremIpsum(args)
  let cline = line('.')
  let ccolumn = col('.')
  execute append(line('.'), LoremIpsum(a:args))
  call cursor(cline, ccolumn)
endfunction


" Our interface to the `lorem` executable.
function! LoremIpsum(args)
  return systemlist("lorem-ipsum " . a:args)
endfunction

command! -nargs=* Lorem call InsertLoremIpsum('<args>')
