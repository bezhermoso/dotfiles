fixture_setup

it "state round-trips a single key"
$WORKCFG_BIN _test_state_set demo plaintext_sha=abc123
assert_eq "abc123" "$($WORKCFG_BIN _test_state_get demo plaintext_sha)"
_pass_or_fail

it "state_set merges rather than truncating"
$WORKCFG_BIN _test_state_set demo ciphertext_sha=def456
assert_eq "abc123" "$($WORKCFG_BIN _test_state_get demo plaintext_sha)"
assert_eq "def456" "$($WORKCFG_BIN _test_state_get demo ciphertext_sha)"
_pass_or_fail

it "state_get returns empty for a missing key"
assert_eq "" "$($WORKCFG_BIN _test_state_get demo nope)"
_pass_or_fail

it "state_clear removes only the named keys"
$WORKCFG_BIN _test_state_clear demo ciphertext_sha
assert_eq "" "$($WORKCFG_BIN _test_state_get demo ciphertext_sha)"
assert_eq "abc123" "$($WORKCFG_BIN _test_state_get demo plaintext_sha)"
_pass_or_fail

it "state survives an empty value without corrupting other keys"
$WORKCFG_BIN _test_state_set demo blank= 2>/dev/null
assert_eq "abc123" "$($WORKCFG_BIN _test_state_get demo plaintext_sha)"
assert_eq "" "$($WORKCFG_BIN _test_state_get demo blank)"
_pass_or_fail

it "state file is 0600 and its dir 0700"
assert_eq "600" "$(stat -f '%OLp' "$WORKCFG_DATA_DIR/.state/demo.state")"
assert_eq "700" "$(stat -f '%OLp' "$WORKCFG_DATA_DIR/.state")"
_pass_or_fail

it "detects the recipient of a binary ciphertext"
seed_encrypted work-entrypoint.sh "export A=1"
assert_eq "$TEST_KEYID" "$($WORKCFG_BIN _test_recipient work-entrypoint.sh)"
_pass_or_fail

it "detects binary vs armored ciphertext"
assert_eq "0" "$($WORKCFG_BIN _test_armored work-entrypoint.sh)"
gpg --batch --yes --quiet --trust-model always --armor --encrypt \
    --recipient "0x$TEST_KEYID" --output "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg" \
    "$WORKCFG_DATA_DIR/work-entrypoint.sh" 2>/dev/null
assert_eq "1" "$($WORKCFG_BIN _test_armored work-entrypoint.post.sh)"
_pass_or_fail

fixture_teardown
