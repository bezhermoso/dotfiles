npm-inventory:
	bash nodejs/inventory.sh | tee nodejs/install-npm-globals.sh

pip-inventory:
	bash python/inventory.sh | tee python/install-pip-globals.sh

