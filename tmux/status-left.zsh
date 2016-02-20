#!/usr/bin/env zsh

tmux_session_colors=(white colour8)
tmux_session_name="   #{session_name}   "

tmux_session_prefix_colors=(colour4 colour8)


tmux_session_segment="#[fg=$tmux_session_prefix_colors[1],bold,bg=$tmux_session_colors[1]]#{?client_prefix,,$tmux_session_name}"
tmux_session_segment="$tmux_session_segment#[bg=$tmux_session_colors[2]]#{?client_prefix,,  }"

tmux_session_prefix_segment="#[fg=white,bg=$tmux_session_prefix_colors[1]]#{?client_prefix,$tmux_session_name,}"
tmux_session_prefix_segment="$tmux_session_prefix_segment#[bg=$tmux_session_prefix_colors[2]]#{?client_prefix,  ,}"

tmux_status_left="$tmux_session_segment$tmux_session_prefix_segment#[default]"

tmux display-message -p "$tmux_status_left"

