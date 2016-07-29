#!/usr/bin/env zsh

source "$HOME/.tmux-statuslinerc"

sep="❮"
ruby_colors=(colour52 colour1)
ruby_version=$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_RUBY_V)
ruby_lower_bound=120
ruby_version="${ruby_version:----}"
if [[ -n $ruby_version ]]; then
  ruby_segment="#[fg=$ruby_colors[2]]〈 rb=$ruby_version#[default]"
else
  ruby_segment=
fi

node_colors=(colour22 colour29)
node_version="$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_NODEJS_V)"
node_lower_bound=120
node_version="${node_version:----}"
if [[ -n $node_version ]]; then
  node_segment="#[fg=$node_colors[2]]〈 js=$node_version#[default]"
else
  node_segment=
fi


python_colors=(colour208 colour227)
python_fg=black
python_version=$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_PYTHON_V)
python_lower_bound=120
python_version="${python_version:----}"

if [[ -n $python_version ]]; then
  python_segment="#[fg=$python_colors[1]]〈 py=$python_version#[default]"
else
  python_segment=
fi

php_colors=(colour63 colour99)
php_fg=white
php_lower_bound=120
php_version=$($TMUX_CONFIG_DIR/get-tmux-env.zsh TMUX_PHP_V)
php_version="${php_version:----}"
if [[ -n $python_version ]]; then
  php_segment="#[fg=$php_colors[1]]〈 php=$php_version#[default]"
else
  php_segment=
fi

tmux_time_colors=(colour24 colour29 colour42)
tmux_time_format="%H:%M"
tmux_date_format="%b %d"

time_segment="#[fg=$tmux_time_colors[3]] ● $(date +$tmux_date_format) #[fg=$tmux_time_colors[3]]$(date +$tmux_time_format) "

$power_segment=""
#local battery_level
#fully_charged=$(system_profiler SPPowerDataType | grep "Fully Charged" | awk '{print $3}')
#charging=$(system_profiler SPPowerDataType | grep "Charging" | awk '{print $2}' | head -1)


#if [[ "$fully_charged" == "Yes" ]]; then
  #battery_level=100
#else
  #battery_capacity=$(system_profiler SPPowerDataType | grep "Full Charge Capacity" | awk '{print $5}')
  #current_charge=$(system_profiler SPPowerDataType | grep "Charge Remaining" | awk '{print $4}')
  #battery_level=$(((current_charge * 100 / battery_capacity)))
#fi

#battery_color=colour6

#if [[ $battery_level -le 60 ]]; then
  #battery_color=colour208
#fi

#if [[ $battery_level -le 20 ]]; then
  #battery_color=colour1
#fi

#charging_indicator=' '
#if [[ "$charging" == "Yes" ]]; then
  #charging_indicator="+"
#fi

#power_segment="#[fg=$battery_color]❮$charging_indicator$battery_level%%#[default]"

# This seems to default always to 80...
local window_width=$(tmux display-message -p "#{window_width}")
local tmux_status_right=""

tmux_status_right=""

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


tmux_status_right="$tmux_status_right $power_segment$time_segment"
tmux display-message -p "$tmux_status_right"

