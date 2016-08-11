brew-inventory:
	brew list | sed 's/(!)//' | tee homebrew/brews.txt
	brew cask list | sed 's/(!)//' | tee homebrew/casks.txt

brew-install:
	brew install --force $(cat homebrew/brews.txt)
	brew cask install --force $(cat homebrew/casks.txt)


# Not working yet.
npm-inventory:
	npm list -g --depth=0 2&> /dev/null | grep -v '\->' | tail -n +2 | cut -c 5-
	echo "# Links:" >! npm/links.txt
	npm list -g --depth=0 2&> /dev/null | grep '\->' | tail -n +2 | cut -c 5-

