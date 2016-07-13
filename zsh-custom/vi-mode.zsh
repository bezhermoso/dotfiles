#antigen bundle vi-mode
export POWERLINE_DEFAULT_MODE=viins
bindkey -v
bindkey -M vicmd 'v' edit-command-line
bindkey "^R" history-incremental-search-backward

function zle-line-init zle-keymap-select {
  #setopt localoptions no_ksharrays
  #[[ "${@[2]-}" == opp ]] && return
  #zle reset-prompt
  zle -R
}
# allow v to edit the command line (standard behaviour)
#zle -N zle-line-finish
#zle -N zle-keymap-select
#zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select
autoload -Uz edit-command-line

#export KEYTIMEOUT=2
