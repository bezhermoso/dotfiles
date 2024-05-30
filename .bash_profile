# vim: filetype=sh

if [[ -f $HOME/.dotfiles/bash/work.bash_profile ]]; then
    source $HOME/.dotfiles/bash/work.bash_profile
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
