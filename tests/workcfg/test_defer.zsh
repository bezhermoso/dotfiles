fixture_setup

DEFERRED_FILE="$WORKCFG_DATA_DIR/.state/work-entrypoint.sh.deferred"

it "defer turns a MISSING file into DEFERRED (driven through the real CLI)"
seed_encrypted work-entrypoint.sh "export A=1"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh MISSING
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
out="$($WORKCFG_BIN defer work-entrypoint.sh 2>&1)"
rc=$?
(( rc == 0 )) || fail "expected exit 0, got $rc: $out"
[[ "$out" == *"deferred work-entrypoint.sh"*"workcfg pull work-entrypoint.sh"* ]] \
  || fail "expected the deferral message naming the pull, got: $out"
assert_status work-entrypoint.sh DEFERRED
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
[[ -e "$WORKCFG_DATA_DIR/work-entrypoint.sh" ]] && fail "defer created a plaintext"
_pass_or_fail

it "DEFERRED is a notice, never silent (via the real CLI)"
assert_eq "notice" "$($WORKCFG_BIN _test_class DEFERRED)"
_pass_or_fail

it "defer on a file with no .state creates no .state, and a later plaintext reads UNTRACKED"
# Semantics 1: wc_status reads "the .state file exists" as "a baseline
# exists". If defer created one, this hand-placed plaintext would read as
# drift against an empty baseline (CONFLICT) instead of UNTRACKED.
[[ -e "$WORKCFG_DATA_DIR/.state/work-entrypoint.sh.state" ]] \
  && fail "defer created a .state file"
assert_eq "600" "$(stat -f '%OLp' "$DEFERRED_FILE" 2>/dev/null)"
print -rn -- "export HAND=1" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh UNTRACKED
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DEFERRED
_pass_or_fail

it "a ciphertext change after deferral brings MISSING back"
seed_encrypted work-entrypoint.sh "export A=2"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh MISSING
_pass_or_fail

it "dismiss still refuses MISSING, so nothing can silence a missing plaintext"
out="$($WORKCFG_BIN dismiss work-entrypoint.sh 2>&1)"
rc=$?
(( rc == 1 )) || fail "expected exit 1, got $rc"
[[ "$out" == *"nothing to dismiss"* ]] || fail "expected a 'nothing to dismiss' message, got: $out"
assert_status work-entrypoint.sh MISSING
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1
out="$($WORKCFG_BIN dismiss work-entrypoint.sh 2>&1)"
rc=$?
(( rc == 1 )) || fail "expected exit 1 on DEFERRED too, got $rc"
assert_status work-entrypoint.sh DEFERRED
_pass_or_fail

it "a successful pull clears the deferral, so a later MISSING prompts afresh"
assert_status work-entrypoint.sh DEFERRED
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1 || fail "pull exited non-zero"
[[ -e "$DEFERRED_FILE" ]] && fail "pull left the deferral file behind"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh MISSING
_pass_or_fail

it "defer turns a STALE file into DEFERRED; a further ciphertext change brings STALE back"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
print -rn -- "new upstream ciphertext, no local edit" > "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_status work-entrypoint.sh STALE
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
snapshot_file "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1 || fail "defer exited non-zero"
assert_status work-entrypoint.sh DEFERRED
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_unchanged "$WORKCFG_DATA_DIR/work-entrypoint.sh"
print -rn -- "a second upstream change" > "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_status work-entrypoint.sh STALE
_pass_or_fail

it "re-deferring a DEFERRED file succeeds and stays DEFERRED"
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1 || fail "first defer exited non-zero"
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1
rc=$?
(( rc == 0 )) || fail "expected exit 0 re-deferring, got $rc"
assert_status work-entrypoint.sh DEFERRED
_pass_or_fail

it "a STALE file both deferred and dismissed reads DISMISSED (explicit dismiss wins)"
$WORKCFG_BIN dismiss work-entrypoint.sh >/dev/null 2>&1 || fail "dismiss exited non-zero"
assert_status work-entrypoint.sh DISMISSED
_pass_or_fail

