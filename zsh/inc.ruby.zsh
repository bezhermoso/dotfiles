# Lazy-load rbenv for faster shell startup
if (( $+commands[rbenv] )); then
  export RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
  export PATH="$RBENV_ROOT/bin:$PATH"

  # Single source of truth: commands that trigger rbenv initialization
  typeset -ga _RBENV_LAZY_COMMANDS
  _RBENV_LAZY_COMMANDS=(rbenv ruby gem bundle)

  # Shared initialization function - runs once on first command invocation
  _init_rbenv() {
    # Unfunction all lazy-loaded wrappers
    local cmd
    for cmd in $_RBENV_LAZY_COMMANDS; do
      unfunction $cmd 2>/dev/null
    done

    # Initialize rbenv
    eval "$(command rbenv init -)"
  }

  # Dynamically generate wrapper functions
  local cmd
  for cmd in $_RBENV_LAZY_COMMANDS; do
    eval "function $cmd() { _init_rbenv; $cmd \"\$@\" }"
  done
  unset cmd
fi
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

