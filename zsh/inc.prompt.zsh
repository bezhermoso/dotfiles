
# Load powerlevel10k theme.
# See ./inc.powerlevel10k.zsh for what's loaded much earlier in the shell.
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Use vi bindings on the prompt
zstyle ':prezto:module:editor' key-bindings 'vi'
zi snippet PZTM::editor

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8,standout'
zi ice atload'!_zsh_autosuggest_start; bindkey -M viins "^F" vi-forward-word; bindkey -M viins "^E" vi-add-eol'
zi load zsh-users/zsh-autosuggestions

# https://github.com/zdharma-continuum/fast-syntax-highlighting
zi ice atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi load zdharma-continuum/fast-syntax-highlighting

# Configure Zsh surround capabilities
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