it "undismiss clears the deferral too, and says so"
out="$($WORKCFG_BIN undismiss work-entrypoint.sh 2>&1)"
[[ "$out" == *dismissal*deferral* ]] || fail "expected output naming both cleared, got: $out"
[[ -e "$DEFERRED_FILE" ]] && fail "undismiss left the deferral file behind"
assert_status work-entrypoint.sh STALE
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1
out="$($WORKCFG_BIN undismiss work-entrypoint.sh 2>&1)"
[[ "$out" == *deferral* && "$out" != *dismissal* ]] \
  || fail "expected output naming only the deferral, got: $out"
assert_status work-entrypoint.sh STALE
_pass_or_fail

it "push on a DEFERRED-from-STALE file behaves as on STALE, and clears the deferral"
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh DEFERRED
$WORKCFG_BIN push work-entrypoint.sh >/dev/null 2>&1 || fail "push exited non-zero"
assert_status work-entrypoint.sh CLEAN
[[ -e "$DEFERRED_FILE" ]] && fail "push left the deferral file behind"
_pass_or_fail

it "adopt --assume=local keeps the deferral (it does not pull the deferred upstream)"
# Deliberate: a deferral lasts until the upstream it was recorded against is
# actually taken. --assume=local keeps local content over that upstream, so it
# neither pulls nor brings the two sides into agreement; the deferral stays,
# dormant under DRIFTED, and resurfaces as a notice (never silent) only if the
# plaintext then vanishes while that same ciphertext is still current.
seed_encrypted work-entrypoint.sh "export UP=1"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
seed_encrypted work-entrypoint.sh "export UP=2"
print -rn -- "export UP=1" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh STALE
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1
$WORKCFG_BIN adopt --assume=local work-entrypoint.sh >/dev/null 2>&1 || fail "adopt exited non-zero"
assert_status work-entrypoint.sh DRIFTED
[[ -e "$DEFERRED_FILE" ]] || fail "adopt --assume=local removed the deferral"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DEFERRED
_pass_or_fail

it "an in-sync adopt clears the deferral (both sides now agree)"
seed_encrypted work-entrypoint.sh "export UP=3"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
# Re-encrypting identical content changes only the ciphertext sha: STALE.
seed_encrypted work-entrypoint.sh "export UP=3"
assert_status work-entrypoint.sh STALE
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1
$WORKCFG_BIN adopt work-entrypoint.sh >/dev/null 2>&1 || fail "adopt exited non-zero"
assert_status work-entrypoint.sh CLEAN
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh MISSING
_pass_or_fail

it "doctor's status section reports DEFERRED"
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1
out="$($WORKCFG_BIN doctor 2>&1)"
[[ "$out" == *"work-entrypoint.sh: DEFERRED"* ]] || fail "expected DEFERRED in doctor output, got: $out"
_pass_or_fail

it "explicit defer of a CLEAN file exits 1 with a message, and touches nothing"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh CLEAN
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
snapshot_file "$WORKCFG_DATA_DIR/work-entrypoint.sh"
out="$($WORKCFG_BIN defer work-entrypoint.sh 2>&1 >/dev/null)"
rc=$?
(( rc == 1 )) || fail "expected exit 1, got $rc"
assert_eq "workcfg: nothing to defer for work-entrypoint.sh (status: CLEAN)" "$out" "stderr: "
[[ -e "$DEFERRED_FILE" ]] && fail "a deferral was written for a CLEAN file"
assert_status work-entrypoint.sh CLEAN
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_unchanged "$WORKCFG_DATA_DIR/work-entrypoint.sh"
_pass_or_fail

it "bulk defer defers the MISSING file, leaves the CLEAN one alone, and exits 0"
seed_encrypted work-entrypoint.post.sh "export P=1"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
assert_status work-entrypoint.sh CLEAN
assert_status work-entrypoint.post.sh MISSING
$WORKCFG_BIN defer >/dev/null 2>&1
rc=$?
(( rc == 0 )) || fail "expected exit 0 for the default-list bulk path, got $rc"
assert_status work-entrypoint.post.sh DEFERRED
assert_status work-entrypoint.sh CLEAN
[[ -e "$DEFERRED_FILE" ]] && fail "bulk defer wrote a deferral for the CLEAN file"
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_unchanged "$WORKCFG_DATA_DIR/work-entrypoint.sh"
_pass_or_fail

fixture_teardown
