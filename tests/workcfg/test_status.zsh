fixture_setup

it "UNMANAGED when no ciphertext exists"
assert_status work-entrypoint.sh UNMANAGED
_pass_or_fail

it "MISSING when ciphertext exists but plaintext does not"
seed_encrypted work-entrypoint.sh "export A=1"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh MISSING
_pass_or_fail

it "MISSING when plaintext exists but is empty (the 0-byte poison case)"
: > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh MISSING
_pass_or_fail

it "UNTRACKED when plaintext exists but no state file does"
seed_encrypted work-entrypoint.sh "export A=1"
assert_status work-entrypoint.sh UNTRACKED
_pass_or_fail

it "CLEAN once a baseline is recorded"
$WORKCFG_BIN _test_baseline work-entrypoint.sh
assert_status work-entrypoint.sh CLEAN
_pass_or_fail

it "DRIFTED after the plaintext is edited"
print -rn -- "export A=2" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DRIFTED
_pass_or_fail

it "STALE when only the ciphertext changed"
$WORKCFG_BIN _test_baseline work-entrypoint.sh
print -rn -- "different ciphertext" > "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
assert_status work-entrypoint.sh STALE
_pass_or_fail

it "CONFLICT when both sides changed"
print -rn -- "export A=3" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh CONFLICT
_pass_or_fail

it "DISMISSED once a recorded dismissal matches the current drift"
$WORKCFG_BIN _test_baseline work-entrypoint.sh
print -rn -- "export A=5" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
DISMISS_P_SHA="$(sha_of "$WORKCFG_DATA_DIR/work-entrypoint.sh")"
DISMISS_C_SHA="$(sha_of "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg")"
$WORKCFG_BIN _test_state_set work-entrypoint.sh \
  dismissed_sha="$DISMISS_P_SHA" dismissed_ciphertext_sha="$DISMISS_C_SHA"
assert_status work-entrypoint.sh DISMISSED
_pass_or_fail

it "returns to DRIFTED once the plaintext changes again after a dismissal"
print -rn -- "export A=6" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DRIFTED
_pass_or_fail

it "wc_status_class maps each status to its prompt/notice/silent bucket"
assert_eq "prompt" "$($WORKCFG_BIN _test_class MISSING)"
assert_eq "prompt" "$($WORKCFG_BIN _test_class STALE)"
assert_eq "notice" "$($WORKCFG_BIN _test_class CONFLICT)"
assert_eq "notice" "$($WORKCFG_BIN _test_class DRIFTED)"
assert_eq "notice" "$($WORKCFG_BIN _test_class UNTRACKED)"
assert_eq "silent" "$($WORKCFG_BIN _test_class CLEAN)"
assert_eq "silent" "$($WORKCFG_BIN _test_class DISMISSED)"
assert_eq "silent" "$($WORKCFG_BIN _test_class UNMANAGED)"
_pass_or_fail

it "baseline records mtime and size for the stat fast path"
seed_encrypted work-entrypoint.post.sh "export B=1"
$WORKCFG_BIN _test_baseline work-entrypoint.post.sh
assert_eq "$(stat -f '%z' "$WORKCFG_DATA_DIR/work-entrypoint.post.sh")" \
          "$($WORKCFG_BIN _test_state_get work-entrypoint.post.sh plaintext_size)"
[[ -n "$($WORKCFG_BIN _test_state_get work-entrypoint.post.sh plaintext_mtime)" ]] \
  || fail "plaintext_mtime not recorded"
assert_eq "$(sha_of "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg")" \
          "$($WORKCFG_BIN _test_state_get work-entrypoint.post.sh ciphertext_sha)"
assert_eq "$(stat -f '%z' "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg")" \
          "$($WORKCFG_BIN _test_state_get work-entrypoint.post.sh ciphertext_size)"
[[ -n "$($WORKCFG_BIN _test_state_get work-entrypoint.post.sh ciphertext_mtime)" ]] \
  || fail "ciphertext_mtime not recorded"
[[ -n "$($WORKCFG_BIN _test_state_get work-entrypoint.post.sh synced_at)" ]] \
  || fail "synced_at not recorded"
_pass_or_fail

it "status exits 0 when everything is CLEAN"
rm -rf "$WORKCFG_REPO_DIR" "$WORKCFG_DATA_DIR"
mkdir -p "$WORKCFG_REPO_DIR" "$WORKCFG_DATA_DIR"
seed_encrypted work-entrypoint.sh "export A=1"
seed_encrypted work-entrypoint.post.sh "export B=1"
$WORKCFG_BIN adopt >/dev/null 2>&1 </dev/null
$WORKCFG_BIN status >/dev/null 2>&1 </dev/null
assert_eq "0" "$?"
_pass_or_fail

it "status exits 1 when something needs action"
print -rn -- "edited" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN status >/dev/null 2>&1 </dev/null
assert_eq "1" "$?"
_pass_or_fail

it "status exits 0 when the only change is dismissed"
$WORKCFG_BIN dismiss work-entrypoint.sh >/dev/null 2>&1 </dev/null
$WORKCFG_BIN status >/dev/null 2>&1 </dev/null
assert_eq "0" "$?"
_pass_or_fail

it "porcelain emits one '<name> <STATUS>' line per file"
plines=("${(@f)$($WORKCFG_BIN status --porcelain </dev/null)}")
assert_eq "2" "${#plines}"
assert_eq "work-entrypoint.sh DISMISSED" "${plines[1]}"
assert_eq "work-entrypoint.post.sh CLEAN" "${plines[2]}"
_pass_or_fail

it "json output is parseable and carries every status"
js="$($WORKCFG_BIN status --json </dev/null)"
[[ "$js" == *'"name":"work-entrypoint.sh"'* ]]      || fail "json missing name: $js"
[[ "$js" == *'"status":"DISMISSED"'* ]]             || fail "json missing status: $js"
[[ "$js" == *'"name":"work-entrypoint.post.sh"'* ]] || fail "json missing second name: $js"
[[ "$js" == *'"status":"CLEAN"'* ]]                 || fail "json missing CLEAN: $js"
# JSON::PP ships with the system perl, so this needs no extra dependency.
print -r -- "$js" | perl -MJSON::PP -e 'exit(@{decode_json(join "", <STDIN>)} == 2 ? 0 : 1)' \
  2>/dev/null || fail "json does not parse as a 2-element array: $js"
_pass_or_fail

fixture_teardown
