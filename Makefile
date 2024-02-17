npm-inventory:
	bash languages/nodejs/inventory.sh | tee languages/nodejs/install-npm-globals.sh

pip-inventory:
	bash languages/python/inventory.sh | tee languages/python/install-pip-globals.sh

gem-inventory:
	bash languages/ruby/inventory.sh | tee languages/ruby/install-gem-globals.sh


