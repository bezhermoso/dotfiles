# SHELL HISTORY WITH atuin: https://github.com/ellie/atuin

# NOTE: Must be registered *after* FZF so that atuin history widgets win
export ATUIN_CONFIG_DIR="$HOME/.dotfiles/atuin"
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh --disable-up-arrow)"
fi


