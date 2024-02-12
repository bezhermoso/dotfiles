
export ZDOTDIR="$HOME/.dotfiles/zsh"

# Source zprezto's env
local zprezto_zshenv="$HOME/.dotfiles/zsh/.zprezto/runcoms/zshenv"
if [[ -f "$zprezto_zshenv" ]]; then
    source "$zprezto_zshenv"
else
    >&2 echo "Unable to source $zprezto_zshenv: Did you clone zprezto?"
fi