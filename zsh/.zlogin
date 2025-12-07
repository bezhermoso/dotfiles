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
  # Exclude plugin manager and cache directories
  local -a exclude_patterns=(
    "*/.zinit/*" "*/zinit/*"                    # Zinit
    "*/.oh-my-zsh/*" "*/.zprezto/*"            # Oh My Zsh, Prezto
    "*/.antigen/*" "*/.zplug/*"                # Antigen, zplug
    "*/.zgen/*" "*/.zgenom/*" "*/sheldon/*"    # zgen, zgenom, sheldon
    "*/.antibody/*" "*/.cache/antibody/*"      # Antibody
    "*/.zcompcache/*" "*/.zsh_sessions/*"      # Caches
  )

  for file in ${ZDOTDIR:-$HOME}/**/*.zsh(N); do
    # Skip plugin manager/cache files
    local skip=0
    for pattern in "${exclude_patterns[@]}"; do
      [[ "$file" == $~pattern ]] && { skip=1; break; }
    done
    [[ $skip -eq 1 ]] && continue

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

