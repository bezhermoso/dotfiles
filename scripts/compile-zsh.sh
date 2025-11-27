#!/usr/bin/env zsh
# Compile all .zsh configuration files to bytecode (.zwc)
# Used by: LaunchAgent, Git hooks, and manual invocation

set -euo pipefail

ZDOTDIR="${ZDOTDIR:-$HOME/.dotfiles/zsh}"
compiled_count=0
error_count=0

echo "🔧 Compiling zsh configuration files..."

# Compile all .zsh files
for file in "$ZDOTDIR"/**/*.zsh(N); do
  # Skip if .zwc exists and is newer than source
  if [[ -f "${file}.zwc" && ! "$file" -nt "${file}.zwc" ]]; then
    continue
  fi

  if zcompile "$file" 2>/dev/null; then
    echo "  ✓ Compiled $(basename "$file")"
    ((compiled_count++))
  else
    echo "  ✗ Failed to compile $(basename "$file")" >&2
    ((error_count++))
  fi
done

# Summary
if [[ $compiled_count -eq 0 && $error_count -eq 0 ]]; then
  echo "✨ All files up to date (no compilation needed)"
elif [[ $error_count -eq 0 ]]; then
  echo "✅ Successfully compiled $compiled_count file(s)"
else
  echo "⚠️  Compiled $compiled_count file(s) with $error_count error(s)" >&2
  exit 1
fi
