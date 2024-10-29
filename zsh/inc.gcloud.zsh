if (( ! $+commands[brew] )); then
  return 0
fi

# If 3.11.4 is installed via pyenv, use it as the Python version for gcloud
if [[ -x $HOME/.pyenv/versions/3.11.4/bin/python ]]; then
  export CLOUDSDK_PYTHON=$HOME/.pyenv/versions/3.11.4/bin/python
fi

if [[ -n $HOMEBREW_PREFIX/share/google-cloud-sdk/*.zsh.inc(-.) ]]; then
  source $HOMEBREW_PREFIX/share/google-cloud-sdk/*.zsh.inc(-.)
fi
