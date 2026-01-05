# Suffix Aliases
# Similar to regular aliases, but they run based on a file's suffix (extension).
# This allows you to open a file with a configured command simply by typing
# the filename.
#
# Usage: Just type the filename and press Enter. Zsh will open it with the
#        associated command based on the file extension.
#
# Example: Type "README.md" and it will open in your configured viewer
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (7:38-9:22)

# Markdown files - open with bat (if available) or cat
if command -v bat &> /dev/null; then
    alias -s md=bat
    alias -s markdown=bat
else
    alias -s md=cat
    alias -s markdown=cat
fi

# Text files - open in $EDITOR
alias -s txt=$EDITOR

# JSON files - open with jq (if available) or $EDITOR
if command -v jq &> /dev/null; then
    alias -s json='jq .'
else
    alias -s json=$EDITOR
fi

# YAML files - open in $EDITOR
alias -s yaml=$EDITOR
alias -s yml=$EDITOR

# Source code files - open in $EDITOR
alias -s go=$EDITOR
alias -s rs=$EDITOR
alias -s py=$EDITOR
alias -s js=$EDITOR
alias -s ts=$EDITOR
alias -s jsx=$EDITOR
alias -s tsx=$EDITOR
alias -s c=$EDITOR
alias -s cpp=$EDITOR
alias -s h=$EDITOR
alias -s java=$EDITOR
alias -s rb=$EDITOR
alias -s php=$EDITOR
alias -s sh=$EDITOR
alias -s zsh=$EDITOR
alias -s bash=$EDITOR

# Config files - open in $EDITOR
alias -s conf=$EDITOR
alias -s config=$EDITOR
alias -s ini=$EDITOR
alias -s toml=$EDITOR

# HTML files - open in browser (xdg-open on Linux, open on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias -s html=open
elif command -v xdg-open &> /dev/null; then
    alias -s html=xdg-open
fi

# PDF files - open in default PDF viewer
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias -s pdf=open
elif command -v xdg-open &> /dev/null; then
    alias -s pdf=xdg-open
fi

# Image files - open in default image viewer
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias -s {png,jpg,jpeg,gif,bmp,svg}=open
elif command -v xdg-open &> /dev/null; then
    alias -s {png,jpg,jpeg,gif,bmp,svg}=xdg-open
fi

# Archive files - list contents
if command -v unzip &> /dev/null; then
    alias -s zip='unzip -l'
fi

if command -v tar &> /dev/null; then
    alias -s {tar,tar.gz,tgz,tar.bz2,tbz2,tar.xz,txz}='tar -tvf'
fi

# Add your own custom suffix aliases below:
