# Lazy-load nodenv for faster shell startup
if (( $+commands[nodenv] )); then
  export NODENV_ROOT="${NODENV_ROOT:-$HOME/.nodenv}"
  export PATH="$NODENV_ROOT/bin:$PATH"

  # Single source of truth: commands that trigger nodenv initialization
  typeset -ga _NODENV_LAZY_COMMANDS
  _NODENV_LAZY_COMMANDS=(nodenv node npm npx)

  # Shared initialization function - runs once on first command invocation
  _init_nodenv() {
    # Unfunction all lazy-loaded wrappers
    local cmd
    for cmd in $_NODENV_LAZY_COMMANDS; do
      unfunction $cmd 2>/dev/null
    done

    # Initialize nodenv
    eval "$(command nodenv init -)"
  }

  # Dynamically generate wrapper functions
  local cmd
  for cmd in $_NODENV_LAZY_COMMANDS; do
    eval "function $cmd() { _init_nodenv; $cmd \"\$@\" }"
  done
  unset cmd
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Lazy-load nvm
#function nvm() {
  #if [[ -z $NVM_DIR ]]; then
    #export NVM_DIR="/Users/bez/.nvm"
    #source "$NVM_DIR/nvm.sh"
    #nvm $@
  #fi
#}

