SHELL = /bin/zsh
HOSTNAME := $(shell hostname -s)

npm-inventory:
	bash languages/nodejs/inventory.sh | tee languages/nodejs/install-npm-globals.sh

pip-inventory:
	bash languages/python/inventory.sh | tee languages/python/install-pip-globals.sh

gem-inventory:
	bash languages/ruby/inventory.sh | tee languages/ruby/install-gem-globals.sh

.ONESHELL:
brewfile:
	@bash -c 'mkdir homebrew/"$(HOSTNAME)"; cd homebrew/"$(HOSTNAME)"; rm Brewfile; brew bundle dump'

tmux-terminfo:
	# See https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
	# This script automates the whole process:
	brew install ncurses
	$$(brew --prefix ncurses)/bin/infocmp -x tmux-256color | \
		sed -E 's/pairs#(0x10000|65536)/pairs#32767/' | \
		tic -x -o ~/.dotfiles/terminfo -

