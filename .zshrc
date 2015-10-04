if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

echo ''
fortune -a | lolcat
echo ''
#export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"

source /usr/local/Cellar/antigen/1/share/antigen.zsh
source /Users/bez/.phpbrew/bashrc

function powerline_lib_path() {
  pip3 show powerline-status | grep Location | awk '{print $2}'
}

#powerline-daemon -rq

function src() {
  source $HOME/.zshrc
}


alias dl=youtube-dl
alias vi=vim
alias quit=exit

export POWERLINE_PATH=$(powerline_lib_path)/powerline
export EDITOR=vim
export HISTINGORE='clear:history'
export HISTORYCONTROL='ignoreboth'

function powerline() {
  $POWERLINE_PATH/client/powerline.sh "$@"
}

#unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

BASE16_FLAVOR=eighties
BACKGROUND=${BACKGROUND:-"dark"}

BASE16_SHELL="$HOME/TerminalMods/base16-shell/base16-${BASE16_FLAVOR}.${BACKGROUND}.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

function dark() {
  export BACKGROUND='dark' && src
}

function light() {
  export BACKGROUND="light" && src
}

# Antigen plugins#
antigen use oh-my-zsh

antigen bundle git
antigen bundle autojump
antigen bundle brew
antigen bundle bower
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
antigen bundle jsontools
antigen bundle pip
antigen bundle python
antigen bundle rand-quote
antigen bundle sprunge
antigen bundle sudo
antigen bundle symfony2
antigen bundle tmux
antigen bundle vagrant
antigen bundle web-search
antigen bundle wd
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

export POWERLINE_DAEMON_PS="$(ps aux | grep powerline-daemon | grep -v grep)"
if [[ -z "$POWERLINE_DAEMON_PS" ]]; then
  echo "Starting powerline-daemon..."
  powerline-daemon -q
fi
. $POWERLINE_PATH/bindings/zsh/powerline.zsh

#PATH=$PATH:~/.composer/vendor/bin

# vim indicator in Powerline shell
if [[ -n "$VIMRUNTIME" ]]; then
  export POWERLINE_IN_VIM_SHELL=':sh'
fi
