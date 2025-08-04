
function _tinty-cycle-widget() {
  zle push-line
  tinty cycle
  zle accept-line
}

zle -N _tinty-cycle-widget
bindkey -M vicmd '^[t' _tinty-cycle-widget
bindkey -M viins '^[t' _tinty-cycle-widget
