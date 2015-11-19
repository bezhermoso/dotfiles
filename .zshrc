if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

echo ''
fortune
echo ''
#archey
#echo ''
#export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$HOME/.local/bin:$PATH"


if [[ -n "$SSH_CONNECTION" ]]; then
  source ~/antigen.zsh
else
  source /usr/local/Cellar/antigen/1/share/antigen.zsh
fi
[[ -s "${HOME}/.phpbrew/bashrc" ]] && source /Users/bez/.phpbrew/bashrc

function powerline_lib_path() {
  pip show powerline-status | grep Location | awk '{print $2}'
}

#powerline-daemon -rq

function src() {
  source $HOME/.zshrc
}


alias dl=youtube-dl
alias vim=nvim
alias vi=vim
alias quit=exit

export POWERLINE_PATH=$(powerline_lib_path)/powerline
#export POWERLINE_PATH=$(powerline_lib_path)
export EDITOR=nvim
export HISTINGORE='clear:history'
export HISTORYCONTROL='ignoreboth'

#function powerline() {
  #$POWERLINE_PATH/client/powerline.sh "$@"
#}

#unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help


export BASE16_FLAVOR=${BASE16_FLAVOR:-"bright"}
export VIM_COLOR="base16-${BASE16_FLAVOR}"
export BACKGROUND=${BACKGROUND:-"dark"}

BASE16_SHELL="$HOME/TerminalMods/base16-shell/base16-${BASE16_FLAVOR}.${BACKGROUND}.sh"

if [[ -z "$TMUX" ]]; then
  [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
fi

if [[ $BACKGROUND = "dark" ]]; then
  export TMUX_WINDOW_STYLE='bg=#181818'
  export TMUX_ACTIVE_WINDOW_STYLE='bg=black'
else
  export TMUX_WINDOW_STYLE='bg=lightgray'
  export TMUX_ACTIVE_WINDOW_STYLE='bg=white'
fi

function dark() {
  export BACKGROUND='dark' && src
}

function light() {
  export BACKGROUND="light" && src
}

# Antigen plugins#
antigen use oh-my-zsh

source $HOME/.dotfiles/zsh/vi-mode.zsh
antigen bundle git
antigen bundle autojump
antigen bundle brew
antigen bundle bower
antigen bundle chucknorris
#antigen bundle common-aliases
# Shift+Ctrl+Arrow to cycle:
#antigen bundle dircycle
# Alt+Arrow to cycle:
antigen bundle dirhistory
antigen bundle dirpersist
antigen bundle node
antigen bundle npm
antigen bundle bundler
antigen bundle gem
antigen bundle catimg
antigen bundle composer
antigen bundle docker
antigen bundle encode64
antigen bundle httpie
antigen bundle history
antigen bundle jira
antigen bundle jsontools
antigen bundle pip
antigen bundle python
antigen bundle rand-quote
antigen bundle sprunge
antigen bundle sudo
antigen bundle osx
antigen bundle symfony2
antigen bundle tmux
antigen bundle tmuxinator
antigen bundle urltools
antigen bundle vagrant
#antigen bundle web-search
antigen bundle wd
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# Seems like Shift+Tab is unbound by one of the Antigen plugins...
bindkey -M menuselect '^[[Z' reverse-menu-complete

export POWERLINE_DAEMON_PS="$(ps aux | grep powerline-daemon | grep -v grep)"
if [[ -z "$POWERLINE_DAEMON_PS" ]]; then
  echo "Starting powerline-daemon..."
  powerline-daemon -rq
fi

NEWLINE=$'\n'
function powerline-prompt() {
  . $POWERLINE_PATH/bindings/zsh/powerline.zsh
  #PS1=$PS1$NEWLINE" λ  "
  PS1=$PS1$NEWLINE" ★  "
  PS2="%_  "
}

function antigen-prompt() {
  antigen theme agnoster
}

if [[ -n "$SSH_CONNECTION" ]]; then
  antigen-prompt
else
  powerline-prompt
fi


#tmux start-server
#PATH=$PATH:~/.composer/vendor/bin

# vim indicator in Powerline shell
#if [[ -n "$VIMRUNTIME" ]]; then
  #export POWERLINE_IN_VIM_SHELL=':sh'
#fi

#export PATH="$PATH:/opt/tmux"
#test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
export ANSIBLE_NOCOWS=1

# tmuxinator
tmuxinator_version=$(gem list tmuxinator | grep tmuxinator | awk '{print $2}' | sed 's/(/-/' | sed 's/)//')
tmuxinator_dir=$(gem list tmuxinator -d | grep Installed | awk '{print $3}')
source $tmuxinator_dir/gems/tmuxinator$tmuxinator_version/completion/tmuxinator.zsh

function xcode-license() {
  sudo xcodebuild -license
}


export NVM_DIR="/Users/bez/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias hacksh='$SHELL | tr -u eauiobBgGsSlL 34U1088995577'
alias reinit-markers='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed'

nvm use 0.12
