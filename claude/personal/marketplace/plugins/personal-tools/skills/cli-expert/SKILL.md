---
name: cli-expert
description: Command-line interface expertise, shell scripting (Bash/Zsh), terminal tools, and Unix utilities. Specializes in Zsh configuration and scripting.
---

# CLI & Shell Scripting Expert

Expert knowledge for command-line interfaces, shell scripting, and terminal tools with specialty in Zsh.

## Zsh Expertise

### Zsh Configuration Architecture

**File Load Order:**
1. `/etc/zshenv` - System-wide environment
2. `~/.zshenv` - **Always loaded first** - Set $ZDOTDIR here
3. `~/.zprofile` - Login shells only (before .zshrc)
4. `~/.zshrc` - Interactive shells (most config goes here)
5. `~/.zlogin` - Login shells (after .zshrc)
6. `~/.zlogout` - On logout

**Best Practice Structure:**
```bash
# ~/.zshenv - Minimal, always loaded
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export EDITOR="nvim"
export PAGER="less"

# $ZDOTDIR/.zshrc - Interactive config
# Load in this order:
source "$ZDOTDIR/options.zsh"      # Shell options
source "$ZDOTDIR/completion.zsh"   # Completion config
source "$ZDOTDIR/keybindings.zsh"  # Key bindings
source "$ZDOTDIR/aliases.zsh"      # Aliases
source "$ZDOTDIR/functions.zsh"    # Functions
source "$ZDOTDIR/plugins.zsh"      # Plugin manager (zinit, etc.)
source "$ZDOTDIR/prompt.zsh"       # Prompt config (last)
```

### Zsh Options

**Enable recommended options:**
```zsh
# History
setopt APPEND_HISTORY          # Append to history
setopt SHARE_HISTORY           # Share history between sessions
setopt HIST_IGNORE_DUPS        # Don't record duplicates
setopt HIST_IGNORE_SPACE       # Don't record commands starting with space
setopt HIST_VERIFY             # Show history expansion before executing

# Directory navigation
setopt AUTO_CD                 # cd by typing directory name
setopt AUTO_PUSHD              # Push directories to stack
setopt PUSHD_IGNORE_DUPS       # Don't push duplicates
setopt PUSHD_SILENT            # Don't print stack after pushd/popd

# Completion
setopt AUTO_MENU               # Show menu on ambiguous completion
setopt COMPLETE_IN_WORD        # Complete from cursor position
setopt ALWAYS_TO_END           # Move cursor to end after completion

# Expansion & Globbing
setopt EXTENDED_GLOB           # Extended globbing patterns
setopt GLOB_DOTS               # Include dotfiles in globs (without leading .)
setopt NUMERIC_GLOB_SORT       # Sort numerically when possible

# Job Control
setopt NO_BG_NICE              # Don't nice background jobs
setopt NO_HUP                  # Don't kill jobs on shell exit
setopt NO_CHECK_JOBS           # Don't warn about running jobs on exit
```

### Zsh Completion System

**Initialize completion:**
```zsh
# Basic setup
autoload -Uz compinit
compinit

# Faster compinit (check once per day)
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select                          # Menu selection
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'        # Case insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}      # Colored completion
zstyle ':completion:*' group-name ''                        # Group matches
zstyle ':completion:*:descriptions' format '%B%d%b'         # Format group names
zstyle ':completion:*:warnings' format 'No matches for: %d' # No matches message
```

### Zsh Key Bindings

**Emacs mode (default):**
```zsh
bindkey -e  # Enable emacs mode

# Custom bindings
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
bindkey '^[[1;5C' forward-word                  # Ctrl+Right
bindkey '^[[1;5D' backward-word                 # Ctrl+Left
bindkey '^[[3~' delete-char                     # Delete
bindkey '^[[H' beginning-of-line                # Home
bindkey '^[[F' end-of-line                      # End
```

**Vi mode:**
```zsh
bindkey -v  # Enable vi mode

# Reduce mode switch delay
export KEYTIMEOUT=1

# Show mode in prompt
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q'  # Block cursor
  else
    echo -ne '\e[5 q'  # Beam cursor
  fi
}
zle -N zle-keymap-select

# Vi-style incremental search
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward
```

### Zsh Functions

