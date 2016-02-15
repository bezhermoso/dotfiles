#!/usr/bin/env zsh

if [[ -z "$TMUX_PANE" ]]; then
  return ''
fi

local tmux_pane_index=$(tmux display-message -p "#D" | tr -d %)

tmux setenv TMUXPWD_$(echo $tmux_pane_index) "$PWD"
tmux setenv TMUX_NODEJS_V_$(echo $tmux_pane_index) "$(node -v)"
tmux setenv TMUX_RUBY_V_$(echo $tmux_pane_index) "$(ruby -e "print RUBY_VERSION")"
tmux setenv TMUX_PHP_V_$(echo $tmux_pane_index) "$(echo '<?php echo PHP_VERSION;' | php)"
tmux setenv TMUX_PYTHON_V_$(echo $tmux_pane_index) "$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
