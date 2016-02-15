#!/usr/bin/env zsh

local env_var="$1"

tmux_pane_index=$(tmux display-message -p "#D" | tr -d %)
tmux_env_var="$env_var"
tmux_env_var="$env_var""_""$tmux_pane_index"


tmux_env_val=$(tmux show-environment | grep $tmux_env_var)

if [[ -n $tmux_env_val ]]; then
  export $tmux_env_val
  eval echo \$$tmux_env_var
else
  echo ''
fi