**Autoload functions:**
```zsh
# Create functions directory
mkdir -p $ZDOTDIR/functions

# In $ZDOTDIR/.zshrc
fpath=($ZDOTDIR/functions $fpath)
autoload -Uz $ZDOTDIR/functions/*(:t)

# Example function: $ZDOTDIR/functions/mkcd
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Example function: Extract archives
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
```

### Zsh Plugin Management with Zinit

**Install zinit:**
```zsh
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

**Configuration:**
```zsh
# In $ZDOTDIR/.zshrc

# Load zinit
source "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git/zinit.zsh"

# Fast syntax highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Completions
zinit light zsh-users/zsh-completions

# History substring search
zinit light zsh-users/zsh-history-substring-search

# fzf integration
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf

# Turbo mode (lazy loading)
zinit ice wait lucid
zinit light agkozak/zsh-z  # z directory jumper
```

### Zsh Performance Optimization

**1. Compile scripts:**
```zsh
# Compile .zshrc and functions
zcompile ~/.zshrc
zcompile $ZDOTDIR/functions/*

# Automate with Makefile
.PHONY: compile-zsh
compile-zsh:
	@find ~/.config/zsh -name "*.zsh" -exec zsh -c 'zcompile {}' \;
	@zcompile ~/.zshrc
```

**2. Lazy load heavy tools:**
```zsh
# Instead of: eval "$(rbenv init -)"
# Use lazy loading:
rbenv() {
  unfunction rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}
```

**3. Profile startup time:**
```zsh
# Add to top of .zshrc
zmodload zsh/zprof

# Add to bottom of .zshrc
zprof
```

## Shell Scripting Best Practices

### Safety First

**Always use these at the start:**
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# -e: Exit on error
# -u: Exit on undefined variable
# -o pipefail: Catch errors in pipes
# IFS: Safer word splitting
```

### Quoting Variables

**Always quote variables:**
```bash
# Bad
if [ -f $file ]; then
  cat $file
fi

# Good
if [ -f "$file" ]; then
  cat "$file"
fi

# Exception: When you want word splitting
for arg in $args; do  # Intentional word splitting
  echo "$arg"         # Quote when using
done
```

### Conditional Expressions

**Use `[[ ]]` in Bash/Zsh (not `[ ]`):**
```bash
# [[ ]] is better:
[[ -f "$file" ]]           # File exists
[[ -d "$dir" ]]            # Directory exists
[[ -z "$var" ]]            # String is empty
[[ -n "$var" ]]            # String is not empty
[[ "$a" == "$b" ]]         # String equality
[[ "$a" =~ ^[0-9]+$ ]]     # Regex match
[[ "$a" && "$b" ]]         # Logical AND
[[ "$a" || "$b" ]]         # Logical OR
```

### Functions

**Declare functions properly:**
```bash
# Good: Clear and explicit
function my_function() {
  local arg1="$1"
  local arg2="${2:-default}"  # With default

  # Validate input
  if [[ -z "$arg1" ]]; then
    echo "Error: arg1 required" >&2
    return 1
  fi

  # Do work
  echo "Processing: $arg1"

  # Return status
  return 0
}

# Call it
if my_function "value"; then
  echo "Success"
else
  echo "Failed"
fi
```

### Error Handling

**Handle errors gracefully:**
```bash
# Trap errors
trap 'echo "Error on line $LINENO" >&2' ERR

# Check command success
if ! command -v git >/dev/null 2>&1; then
  echo "Git is not installed" >&2
  exit 1
fi

# Or use logical operators
command || { echo "Command failed" >&2; exit 1; }

# Multiple commands with error handling
{
  command1 &&
  command2 &&
  command3
} || {
  echo "One or more commands failed" >&2
  exit 1
}
```

### Arrays

**Use arrays for lists:**
```bash
# Declaration
files=("file1.txt" "file2.txt" "file3.txt")

# Append
files+=("file4.txt")

# Iterate
for file in "${files[@]}"; do
  echo "$file"
done

# Length
echo "${#files[@]}"

# Check if contains
if [[ " ${files[*]} " =~ " file2.txt " ]]; then
  echo "Found"
fi
```

### Parameter Expansion

**Common patterns:**
```bash
# Default values
echo "${VAR:-default}"        # Use default if unset
echo "${VAR:=default}"        # Set and use default if unset
echo "${VAR:?error message}"  # Error if unset

# String manipulation
file="/path/to/file.txt"
echo "${file##*/}"    # file.txt (basename)
echo "${file%/*}"     # /path/to (dirname)
echo "${file%.txt}"   # /path/to/file (remove extension)
echo "${file##*.}"    # txt (get extension)

