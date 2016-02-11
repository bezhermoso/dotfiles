#!/usr/bin/env zsh

tmux_session_colors=(white colour248 colour243)
tmux_session_name="   #{session_name}   "

tmux_session_prefix_colors=(colour35 colour41 colour47)


tmux_session_segment="#[fg=$tmux_session_prefix_colors[1],bold,bg=$tmux_session_colors[1]]#{?client_prefix,,$tmux_session_name}"
tmux_session_segment="$tmux_session_segment#[bg=$tmux_session_colors[2]]#{?client_prefix,, }"
tmux_session_segment="$tmux_session_segment#[bg=$tmux_session_colors[3]]#{?client_prefix,, }"

tmux_session_prefix_segment="#[fg=white,bg=$tmux_session_prefix_colors[1]]#{?client_prefix,$tmux_session_name,}"
tmux_session_prefix_segment="$tmux_session_prefix_segment#[bg=$tmux_session_prefix_colors[2]]#{?client_prefix, ,}"
tmux_session_prefix_segment="$tmux_session_prefix_segment#[bg=$tmux_session_prefix_colors[3]]#{?client_prefix, ,}"

tmux_status_left="$tmux_session_segment$tmux_session_prefix_segment#[default]"

tmux display-message -p "$tmux_status_left"

