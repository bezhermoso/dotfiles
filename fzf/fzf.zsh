# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/bez/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/bez/.fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */Users/bez/.fzf/man* && -d "/Users/bez/.fzf/man" ]]; then
  export MANPATH="$MANPATH:/Users/bez/.fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/bez/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/bez/.fzf/shell/key-bindings.zsh"

