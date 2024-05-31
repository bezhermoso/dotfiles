if (( ! $+commands[brew] )); then
  return 0
fi

if [[ -n $HOMEBREW_PREFIX/share/google-cloud-sdk/*.zsh.inc(-.) ]]; then
  source $HOMEBREW_PREFIX/share/google-cloud-sdk/*.zsh.inc(-.)
fi
