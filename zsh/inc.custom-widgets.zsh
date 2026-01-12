# Custom Widgets
# Widgets are functions that perform actions in the terminal and command-line
# buffer. You can define custom ones and bind them to key combinations.
#
# Process:
#   1. Define a function
#   2. Use zle -N to create a widget from it
#   3. Use bindkey to assign a hotkey
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (14:04-15:19)

# Example from the video: Clear history but keep command buffer
clear-history-keep-buffer() {
    # Reset the prompt (redraw)
    zle reset-prompt
    # Print the current buffer back to the line editor (-z flag)
    print -z $BUFFER
    # Move cursor to end of line
    zle end-of-line
    # Clear the history
    history -c
}
# Create widget and bind to Ctrl+X l
zle -N clear-history-keep-buffer
bindkey '^Xl' clear-history-keep-buffer

# Example: Prepend 'sudo' to current command
prepend-sudo() {
    if [[ $BUFFER != "sudo "* ]]; then
        BUFFER="sudo $BUFFER"
        # Move cursor to end of line
        zle end-of-line
    fi
}
zle -N prepend-sudo
bindkey '^Xs' prepend-sudo

# Example: Quote current command (wrap in quotes)
quote-command() {
    if [[ -n $BUFFER ]]; then
        BUFFER="'$BUFFER'"
    fi
}
zle -N quote-command
bindkey '^Xq' quote-command

# Example: Clear screen but keep scrollback
clear-screen-keep-scrollback() {
    printf '\033c'
    zle reset-prompt
}
zle -N clear-screen-keep-scrollback
bindkey '^X^L' clear-screen-keep-scrollback

# Example: Copy command to clipboard (platform-specific)
copy-command-to-clipboard() {
    if [[ -n $BUFFER ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            print -rn $BUFFER | pbcopy
        elif command -v xclip &> /dev/null; then
            print -rn $BUFFER | xclip -selection clipboard
        elif command -v xsel &> /dev/null; then
            print -rn $BUFFER | xsel --clipboard
        fi
        # Show feedback
        zle -M "Command copied to clipboard"
    fi
}
zle -N copy-command-to-clipboard
bindkey '^Xc' copy-command-to-clipboard

# Useful widget variables:
# $BUFFER      - The entire command line buffer
# $LBUFFER     - Left of cursor (beginning to cursor)
# $RBUFFER     - Right of cursor (cursor to end)
# $CURSOR      - Current cursor position
# $HISTNO      - Current history number

# Useful widget commands:
# zle reset-prompt         - Redraw the prompt
# zle end-of-line          - Move cursor to end
# zle beginning-of-line    - Move cursor to beginning
# zle clear-screen         - Clear the screen
# zle -M "message"         - Display a message

# Add your own custom widgets below:
