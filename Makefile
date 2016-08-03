brew-inventory:
	brew list | sed 's/(!)//' | tee homebrew/brews.txt
	brew cask list | sed 's/(!)//' | tee homebrew/casks.txt

brew-install:
	brew install --force $(cat homebrew/brews.txt)
	brew cask install --force $(cat homebrew/casks.txt)


