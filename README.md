### Vim

Install MacVim

> brew install macvim --override-system-vim --with-python3 --with-lua --with-luajit

Install [`vim-plug`](https://github.com/junegunn/vim-plug):

> curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

Run `:PlugInstall` within Vim.

### Warning: 

Installing [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) with `vim-plug`
causes `:PlugInstall` to freeze. Quick solution is to comment out `Plug
'Valoric/YouCompleteMe'` from `.vimrc` and run `:PlugInstall YouCompletMe`
manually. From there, go into `~/.vim/plugged/YouCompleteMe` and build it from
there.

### Powerline

```
git clone git@github.com:powerline/powerline.git
cd powerline
pip install --user -e .
```

```
pip install --user vim-power --pre
```

### Tmux

Requires Tmux 2.1

