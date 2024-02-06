
## TMUX CONFIGURATION
export TMUX_CONFIG_DIR="$HOME/.dotfiles/tmux"

function tmuxp() {
  local _command=$@
  if [[ $1 == 'load' ]]
  then
    _command="$_command --yes"
  fi

  eval "command tmuxp $_command"
}

compinit -U tmuxp

