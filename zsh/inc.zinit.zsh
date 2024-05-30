# Install Zinit if necessary
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Work around for Github dropping SVN protocol support:
# https://github.com/zdharma-continuum/zinit/discussions/651#discussioncomment-9530645
setopt RE_MATCH_PCRE   # _fix-omz-plugin function uses this regex style

# Workaround for zinit issue#504: remove subversion dependency. Function clones all files in plugin
# directory (on github) that might be useful to zinit snippet directory. Should only be invoked
# via zinit atclone"_fix-omz-plugin"
_fix-omz-plugin() {
  if [[ ! -f ._zinit/teleid ]] then return 0; fi
  if [[ ! $(cat ._zinit/teleid) =~ "^OMZP::.*" ]] then return 0; fi
  local OMZP_NAME=$(cat ._zinit/teleid | sed -n 's/OMZP:://p')
  git clone --quiet --no-checkout --depth=1 --filter=tree:0 https://github.com/ohmyzsh/ohmyzsh
  cd ohmyzsh
  git sparse-checkout set --no-cone plugins/$OMZP_NAME
  git checkout --quiet
  cd ..
  local OMZP_PATH="ohmyzsh/plugins/$OMZP_NAME"
  local file
  for file in ohmyzsh/plugins/$OMZP_NAME/*(D); do
    local filename="$(basename $file)"
    if [[ $filename == '.gitignore' ]] then continue; fi
    if [[ $filename == "$OMZP_NAME.plugin.zsh" ]] then continue; fi
    echo "Copying $file to $(pwd)/$filename..."
    cp $file $filename
  done
  rm -rf ohmyzsh
}

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Load the following Zprezto modules
zi snippet PZTM::environment
zi snippet PZTM::terminal
zi snippet PZTM::directory

# Use vi bindings on the prompt
zstyle ':prezto:module:editor' key-bindings 'vi'
zi snippet PZTM::editor

zi snippet PZTM::history
zi snippet PZTM::spectrum

# Enabled safe options. This aliases cp, ln, mv and rm so that they prompt
# before deleting or overwriting files. Set to 'no' to disable this safer
# behavior.
zstyle ':prezto:module:utility' safe-ops yes
zi snippet PZTM::utility

# https://github.com/Aloxaf/fzf-tab
# Use tmux popup
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# Don't show any preview in FZF picker for kubectl completions
zstyle ':fzf-tab:complete:*' fzf-flags '--no-preview'
zstyle ':fzf-tab:complete:*' popup-min-size 50 0
zi load Aloxaf/fzf-tab

# https://github.com/junegunn/fzf-git.sh
zi load junegunn/fzf-git.sh

zi load bezhermoso/jump-to-git-root
zi load bezhermoso/jump-to-project-root

zi ice atload"!_zsh_autosuggest_start"
zi load zsh-users/zsh-autosuggestions

# vi bindings to complete the autosuggestion:
bindkey -M viins "^F" vi-forward-word
bindkey -M viins "^E" vi-add-eol

zi ice atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi load zdharma-continuum/fast-syntax-highlighting

zi ice atpull"%atclone" atclone"_fix-omz-plugin"
zi snippet OMZP::macos
zi ice atpull"%atclone" atclone"_fix-omz-plugin"
zi snippet OMZP::colored-man-pages

zi ice \
  atclone"git clone --recursive https://github.com/zsh-users/zsh-completions.git external" \
  blockf
zi snippet PZTM::completion

