
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


# ZLE widget for pulling up interactive zoxide & change directory.
function _tmux-picker-widget {
  zle push-line
  ~/.config/tmux/picker.zsh <>$TTY
  zle accept-line
}

# Bind interactive zoxide widget to Ctrl-U
zle -N _tmux-picker-widget
bindkey -M vicmd '^s^s' _tmux-picker-widget
bindkey -M viins '^s^s' _tmux-picker-widget
