#!/usr/bin/env zsh
fixture_setup

it "fixture generates a usable encryption key"
[[ -n "$TEST_KEYID" ]] || fail "TEST_KEYID empty"
_pass_or_fail

it "fixture key round-trips without a passphrase"
print -rn -- "hello" > "$FIXTURE_ROOT/plain"
gpg --batch --yes --quiet --trust-model always --encrypt \
    --recipient "0x$TEST_KEYID" --output "$FIXTURE_ROOT/ct" "$FIXTURE_ROOT/plain" 2>/dev/null
gpg --batch --quiet --decrypt --output "$FIXTURE_ROOT/rt" "$FIXTURE_ROOT/ct" 2>/dev/null
assert_eq "hello" "$(<$FIXTURE_ROOT/rt)"
_pass_or_fail

it "untrusted key is present but has no ownertrust"
[[ -n "$TEST_UNTRUSTED_KEYID" ]] || fail "TEST_UNTRUSTED_KEYID empty"
if gpg --batch --yes --quiet --encrypt --recipient "0x$TEST_UNTRUSTED_KEYID" \
       --output /dev/null "$FIXTURE_ROOT/plain" 2>/dev/null; then
  fail "expected encrypt to untrusted key to fail without --trust-model always"
fi
_pass_or_fail

fixture_teardown
