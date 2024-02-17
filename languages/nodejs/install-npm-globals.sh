echo "Installing dependencies for system..."
NODENV_VERSION=system npm install -g \
echo "Installing 10.14.0..."
nodenv install 10.14.0 --skip-existing
echo "Installing dependencies for 10.14.0..."
NODENV_VERSION=10.14.0 npm install -g \
  npm@6.4.1
  yarn@1.22.19
  
echo "Installing 20.2.0..."
nodenv install 20.2.0 --skip-existing
echo "Installing dependencies for 20.2.0..."
NODENV_VERSION=20.2.0 npm install -g \
  corepack@0.17.2
  neovim@4.10.1
  npm@9.6.6
  yarn@1.22.19
  
