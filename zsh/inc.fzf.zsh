## FZF (Fuzzy Finder) CONFIGURATION
#

export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='
  --no-mouse --margin=0,0,0,1
  --prompt="› "
  --tabstop=2
  -1
  --preview="[[ -d {} ]] && tree -L 1 {} || bat --style=numbers --color=always --line-range=:500 {}"
'
export FZF_CTRL_R_OPTS='--preview=""'

# Use rg to back Ctrl+T fzf interactive file search. Don't --follow, broken symlinks are OK.
export FZF_CTRL_T_COMMAND='rg --files --no-ignore-vcs --hidden --glob "!.git/*"'

eval "$(fzf --zsh)"

# FZF binds the fzf-cd-widget to Alt-C, but doesn't work in iTerm2 w/o further setup. Bind it to Ctrl-Y for now.
zle     -N            fzf-cd-widget
bindkey -M vicmd '^Y' fzf-cd-widget
bindkey -M viins '^Y' fzf-cd-widget
