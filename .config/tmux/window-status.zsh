#!/usr/bin/env zsh

typeset -A tmux_window_name
typeset -A tmux_window_index
typeset -A tmux_active_window_name
typeset -A tmux_active_window_index

tmux_window_colors=(colour234 colour243 colour240)
tmux_window_name=(content "   #{window_name}   " fg "black")
tmux_window_index=(content " #{window_index} " fg "white")

tmux_active_window_colors=(colour3 colour220 colour228)
tmux_active_window_name=(content "   #{window_name}   " fg "colour232,bold")
tmux_active_window_index=(content " #{window_index} " fg "black")

function tmux_active_window_status_format() {
  format="#[fg=$tmux_active_window_index[fg],bg=$tmux_active_window_colors[1]]$tmux_active_window_index[content]"
  format="$format#[fg=$tmux_active_window_name[fg],bg=$tmux_active_window_colors[2]]$tmux_active_window_name[content]"
  format="$format#[bg=$tmux_active_window_colors[3]] "

  tmux display-message -p "$format"
}

function tmux_window_status_format() {
  format="#[fg=$tmux_window_index[fg],bg=$tmux_window_colors[1]]$tmux_window_index[content]"
  format="$format#[fg=$tmux_window_name[fg],bg=$tmux_window_colors[2]]$tmux_window_name[content]"
  format="$format#[bg=$tmux_window_colors[3]] "

  echo $format;
  #tmux message-style -p "$format"
}

if [[ "$1" == "active" ]]; then
  tmux_active_window_status_format
else
  tmux_window_status_format
fi;
