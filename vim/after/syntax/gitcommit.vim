let s:commentchar = systemlist("git config --list 2>/dev/null | grep -i '^core.commentchar' | awk -F= '{print $2}'")

if !empty(s:commentchar)
  let s:git_comment_syntax = "syn match gitcommitComment \"^" . s:commentchar[0] . ".*\""
  exec s:git_comment_syntax
endif
