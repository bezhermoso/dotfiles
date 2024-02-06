if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi

if (( $+commands[pyenv-virtualenv] )); then
  eval "$(pyenv virtualenv-init -)"
fi

export PYTHON_CONFIGURE_OPTS="--enable-framework CC=clang"

# Don't automatically inherit pyenv version in tmux panes
if [[ -n $TMUX_PANE ]] && [[ -n $PYENV_VERSION ]]; then
  PYENV_VERSION=
fi


