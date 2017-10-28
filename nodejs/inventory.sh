#!/usr/bin/env bash

function _npm-inventory() {
  local versions="$(nodenv versions --bare --skip-aliases)"
  _npm-install-version "system"
  for v in $versions; do
    _npm-install-version $v
  done
}

function _npm-install-version() {
  local version=$1
  #echo '# version '$v
  if [[ "$version" != "system" ]]; then
    echo "echo \"Installing $version...\""
    echo nodenv install $version --skip-existing
  fi
  echo "echo \"Installing dependencies for $version...\""
  echo "NODENV_VERSION=$version npm install -g \\"
  NODENV_VERSION=$version npm ls --depth=0 --global 2>/dev/null | awk 'NR>1 { print "  " $NF }'
}

_npm-inventory
