# Conditional Ruby Version Manager
# Uses MY_RUBY_VERSION_MANAGER env var, or auto-detects based on machine type
#
# Detection priority:
#   1. Explicit env var MY_RUBY_VERSION_MANAGER if set
#   2. Auto-detect: work machine (hostname ^block-.*) → rvm
#   3. Fallback: rbenv

# Work machine detection (reuse pattern from inc.work-config.zsh)
_WORK_HOSTNAME_PATTERN="^block-.*"

_detect_ruby_version_manager() {
  # Explicit override takes priority
  if [[ -n "$MY_RUBY_VERSION_MANAGER" ]]; then
    echo "$MY_RUBY_VERSION_MANAGER"
    return
  fi

  # Auto-detect: work machines use RVM
  if [[ "$(hostname)" =~ $_WORK_HOSTNAME_PATTERN ]]; then
    echo "rvm"
    return
  fi

  # Default: rbenv
  echo "rbenv"
}

_RUBY_VERSION_MANAGER=$(_detect_ruby_version_manager)

# ============================================================================
# RBENV (default for personal machines)
# ============================================================================
if [[ "$_RUBY_VERSION_MANAGER" == "rbenv" ]] && (( $+commands[rbenv] )); then
  export RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
  export PATH="$RBENV_ROOT/bin:$PATH"

  typeset -ga _RBENV_LAZY_COMMANDS
  _RBENV_LAZY_COMMANDS=(rbenv ruby gem bundle irb)

  _init_rbenv() {
    local cmd
    for cmd in $_RBENV_LAZY_COMMANDS; do
      unfunction $cmd 2>/dev/null
    done
    eval "$(command rbenv init -)"
  }

  local cmd
  for cmd in $_RBENV_LAZY_COMMANDS; do
    eval "function $cmd() { _init_rbenv; $cmd \"\$@\" }"
  done
  unset cmd

# ============================================================================
# RVM (for work machines)
# ============================================================================
elif [[ "$_RUBY_VERSION_MANAGER" == "rvm" ]] && [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  export PATH="$PATH:$HOME/.rvm/bin"

  typeset -ga _RVM_LAZY_COMMANDS
  _RVM_LAZY_COMMANDS=(rvm ruby gem bundle irb)

  _init_rvm() {
    local cmd
    for cmd in $_RVM_LAZY_COMMANDS; do
      unfunction $cmd 2>/dev/null
    done
    source "$HOME/.rvm/scripts/rvm"
  }

  local cmd
  for cmd in $_RVM_LAZY_COMMANDS; do
    eval "function $cmd() { _init_rvm; $cmd \"\$@\" }"
  done
  unset cmd
fi

# Cleanup
unset _RUBY_VERSION_MANAGER
unfunction _detect_ruby_version_manager 2>/dev/null
