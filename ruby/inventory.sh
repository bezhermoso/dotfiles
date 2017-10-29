#!/usr/bin/env bash

function _gem-inventory() {
    local path_to_gemfile=$1
    local versions="$(rbenv versions --bare --skip-aliases)"
    _gem-install-version "system" $path_to_gemfile
    for v in $versions; do
        _gem-install-version $v $path_to_gemfile
    done

}

function _gem-install-version() {
  local version=$1
  shift
  local path_to_gemfile=$1
  if [[ "$version" != "system" ]]; then
    echo "echo \"Installing $version...\""
    echo rbenv install $version --skip-existing
  fi
  local gemfile="$path_to_gemfile/Gemfile-$version"
  [[ ! -e $gemfile ]] && touch $gemfile || :
  echo 'source "https://rubygems.org"' >> $gemfile
  RBENV_VERSION=$version gem list \
      | grep -E '^[a-zA-Z0-9\-_]+\s(.+)$' \
      | while read gem; do
  echo $gem | sed 's/^\([a-zA-Z0-9\-_]*\) (\(.*\))/\1 \2/' | (read gem_name gem_version; echo "gem \"$gem_name\", \"$gem_version\"") >> $gemfile
  done

  echo "RBENV_VERSION=$version gem install -g $gemfile"

}


_gem-inventory "$@"
