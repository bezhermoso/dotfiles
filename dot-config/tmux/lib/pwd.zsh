function tmux_get_pwd() {
  tmux_pane_index=$(tmux display-message -p "#D" | tr -d %) tmux_pwd_env=TMUXPWD_$tmux_pane_index
  tmux_pwd=$(tmux show-environment $tmux_pwd_env)
  echo $tmux_pwd;
}

autoload -Uz tmux_get_pwd
