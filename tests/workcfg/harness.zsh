#!/usr/bin/env zsh
# Test harness for bin/workcfg.
# Every fixture is a throwaway GNUPGHOME with passphraseless keys, so no test
# can ever trigger pinentry.

typeset -g TESTS_RUN=0 TESTS_FAILED=0 CURRENT_TEST="" CURRENT_FAILED=0
typeset -g WORKCFG_BIN="${WORKCFG_BIN:-${0:a:h}/../../bin/workcfg}"
typeset -gA SNAPSHOTS

it() {
  CURRENT_TEST="$1"
  CURRENT_FAILED=0
  (( TESTS_RUN++ ))
}

_pass_or_fail() {
  if (( CURRENT_FAILED )); then
    (( TESTS_FAILED++ ))
    print -u2 "  ✗ $CURRENT_TEST"
  else
    print "  ✓ $CURRENT_TEST"
  fi
}

fail() {
  print -u2 "      $*"
  CURRENT_FAILED=1
  return 1
}

assert_eq() {
  local expected="$1" actual="$2" msg="${3:-}"
  [[ "$expected" == "$actual" ]] && return 0
  fail "${msg}expected '$expected', got '$actual'"
}

sha_of() { shasum -a 256 "$1" | cut -d' ' -f1 }

assert_file_sha() { assert_eq "$2" "$(sha_of "$1")" "sha($1): " }

snapshot_file() { SNAPSHOTS[$1]="$(sha_of "$1")" }

assert_unchanged() {
  local path="$1"
  [[ -n "${SNAPSHOTS[$path]}" ]] || { fail "no snapshot for $path"; return 1 }
  assert_eq "${SNAPSHOTS[$path]}" "$(sha_of "$path")" "$path was modified: "
}

assert_status() { assert_eq "$2" "$($WORKCFG_BIN status --porcelain-one "$1")" "status($1): " }

# Generates a key with an encryption subkey and no passphrase.
_gen_key() {
  local home="$1" uid="$2"
  mkdir -p "$home"; chmod 700 "$home"
  GNUPGHOME="$home" gpg --batch --quiet --gen-key 2>/dev/null <<EOF
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: $uid
Name-Email: $uid@test.invalid
Expire-Date: 0
%no-protection
%commit
EOF
}

_subkey_id() {
  GNUPGHOME="$1" gpg --batch --with-colons --list-keys "$2@test.invalid" \
    | awk -F: '/^sub:/ {print $5; exit}'
}

fixture_setup() {
  FIXTURE_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/workcfg-test.XXXXXX")"
  export WORKCFG_REPO_DIR="$FIXTURE_ROOT/repo"
  export WORKCFG_DATA_DIR="$FIXTURE_ROOT/data"
  export GNUPGHOME="$FIXTURE_ROOT/gnupg"
  export WORKCFG_HOST_PATTERN='.'          # always "on a work machine" in tests
  mkdir -p "$WORKCFG_REPO_DIR" "$WORKCFG_DATA_DIR"
  _gen_key "$GNUPGHOME" "workcfg"
  TEST_KEYID="$(_subkey_id "$GNUPGHOME" workcfg)"

  # A second key imported as public-only: present but with no ownertrust,
  # reproducing spec finding 11.
  _gen_key "$FIXTURE_ROOT/gnupg-other" "untrusted"
  TEST_UNTRUSTED_KEYID="$(_subkey_id "$FIXTURE_ROOT/gnupg-other" untrusted)"
  GNUPGHOME="$FIXTURE_ROOT/gnupg-other" gpg --batch --armor --export \
    untrusted@test.invalid 2>/dev/null | gpg --batch --quiet --import 2>/dev/null
  SNAPSHOTS=()
}

fixture_teardown() {
  [[ -n "$FIXTURE_ROOT" && "$FIXTURE_ROOT" == */workcfg-test.* ]] && rm -rf "$FIXTURE_ROOT"
}

# Writes plaintext and a ciphertext encrypted to $TEST_KEYID, without state.
seed_encrypted() {
  local name="$1" content="$2"
  print -rn -- "$content" > "$WORKCFG_DATA_DIR/$name"
  gpg --batch --yes --quiet --trust-model always \
      --encrypt --recipient "0x$TEST_KEYID" \
      --output "$WORKCFG_REPO_DIR/$name.gpg" "$WORKCFG_DATA_DIR/$name" 2>/dev/null
}
