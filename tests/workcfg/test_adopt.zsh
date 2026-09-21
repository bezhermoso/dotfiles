fixture_setup

it "adopt sets a CLEAN baseline when plaintext already matches ciphertext"
seed_encrypted work-entrypoint.sh "export A=1"
assert_status work-entrypoint.sh UNTRACKED
$WORKCFG_BIN adopt work-entrypoint.sh >/dev/null 2>&1 || fail "adopt exited non-zero"
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

it "adopt records recipient and armor form"
assert_eq "$TEST_KEYID" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh recipient)"
assert_eq "0" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh armored)"
_pass_or_fail

it "adopt refuses to guess when the two sides differ"
seed_encrypted work-entrypoint.post.sh "upstream version"
print -rn -- "local version" > "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
$WORKCFG_BIN adopt work-entrypoint.post.sh >/dev/null 2>&1
assert_eq "4" "$?"
assert_status work-entrypoint.post.sh UNTRACKED
_pass_or_fail

it "adopt --assume=local marks the difference as DRIFTED, preserving local edits"
$WORKCFG_BIN adopt --assume=local work-entrypoint.post.sh >/dev/null 2>&1
assert_eq "local version" "$(<$WORKCFG_DATA_DIR/work-entrypoint.post.sh)"
assert_status work-entrypoint.post.sh DRIFTED
_pass_or_fail

it "adopt --assume=upstream re-pulls, discarding local edits"
$WORKCFG_BIN adopt --assume=upstream work-entrypoint.post.sh >/dev/null 2>&1
assert_eq "upstream version" "$(<$WORKCFG_DATA_DIR/work-entrypoint.post.sh)"
assert_status work-entrypoint.post.sh CLEAN
_pass_or_fail

fixture_teardown
