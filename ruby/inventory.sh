#!/usr/bin/env bash

function _gem-inventory() {
    local versions="$(rbenv versions --bare --skip-aliases)"
    _gem-install-version "system"
    for v in $versions; do
        _gem-install-version $v
    done

}

function _gem-install-version() {
  local version=$1
  if [[ "$version" != "system" ]]; then
    echo "echo \"Installing $version...\""
    echo rbenv install $version --skip-existing
  fi
  echo "echo '"
  RBENV_VERSION=$version ruby -e 'print "source \"https://rubygems.org\"\n"' -e 'Gem::Specification.each{|g| print "gem \"#{g.name}\", :version => \"#{g.version}\"\n" }'
  echo "' | RBENV_VERSION=$version gem install -g /dev/stdin --no-lock"
}


_gem-inventory "$@"
