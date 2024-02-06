#/usr/bin/env bash

function _python-inventory() {
  local versions="$(pyenv versions --bare --skip-aliases | grep '^[0-9]\.[0-9]\.[0-9]\+$')"
  _pip-install-version "system" "pip2"
  for v in $versions; do
    _pip-install-version $v
  done
}

function _pip-install-version() {
  local version=$1
  shift
  local pip_command=${1:-pip}
  #echo '# version '$v
  if [[ "$version" != "system" ]]; then
    echo "echo \"Installing $version...\""
    echo pyenv install $version --skip-existing
  fi
  echo "echo \""
  echo "$(PYENV_VERSION=$version $pip_command freeze | sed 's/^/  /')"
  echo "\" | PYENV_VERSION=$version $pip_command install -r /dev/stdin"
  echo ""
}

_python-inventory
