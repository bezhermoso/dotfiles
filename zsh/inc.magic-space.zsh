# Magic Space
# Expands historical commands or references to show their full content before
# execution, preventing accidental runs of unknown commands.
#
# Usage: Type a history expansion (like !!, !$, !*, etc.) and press Space
#        The expansion will be replaced with the actual command
#
# Example: Type "sudo !!" and press Space - the !! will expand to show
#          the previous command instead of executing blindly
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (2:39-4:02)

# Bind the magic-space widget to the space key
# This performs history expansion when you press space
bindkey ' ' magic-space

# You can also keep the normal space behavior for other uses:
# bindkey '^[' magic-space  # Use Alt+Space for magic-space instead
