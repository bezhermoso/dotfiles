# https://github.com/tinted-theming/tinted-fzf
# atload: Sets the BASE16_FZF_PATH to the installation directory managed by zinit
# This is used by tinted-shell's hook system to load reload the correct colors for FZF when the theme changes
zi ice \
  atload"export BASE16_FZF_PATH=\$(pwd)"
zi load tinted-theming/tinted-fzf

# https://github.com/tinted-theming/tinted-jqp
# atload: Sets the TINTED_FZF_PATH to the installation directory managed by zinit
# This is used by tinted-shell's hook system to load reload the correct colors for FZF when the theme changes
zi ice \
  atload"export TINTED_JQP_PATH=\$(pwd)"
zi load tinted-theming/tinted-jqp

# Export the base16 color values to the shell as environment variables
export BASE16_SHELL_ENABLE_VARS=1
# atload: Sets the BASE16_SHELL_PATH to the installation directory managed by zinit, 
# and sets the theme to gruvbox-material-dark-hard if it is not already set.
# src: Loads the profile helper script that actually sets the colors in the shell
zi ice \
  atload'export BASE16_SHELL_PATH=$(pwd); [[ -z $BASE16_THEME ]] && base16_gruvbox-material-dark-hard' \
  src"profile_helper.sh"
zi load tinted-theming/tinted-shell

# base16 theme picker
zi load bezhermoso/zsh-choose-base16

zi ice atpull"%atclone" atclone"_fix-omz-plugin"
zi snippet OMZP::colored-man-pages
less_termcap[so]="${fg[black]}${bg[yellow]}"



