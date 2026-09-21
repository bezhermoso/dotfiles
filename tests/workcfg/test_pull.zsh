fixture_setup

it "pull decrypts a missing plaintext and marks it CLEAN"
seed_encrypted work-entrypoint.sh "export A=1"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1 || fail "pull exited non-zero"
assert_eq "export A=1" "$(<$WORKCFG_DATA_DIR/work-entrypoint.sh)"
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

it "pull records the recipient and armor form"
assert_eq "$TEST_KEYID" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh recipient)"
assert_eq "0" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh armored)"
_pass_or_fail

it "pulled plaintext is 0600"
assert_eq "600" "$(stat -f '%OLp' "$WORKCFG_DATA_DIR/work-entrypoint.sh")"
_pass_or_fail

it "a failed decrypt leaves NO plaintext behind (0-byte poison regression)"
print -rn -- "not actually gpg data" > "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
if $WORKCFG_BIN pull work-entrypoint.post.sh >/dev/null 2>&1; then
  fail "pull should have failed on garbage ciphertext"
fi
[[ -e "$WORKCFG_DATA_DIR/work-entrypoint.post.sh" ]] \
  && fail "plaintext file was created despite decrypt failure"
_pass_or_fail

it "a failed decrypt does not overwrite existing good plaintext"
seed_encrypted work-entrypoint.sh "export GOOD=1"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
snapshot_file "$WORKCFG_DATA_DIR/work-entrypoint.sh"
print -rn -- "garbage" > "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
assert_unchanged "$WORKCFG_DATA_DIR/work-entrypoint.sh"
_pass_or_fail

it "pull surfaces gpg stderr instead of swallowing it"
local out="$($WORKCFG_BIN pull work-entrypoint.sh 2>&1)"
[[ "$out" == *gpg* ]] || fail "expected gpg diagnostics in output, got: $out"
_pass_or_fail

it "pull refuses a CONFLICT without --force"
seed_encrypted work-entrypoint.sh "export A=1"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
print -rn -- "local edit" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
seed_encrypted work-entrypoint.sh "export A=99"
print -rn -- "local edit" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh CONFLICT
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
assert_eq "3" "$?"
assert_eq "local edit" "$(<$WORKCFG_DATA_DIR/work-entrypoint.sh)"
_pass_or_fail

it "pull --force overrides a CONFLICT"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
assert_eq "export A=99" "$(<$WORKCFG_DATA_DIR/work-entrypoint.sh)"
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

fixture_teardown
