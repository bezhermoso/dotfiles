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

terminfo:
	# See https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
	# This script automates the whole process:
	brew install ncurses
	$$(brew --prefix ncurses)/bin/infocmp -x tmux-256color | \
		sed -E 's/pairs#(0x10000|65536)/pairs#32767/' | \
		tic -x -o terminfo -

.PHONY: ssh_fallback
ssh_fallback: ~/.ssh/id_rsa_fallback

# Reads fallback SSH key from 1Password vault and drop it in ~/.ssh/id_rsa_fallback
~/.ssh/id_rsa_fallback:
	op item get lgukbustpzevs7g5osdyqeyqf4 \
		--format json \
		--fields 'label=private key' \
		--reveal \
		| jq -r '.ssh_formats.openssh.value' \
		| sed 's#\r##' > ~/.ssh/id_rsa_fallback
	chmod 0700 ~/.ssh/id_rsa_fallback
