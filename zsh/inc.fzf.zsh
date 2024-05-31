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

if (( ! $+commands[fzf] )); then
  return 0
fi

eval "$(fzf --zsh)"

# FZF binds the fzf-cd-widget to Alt-C, but doesn't work in iTerm2 w/o further setup. Bind it to Ctrl-Y for now.
zle     -N            fzf-cd-widget
bindkey -M vicmd '^Y' fzf-cd-widget
bindkey -M viins '^Y' fzf-cd-widget

# https://github.com/Aloxaf/fzf-tab
# Use tmux popup
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# Don't show any preview in FZF picker for kubectl completions
zstyle ':fzf-tab:complete:*' fzf-flags '--no-preview'
zstyle ':fzf-tab:complete:*' popup-min-size 50 0
zi load Aloxaf/fzf-tab

# https://github.com/junegunn/fzf-git.sh
zi load junegunn/fzf-git.sh

