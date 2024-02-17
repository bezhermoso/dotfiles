# Coerce 256-bit terminal colorspace
#export TERM='xterm-256color'
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo:$HOME/.dotfiles/terminfo

## Setup terminal colors first. I use base16-shell
#
# Tells base16-shell to export colors as BASE16_COLOR_*_HEX.
# Some scripts rely on this e.g. delta hook
export BASE16_SHELL_ENABLE_VARS=1

BASE16_SHELL_PATH="$HOME/.dotfiles/base16-shell"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL_PATH/profile_helper.sh" ] && \
    source "$BASE16_SHELL_PATH/profile_helper.sh"

export BASE16_FLAVOR=${BASE16_FLAVOR:-"gruvbox-dark-hard"}
[ -z $BASE16_THEME ] && eval "base16_{$BASE16_FLAVOR}"

source $HOME/.dotfiles/zsh/colorscheme.zsh

if [[ -f $HOME/.dotfiles/base16-fzf/.git ]]; then
  export BASE16_FZF_PATH="$HOME/.dotfiles/base16-fzf"
fi


