#!/usr/bin/env zsh

local cmd_to_run=$@

declare -a display_menu_opts

display_menu_opts=()


local num_panes=$(tmux display-message -p '#{window_panes}')
if [[ $num_panes -eq 1 ]]; then
    display_menu_opts+=("Run in new pane (below)" "Enter" "split-window -fvd; send-keys -t '{down-of}' '$cmd_to_run'")
fi

if [[ $num_panes -eq 2 ]]; then
    display_menu_opts+=("Paste & move to the other pane" "j" "send-keys -t '!' '$cmd_to_run'; select-pane -t '!'")
    display_menu_opts+=("Run in other pane" "Enter" "send-keys -t '!' '$cmd_to_run' Enter")
fi
# vim

test '; display-message Hello

tmux display-menu -- \
  "-Command: ${cmd_to_run:0:50}..." '' '' \
  $display_menu_opts \
  "Run in popup" p "popup $cmd_to_run"
