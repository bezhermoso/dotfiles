# Undo in Zsh Command Buffer
# Zsh has an undo feature that can revert the last action taken in the command
# buffer, useful for accidental deletions or changes.
#
# Usage: Press Ctrl + _ (Control and underscore) to undo
#        The undo widget is already bound by default in Zsh
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (1:48-2:38)

# Note: The undo widget is already available by default in Zsh
# Default keybindings:
#   - Ctrl + _ (Emacs mode)
#   - u (vi command mode)
#
# You can also bind it to other keys if desired:
# bindkey '^Z' undo
# bindkey '^[u' undo  # Alt+u

# For visibility, we'll ensure the default binding is set
bindkey '^_' undo
