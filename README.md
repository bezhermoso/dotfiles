![preview](./preview.png)

# dot ● files

#### my `zsh`, `neovim`, `tmux`, _etc._ configurations

---

Clone under `$HOME/.dotfiles` with `--recursive` flag


## Homebrew


```bash
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Use [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) to install dependencies:

```bash
brew tap Homebrew/bundle
brew bundle --file=homebrew/Brewfile
```

## zsh

```bash
ln -s ~/.dotfiles/zsh/.zshenv ~/.zshenv
```


## neovim

```bash
ln -s ~/.dotfiles/vim ~/.config/nvim

# lazy.nvim will bootstrap itself and install dependencies.
nvim

# Run :Mason to configure LSPs
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

## bat

```
ln -s ~/.dotfiles/bat ~/.config/bat
```

## atuin

```
ln -s ~/.dotfiles/atuin ~/.config/atuin
atuin login
```

## git

Create a `~/.gitconfig` file & include files from `~/.dotfiles/git` e.g.

```
[include]
    path = ~/.dotfiles/git/gitconfig.base
    path = ~/.dotfiles/git/gitconfig.1password

# REQUIRED. `user` is unset in dotfile includes.
[user]
	name = Bez Hermoso
	email = ...
```

## gh

```
ln -s ~/.dotfiles/gh ~/.config/gh
```