# Case conversion
name="john"
echo "${name^}"       # John (first char uppercase)
echo "${name^^}"      # JOHN (all uppercase)
echo "${name,,}"      # john (all lowercase)

# Substring
text="hello world"
echo "${text:0:5}"    # hello (offset:length)
echo "${text:6}"      # world (from offset)
```

## Terminal Tools & Utilities

### Modern CLI Replacements

**Better versions of classic tools:**
- `exa` / `eza` → `ls` (better file listing)
- `bat` → `cat` (syntax highlighting)
- `fd` → `find` (simpler, faster)
- `rg` (ripgrep) → `grep` (faster)
- `fzf` → fuzzy finder (interactive selection)
- `zoxide` → `cd` (smart directory jumping)
- `delta` → `diff` (better diffs)
- `btm` → `top` (better resource monitor)

**Aliases for gradual adoption:**
```zsh
alias cat='bat'
alias ls='eza -l --icons'
alias find='fd'
alias grep='rg'
```

### Tmux Integration

**Zsh + Tmux auto-attach:**
```zsh
# In .zshrc - auto-attach to tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$INSIDE_EMACS" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi
```

### Directory Navigation

**Z (directory jumper):**
```zsh
# With zsh-z plugin
zinit light agkozak/zsh-z

# Usage:
# cd ~/Projects/work/backend
# cd ~/Projects/personal/frontend
# z back   # Jumps to ~/Projects/work/backend
# z front  # Jumps to ~/Projects/personal/frontend
```

**Directory stack:**
```zsh
# Push current dir and change
cd -P ~/other/dir  # -P = push

# Show stack
dirs -v

# Jump to stack entry
cd ~3  # Go to 3rd entry

# Aliases
alias d='dirs -v'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
```

## Common Patterns

### Iteration

**Files in directory:**
```bash
# Good: Handles spaces and special chars
for file in ./*.txt; do
  [[ -f "$file" ]] || continue  # Skip if no match
  echo "Processing: $file"
done

# With find (more control)
while IFS= read -r -d '' file; do
  echo "Processing: $file"
done < <(find . -name "*.txt" -print0)
```

### User Input

**Read from user:**
```bash
# Simple
read -p "Enter your name: " name
echo "Hello, $name"

# With validation
while true; do
  read -p "Continue? [y/n] " answer
  case "$answer" in
    [Yy]*) break ;;
    [Nn]*) exit 0 ;;
    *) echo "Please answer y or n" ;;
  esac
done

# Silent (for passwords)
read -s -p "Password: " password
echo  # New line after silent input
```

### Colors in Output

**ANSI colors:**
```bash
# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# Use them
echo -e "${GREEN}Success!${NC}"
echo -e "${RED}Error!${NC}"
echo -e "${YELLOW}Warning!${NC}"
```

### Debugging

**Debug your scripts:**
```bash
# Enable tracing
set -x  # Print commands as executed

# Disable tracing
set +x

# Debug function
debug() {
  if [[ "${DEBUG:-0}" == "1" ]]; then
    echo "DEBUG: $*" >&2
  fi
}

# Usage:
# DEBUG=1 ./script.sh
debug "Variable value: $var"
```

## Performance Tips

1. **Use built-ins over external commands**
   ```bash
   # Slow
   basename "$file"
   dirname "$file"

   # Fast
   ${file##*/}
   ${file%/*}
   ```

2. **Avoid subshells when possible**
   ```bash
   # Slow (subshell)
   count=$(grep -c pattern file.txt)

   # Faster (process substitution)
   while IFS= read -r line; do
     ((count++))
   done < <(grep pattern file.txt)
   ```

3. **Use `printf` over `echo` for complex formatting**
   ```bash
   printf '%s\n' "$var"  # More portable than echo -e
   printf '%-20s %s\n' "Name:" "$name"  # Formatted
   ```

## References

- Zsh Documentation: https://zsh.sourceforge.io/Doc/
- Advanced Bash Scripting: https://tldp.org/LDP/abs/html/
- ShellCheck: https://www.shellcheck.net/ (shell script linter)
- Explain Shell: https://explainshell.com/ (explain shell commands)
