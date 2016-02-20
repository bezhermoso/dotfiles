#!/usr/bin/env zsh

source "$HOME/.tmux-statuslinerc"

ruby_colors=(colour52 colour124)
ruby_version=$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_RUBY_V)
ruby_lower_bound=120
ruby_version="${ruby_version:----}"
if [[ -n $ruby_version ]]; then
  ruby_segment="#[bg=$ruby_colors[1],fg=white] RB #[bg=$ruby_colors[2],fg=white] $ruby_version #[default] "
else
  ruby_segment=
fi

node_colors=(colour22 colour28)
node_version="$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_NODEJS_V)"
node_lower_bound=120
node_version="${node_version:----}"
if [[ -n $node_version ]]; then
  node_segment="#[bg=$node_colors[1],fg=white] JS #[bg=$node_colors[2],fg=white] $node_version #[default] "
else
  node_segment=
fi


python_colors=(colour214 colour227)
python_fg=black
python_version=$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_PYTHON_V)
python_lower_bound=120
python_version="${python_version:----}"

if [[ -n $python_version ]]; then
  python_segment="#[bg=$python_colors[1],fg=$python_fg] PY #[bg=$python_colors[2],fg=$python_fg] $python_version #[default] "
else
  python_segment=
fi

php_colors=(colour55 colour61)
php_fg=white
php_lower_bound=120
php_version=$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_PHP_V)
php_version="${php_version:----}"
if [[ -n $python_version ]]; then
  php_segment="#[bg=$php_colors[1],fg=$php_fg] PHP #[bg=$php_colors[2],fg=$php_fg] $php_version #[default] "
else
  php_segment=
fi

tmux_time_colors=(colour24 colour29 colour42)
tmux_time_format="%H:%M:%S"
tmux_date_format="%b %d"
time_segment="#[bg=$tmux_time_colors[3]]#[bg=$tmux_time_colors[1],fg=white] $(date +$tmux_date_format) #[bg=$tmux_time_colors[2],fg=white] $(date +$tmux_time_format) "

# This seems to default always to 80...
local window_width=$(tmux display-message -p "#{window_width}")
local tmux_status_right=""

if [[ $window_width -gt $node_lower_bound ]]; then
  tmux_status_right="$tmux_status_right$node_segment"
fi
if [[ $window_width -gt $ruby_lower_bound ]]; then
  tmux_status_right="$tmux_status_right$ruby_segment"
fi
if [[ $window_width -gt $python_lower_bound ]]; then
  tmux_status_right="$tmux_status_right$python_segment"
fi
if [[ $window_width -gt $php_lower_bound ]]; then
  tmux_status_right="$tmux_status_right$php_segment"
fi


tmux_status_right="$tmux_status_right  $time_segment"
tmux display-message -p "$tmux_status_right"

