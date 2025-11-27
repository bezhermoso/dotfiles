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

# Bind interactive zoxide widget to Ctrl-U
zle -N _zoxide-cd-widget
bindkey -M vicmd '^u' _zoxide-cd-widget
bindkey -M viins '^u' _zoxide-cd-widget

# ZLE widget for popping out of the dirstack incrementally
function _popd-widget {
  zle push-line
  popd 2>/dev/null
  if [[ "$?" -gt 0 ]]; then
      echo -n "\ndirstack is empty!"
  fi
  zle accept-line
}

zle -N _popd-widget
bindkey -M vicmd '^h' _popd-widget
bindkey -M viins '^h' _popd-widget


function _zoxide-insert-widget {
  local dir=$(zoxide query -i)
  ((CURSOR = $CURSOR + ${#dir}))
  if [[ -n $dir ]]; then
    LBUFFER+="${dir}"
  fi
  zle reset-prompt
}

zle -N _zoxide-insert-widget
bindkey -M viins "^g^g" _zoxide-insert-widget
