fixture_setup

it "adopt sets a CLEAN baseline when plaintext already matches ciphertext"
seed_encrypted work-entrypoint.sh "export A=1"
assert_status work-entrypoint.sh UNTRACKED
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
snapshot_file "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN adopt work-entrypoint.sh >/dev/null 2>&1 || fail "adopt exited non-zero"
assert_status work-entrypoint.sh CLEAN
# Proven against snapshots taken before adopt ran, independent of the status
# computation under test — not a tautology on wc_status's own baseline.
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_unchanged "$WORKCFG_DATA_DIR/work-entrypoint.sh"
_pass_or_fail

it "adopt records recipient and armor form"
assert_eq "$TEST_KEYID" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh recipient)"
assert_eq "0" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh armored)"
_pass_or_fail

it "adopt refuses to guess when the two sides differ"
seed_encrypted work-entrypoint.post.sh "upstream version"
print -rn -- "local version" > "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
$WORKCFG_BIN adopt work-entrypoint.post.sh >/dev/null 2>&1
assert_eq "4" "$?"
assert_status work-entrypoint.post.sh UNTRACKED
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
assert_eq "local version" "$(<$WORKCFG_DATA_DIR/work-entrypoint.post.sh)"
_pass_or_fail

it "adopt --assume=local marks the difference as DRIFTED, preserving local edits"
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
$WORKCFG_BIN adopt --assume=local work-entrypoint.post.sh >/dev/null 2>&1
assert_eq "local version" "$(<$WORKCFG_DATA_DIR/work-entrypoint.post.sh)"
assert_status work-entrypoint.post.sh DRIFTED
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
_pass_or_fail

it "adopt --assume=upstream re-pulls, discarding local edits"
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
$WORKCFG_BIN adopt --assume=upstream work-entrypoint.post.sh >/dev/null 2>&1
assert_eq "upstream version" "$(<$WORKCFG_DATA_DIR/work-entrypoint.post.sh)"
assert_status work-entrypoint.post.sh CLEAN
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
_pass_or_fail

it "a failed decrypt writes no state and leaves both payloads untouched"
print -rn -- "some content" > "$WORKCFG_DATA_DIR/bogus-name"
print -rn -- "not actually gpg data" > "$WORKCFG_REPO_DIR/bogus-name.gpg"
snapshot_file "$WORKCFG_REPO_DIR/bogus-name.gpg"
snapshot_file "$WORKCFG_DATA_DIR/bogus-name"
$WORKCFG_BIN adopt bogus-name >/dev/null 2>&1
assert_eq "1" "$?"
assert_status bogus-name UNTRACKED
assert_unchanged "$WORKCFG_REPO_DIR/bogus-name.gpg"
assert_unchanged "$WORKCFG_DATA_DIR/bogus-name"
_pass_or_fail

fixture_teardown
