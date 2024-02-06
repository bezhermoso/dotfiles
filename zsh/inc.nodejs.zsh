
if (( $+commands[nodenv] )); then
  eval "$(nodenv init -)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Lazy-load nvm
#function nvm() {
  #if [[ -z $NVM_DIR ]]; then
    #export NVM_DIR="/Users/bez/.nvm"
    #source "$NVM_DIR/nvm.sh"
    #nvm $@
  #fi
#}

