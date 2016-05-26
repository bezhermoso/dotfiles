#!/usr/bin/env zsh

tmux_session_colors=(white colour8)
tmux_session_name=" #{session_name} "

tmux_session_prefix_colors=(colour29 colour29)

tmux_session_segment="#[fg=$tmux_session_prefix_colors[1],bold]#{?client_prefix,,($tmux_session_name)}"
tmux_session_segment="$tmux_session_segment#{?client_prefix,,}"

tmux_session_prefix_segment="#[bg=$tmux_session_prefix_colors[2],fg=colour232,bold]#{?client_prefix, $tmux_session_name ,}"
tmux_session_prefix_segment="$tmux_session_prefix_segment#{?client_prefix,,}"

tmux_status_left="$tmux_session_segment$tmux_session_prefix_segment#[default]  "

tmux display-message -p "$tmux_status_left"

