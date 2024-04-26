#!/usr/bin/env zsh

local script_dir="${0:a:h}"

# This script modifies the styles depending on # of windows and # of panes
local hook_script_path="${script_dir}/set-dynamic-styles.zsh"

# The tmux hooks that influence the # of windows or # of panes
local hooks=(
    "after-new-window"
    "after-kill-pane"
    "window-pane-changed"
)

for hook in $hooks[@]; do
    tmux set-hook -g $hook 'run-shell '${hook_script_path}
done

source $hook_script_path

