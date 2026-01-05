# zmv - Advanced Move/Rename Command
# An advanced move command for batch renaming or moving files using powerful
# pattern matching. Think of it as a programmable mv command with regex support.
#
# Usage: zmv [options] pattern replacement
#
# Common options:
#   -n  Dry run (show what would be done without doing it)
#   -i  Interactive mode (ask before each move)
#   -v  Verbose (show each move as it happens)
#   -w  Enable wildcard mode (simpler syntax, no need for parentheses)
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (11:04-13:08)

# Enable zmv
autoload -Uz zmv

# Examples:
#
# Rename .log files to .txt:
#   zmv '(*).log' '$1.txt'
#
# Add prefix to all .jpg files:
#   zmv '(*).jpg' 'photo-$1.jpg'
#
# Change case (lowercase to uppercase):
#   zmv '(*)' '${(U)1}'
#
# With wildcard mode (-w), syntax is simpler:
#   zmv -w '*.log' '*.txt'
#   zmv -w '*.jpg' 'photo-*.jpg'
#
# Dry run first to see what will happen:
#   zmv -n '(*).log' '$1.txt'
#
# Interactive mode for safety:
#   zmv -i '(*).log' '$1.txt'

# Also enable zcp and zln (copy and link equivalents)
autoload -Uz zcp
autoload -Uz zln

# Convenience aliases
alias zmv='zmv -v'    # Always be verbose by default
alias zcp='zcp -v'    # Verbose copy
alias zln='zln -v'    # Verbose link

# Alternative: Create a wrapper for safer zmv (always dry-run first)
# zmv-safe() {
#     echo "Dry run:"
#     zmv -n "$@"
#     echo ""
#     read "response?Proceed with these changes? [y/N] "
#     if [[ "$response" =~ ^[Yy]$ ]]; then
#         zmv "$@"
#     else
#         echo "Cancelled."
#     fi
# }
