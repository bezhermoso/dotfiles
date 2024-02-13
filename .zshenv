
export ZDOTDIR="$HOME/.dotfiles/zsh"

# Source zprezto's zshenv if present
local zprezto_zshenv="$ZDOTDIR/.zprezto/runcoms/zshenv"
if [[ -f "$zprezto_zshenv" ]]; then
    source "$zprezto_zshenv"
else
    >&2 echo "Unable to source $zprezto_zshenv: Did you install zprezto?"
fi
