#!/usr/bin/env zsh

local script_dir="${0:a:h}"
local num_windows=$(tmux display-message -p "#{session_windows}")

if [[ $num_windows -lt 2 ]]; then
    tmux set -g status on
else
    tmux set -g status 2
fi

local num_panes=$(tmux display-message -p "#{window_panes}")

if [[ $num_panes -lt 2 ]]; then
    tmux set -sg pane-border-format ''
else
    tmux set -g pane-border-format \
        '#[align=right]#{?window_zoomed_flag,#[bg=color18]#[fg=color16] 󰩨 #[default],}#{?pane_active,#[bg=color16]#[fg=color15]#[bold],#[fg=color16]} #{pane_index} #[default]'
fi
