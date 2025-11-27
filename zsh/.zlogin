# From zprezto:
# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    if command mkdir "${zcompdump}.zwc.lock" 2>/dev/null; then
      zcompile "$zcompdump"
      command rmdir  "${zcompdump}.zwc.lock" 2>/dev/null
    fi
  fi

  # Compile all zsh configuration files for faster sourcing
  # Exclude zinit directories (plugin managers don't like .zwc files)
  local zinit_home="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
  for file in ${ZDOTDIR:-$HOME}/**/*.zsh(N); do
    # Skip zinit managed plugins
    [[ "$file" == *"${zinit_home}"* || "$file" == *"/.zinit/"* ]] && continue

    if [[ ! -f "${file}.zwc" || "$file" -nt "${file}.zwc" ]]; then
      zcompile "$file"
    fi
  done
} &!

# Execute code only if STDERR is bound to a TTY.
if [[ -o INTERACTIVE && -t 2 ]]; then

  # Print a random, hopefully interesting, adage.
  if (( $+commands[fortune] )); then
    fortune -s
    print
  fi

fi >&2

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" || : # Load RVM into a shell session *as a function*
