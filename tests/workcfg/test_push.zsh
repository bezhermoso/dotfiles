fixture_setup

it "push re-encrypts local edits and returns to CLEAN"
seed_encrypted work-entrypoint.sh "export A=1"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
print -rn -- "export A=2" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DRIFTED
$WORKCFG_BIN push work-entrypoint.sh >/dev/null 2>&1 || fail "push exited non-zero"
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

it "pushed ciphertext round-trips to the exact plaintext"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
assert_eq "export A=2" "$(<$WORKCFG_DATA_DIR/work-entrypoint.sh)"
_pass_or_fail

it "push succeeds against an untrusted recipient (finding 11 regression)"
print -rn -- "x" > "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
gpg --batch --yes --quiet --trust-model always --encrypt \
    --recipient "0x$TEST_UNTRUSTED_KEYID" \
    --output "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg" \
    "$WORKCFG_DATA_DIR/work-entrypoint.post.sh" 2>/dev/null
$WORKCFG_BIN _test_state_set work-entrypoint.post.sh recipient="$TEST_UNTRUSTED_KEYID"
$WORKCFG_BIN _test_state_set work-entrypoint.post.sh armored=0
print -rn -- "y" > "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
$WORKCFG_BIN push --force work-entrypoint.post.sh >/dev/null 2>&1 \
  || fail "push to untrusted key failed — is --trust-model always present?"
assert_eq "$TEST_UNTRUSTED_KEYID" \
          "$($WORKCFG_BIN _test_recipient work-entrypoint.post.sh)"
_pass_or_fail

it "push preserves binary form"
assert_eq "0" "$($WORKCFG_BIN _test_armored work-entrypoint.sh)"
_pass_or_fail

it "push preserves armored form when that is what the file was"
gpg --batch --yes --quiet --trust-model always --armor --encrypt \
    --recipient "0x$TEST_KEYID" --output "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg" \
    "$WORKCFG_DATA_DIR/work-entrypoint.sh" 2>/dev/null
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
assert_eq "1" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh armored)"
print -rn -- "export A=3" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN push work-entrypoint.sh >/dev/null 2>&1
assert_eq "1" "$($WORKCFG_BIN _test_armored work-entrypoint.sh)"
_pass_or_fail

it "a push to an unusable recipient leaves the ciphertext untouched"
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
$WORKCFG_BIN _test_state_set work-entrypoint.sh recipient=DEADBEEFDEADBEEF
print -rn -- "export A=4" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
if $WORKCFG_BIN push work-entrypoint.sh >/dev/null 2>&1; then
  fail "push should have failed for an unknown recipient"
fi
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
_pass_or_fail

it "push refuses a CONFLICT without --force"
$WORKCFG_BIN _test_state_set work-entrypoint.sh recipient="$TEST_KEYID"
$WORKCFG_BIN _test_state_set work-entrypoint.sh ciphertext_sha=stale-value
assert_status work-entrypoint.sh CONFLICT
$WORKCFG_BIN push work-entrypoint.sh >/dev/null 2>&1
assert_eq "3" "$?"
_pass_or_fail

fixture_teardown
