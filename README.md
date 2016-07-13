# dotfiles

Clone under `$HOME/.dotfiles` with `--recursive` flag


## Homebrew

Most of the stuff here would not work 100% without some dependencies which are found in `homebrew/brews.txt`. This is probably the best first step:

```bash
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install brews:
brew install $(cat ~/.dotfiles/homebrew/brews.txt)
```


## GUI applications (and some fonts)

```bash
# Install Cask:
brew tap caskroom/cask

# Tap homebrew-fonts:
brew tap caskroom/fonts

# Install applications:
brew cask install $(cat ~/.dotfiles/homebrew/casks.txt)
```

## zsh


```bash
ln -s ~/.dotfiles/zsh/.zshenv ~/.zshenv

# Restart terminal. Then:

zplug install
```


## neovim

```bash
ln -s ~/.dotfiles/vim ~/.config/nvim

# Install `vim-plug`:
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run :PlugInstall:
nvim +PlugInstall
```

## tmux

Requires Tmux 2.1+

```bash

ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# Install `tpm`:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start a new `tmux` session and invoke `C-s M-I` to install the plugins.

#### tmux 2.* on Ubuntu
```bash
sudo apt-get update
sudo apt-get install -y python-software-properties software-properties-common
sudo add-apt-repository -y ppa:pi-rho/dev
sudo apt-get update
sudo apt-get install -y tmux=2.0-1~ppa1~t
```
