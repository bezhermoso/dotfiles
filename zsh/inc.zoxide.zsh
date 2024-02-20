if (( ! $+commands[zoxide] )); then
  return 0
fi

eval "$(zoxide init zsh --cmd cd)"


# ZLE widget for pulling up interactive zoxide & change directory.
function _zoxide-cd-widget {
  zle push-line
  __zoxide_zi
  zle accept-line
  zle reset-prompt
}

# Bind interactive zoxide widget to Ctrl-H
zle -N _zoxide-cd-widget
bindkey -M vicmd '^h' _zoxide-cd-widget
bindkey -M viins '^h' _zoxide-cd-widget
