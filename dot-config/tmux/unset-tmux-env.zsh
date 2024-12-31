#!/usr/bin/env zsh

if [[ -z "$TMUX_PANE" ]]; then
  return ''
fi

local env_var="$1"
local tmux_pane_index=$(tmux display-message -p '#D' | tr -d %)
local tmux_env_var="$env_var""_""$tmux_pane_index"

tmux setenv -u "$tmux_env_var"
