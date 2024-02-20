if (( ! $+commands[zoxide] )); then
  return 0
fi

eval "$(zoxide init zsh --cmd cd)"


# ZLE widget for pulling up interactive zoxide & change directory.
function _zoxide-cd-widget {
  zle push-line
  __zoxide_zi
  zle accept-line
}

# ZLE widget for pulling up interactive zoxide & change directory.
function _popd-widget {
  zle push-line
  popd 2>/dev/null
  if [[ "$?" -gt 0 ]]; then
      echo "\ndirstack is empty!"
  fi
  zle accept-line
}


# Bind interactive zoxide widget to Ctrl-H
zle -N _zoxide-cd-widget
zle -N _popd-widget
bindkey -M vicmd '^u' _zoxide-cd-widget
bindkey -M viins '^u' _zoxide-cd-widget

bindkey -M vicmd '^h' _popd-widget
bindkey -M viins '^h' _popd-widget

