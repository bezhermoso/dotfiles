fixture_setup
seed_encrypted work-entrypoint.sh "export A=1"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1

it "dismiss silences a DRIFTED file"
print -rn -- "export A=2" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DRIFTED
$WORKCFG_BIN dismiss work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh DISMISSED
_pass_or_fail

it "dismissal survives an unrelated re-check"
assert_status work-entrypoint.sh DISMISSED
_pass_or_fail

it "editing the file again expires the dismissal"
print -rn -- "export A=3" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DRIFTED
_pass_or_fail

it "reverting to the dismissed content re-silences it"
print -rn -- "export A=2" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DISMISSED
_pass_or_fail

it "a ciphertext change expires the dismissal even if plaintext is unchanged"
print -rn -- "new upstream" > "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_status work-entrypoint.sh CONFLICT
_pass_or_fail

it "dismiss also silences a CONFLICT"
$WORKCFG_BIN dismiss work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh DISMISSED
_pass_or_fail

it "undismiss restores the underlying status"
$WORKCFG_BIN undismiss work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh CONFLICT
_pass_or_fail

it "dismiss silences a STALE file (driven through the real CLI, not state keys)"
seed_encrypted work-entrypoint.sh "export S=1"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh CLEAN
print -rn -- "new upstream ciphertext, no local edit" > "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_status work-entrypoint.sh STALE
$WORKCFG_BIN dismiss work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh DISMISSED
_pass_or_fail

it "explicit dismiss of a CLEAN file exits 1 with a message, and touches nothing"
seed_encrypted work-entrypoint.sh "export A=1"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh CLEAN
out="$($WORKCFG_BIN dismiss work-entrypoint.sh 2>&1)"
rc=$?
(( rc == 1 )) || fail "expected exit 1, got $rc"
[[ "$out" == *"nothing to dismiss"* ]] || fail "expected a 'nothing to dismiss' message, got: $out"
assert_status work-entrypoint.sh CLEAN
assert_eq "" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh dismissed_sha)"
_pass_or_fail

it "dismiss with no args over a default list containing a CLEAN file exits 0"
# work-entrypoint.sh is CLEAN (from the prior test). work-entrypoint.post.sh
# is UNMANAGED (never seeded), so neither default-list target is dismissible
# — this is the regression test for the dispatch falling through with no
# exit and inheriting the last failed condition's status.
$WORKCFG_BIN dismiss >/dev/null 2>&1
rc=$?
(( rc == 0 )) || fail "expected exit 0 for the default-list bulk path, got $rc"
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

it "push clears any dismissal"
seed_encrypted work-entrypoint.sh "export A=1"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
print -rn -- "export A=9" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN dismiss work-entrypoint.sh >/dev/null 2>&1
$WORKCFG_BIN push --force work-entrypoint.sh >/dev/null 2>&1
assert_eq "" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh dismissed_sha)"
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

it "pull clears any dismissal"
seed_encrypted work-entrypoint.sh "export A=10"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
print -rn -- "export A=11" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN dismiss work-entrypoint.sh >/dev/null 2>&1
assert_status work-entrypoint.sh DISMISSED
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
assert_eq "" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh dismissed_sha)"
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

fixture_teardown
