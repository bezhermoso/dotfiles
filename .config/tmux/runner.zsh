#!/usr/bin/env zsh

declare -a display_menu_opts

display_menu_opts=()


local num_panes=$(tmux display-message -p '#{window_panes}')
if [[ $num_panes -eq 1 ]]; then
    display_menu_opts+=(
        "Run in new pane below"
        "j"
        "split-window -fvd; paste-buffer -t '{down-of}'; send-keys -t '{down-of}' Enter"
    )
    display_menu_opts+=(
        "Run in new pane to the right"
        "l"
        "split-window -fhd; paste-buffer -t '{right-of}'; send-keys -t '{right-of}' Enter"
    )
fi

if [[ $num_panes -eq 2 ]]; then
    display_menu_opts+=(
        "Paste & move to the other pane"
        "j"
        "paste-buffer -t '!'; select-pane -t '!'"
    )
    display_menu_opts+=(
        "Run in other pane"
        "Enter"
        "paste-buffer -t '!'; send-keys -t '!' Enter"
    )
fi
# vim

# test '; display-message Hello

local cmd_to_run="$(tmux show-buffer)"
local cmd_preview=${cmd_to_run:0:50}

if [[ $cmd_to_run != $cmd_preview ]]; then
    cmd_preview="${cmd_preview} ..."
fi

tmux display-menu -- \
  "-Command: ${cmd_preview}" '' '' \
  $display_menu_opts \
  "Run in popup" p "popup $cmd_to_run"
