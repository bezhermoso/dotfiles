# Lazy-load pyenv for faster shell startup
if (( $+commands[pyenv] )); then
  export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  export PATH="$PYENV_ROOT/bin:$PATH"

  # Single source of truth: commands that trigger pyenv initialization
  typeset -ga _PYENV_LAZY_COMMANDS
  _PYENV_LAZY_COMMANDS=(pyenv python python3 pip pip3)

  # Shared initialization function - runs once on first command invocation
  _init_pyenv() {
    # Unfunction all lazy-loaded wrappers
    local cmd
    for cmd in $_PYENV_LAZY_COMMANDS; do
      unfunction $cmd 2>/dev/null
    done

    # Initialize pyenv
    eval "$(command pyenv init -)"

    # Initialize pyenv-virtualenv if available
    if (( $+commands[pyenv-virtualenv] )); then
      eval "$(command pyenv virtualenv-init -)"
    fi
  }

  # Dynamically generate wrapper functions
  local cmd
  for cmd in $_PYENV_LAZY_COMMANDS; do
    eval "function $cmd() { _init_pyenv; $cmd \"\$@\" }"
  done
  unset cmd
fi

export PYTHON_CONFIGURE_OPTS="--enable-framework CC=clang"

# Don't automatically inherit pyenv version in tmux panes
if [[ -n $TMUX_PANE ]] && [[ -n $PYENV_VERSION ]]; then
  PYENV_VERSION=
fi


