# Edit Command Buffer in $EDITOR
# Allows you to open the current command buffer in your configured text editor
# (e.g., Neovim) to easily correct mistakes or modify long commands using
# your editor's keybindings.
#
# Usage: Press Ctrl+X Ctrl+E to open the current command line in your editor
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (0:41-1:47)

# Load the edit-command-line widget
autoload -Uz edit-command-line

# Create a ZLE widget from the function
zle -N edit-command-line

# Bind Ctrl+X Ctrl+E to edit the command line
bindkey '^X^E' edit-command-line
