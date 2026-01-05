# Global Aliases
# These aliases can be used anywhere within a command, not just at the start,
# allowing you to define commonly used arguments or parameters as simple shortcuts.
#
# Usage: Type the alias anywhere in your command line
#
# Example: ls -la NE  →  ls -la 2>/dev/null
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (9:22-11:04)
#
# Note: It's recommended to use UPPERCASE names for global aliases to prevent
#       accidental expansion and make them more visible.

# Redirect stderr to /dev/null (silence errors)
alias -g NE='2>/dev/null'

# Redirect stdout to /dev/null (silence output)
alias -g NUL='>/dev/null 2>&1'

# Pipe to grep
alias -g G='| grep'
alias -g GI='| grep -i'  # case-insensitive grep

# Pipe to less
alias -g L='| less'

# Pipe to head/tail
alias -g H='| head'
alias -g T='| tail'

# Pipe to wc (word count)
alias -g WC='| wc -l'

# Pipe to sort
alias -g S='| sort'
alias -g SN='| sort -n'  # numeric sort
alias -g SR='| sort -r'  # reverse sort

# Pipe to uniq
alias -g U='| uniq'

# Pipe to awk/sed
alias -g A='| awk'
alias -g SE='| sed'

# Pipe to xargs
alias -g X='| xargs'

# Pipe to column for table formatting
alias -g C='| column -t'

# Copy to clipboard (platform-specific)
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias -g CLIP='| pbcopy'
elif command -v xclip &> /dev/null; then
    alias -g CLIP='| xclip -selection clipboard'
elif command -v xsel &> /dev/null; then
    alias -g CLIP='| xsel --clipboard'
fi

# JSON pretty-print (if jq is available)
if command -v jq &> /dev/null; then
    alias -g JSON='| jq .'
    alias -g JSONC='| jq -C .'  # colored output
fi

# First/Last items
alias -g FIRST='| head -1'
alias -g LAST='| tail -1'

# Count occurrences
alias -g COUNT='| sort | uniq -c | sort -rn'

# Remove empty lines
alias -g NONEMPTY='| grep -v "^$"'

# Add your own custom global aliases below:
