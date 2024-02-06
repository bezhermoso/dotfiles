# rbenv
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

