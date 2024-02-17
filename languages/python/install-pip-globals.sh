echo "

" | PYENV_VERSION=system pip2 install -r /dev/stdin

echo "Installing 2.7.18..."
pyenv install 2.7.18 --skip-existing
echo "

" | PYENV_VERSION=2.7.18 pip install -r /dev/stdin

