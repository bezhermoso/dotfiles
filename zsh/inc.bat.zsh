# https://github.com/sharkdp/bat

export BAT_CONFIG_PATH=$HOME/.dotfiles/bat/config
if (( $+commands[bat] )); then
  alias cat="bat --paging=never"
fi

if (( $+commands[batman] )); then
  # DO NOT SET BAT_PAGER! It will cause infinite recursion.
  #export BAT_PAGER='less -R'
  alias man="batman"
fi

function batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

alias bathelp='bat --plain --language=help'
function help() {
    "$@" --help 2>&1 | bathelp
}

