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

it "doctor passes against a healthy fixture"
seed_encrypted work-entrypoint.sh "export A=1"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1
$WORKCFG_BIN doctor >/dev/null 2>&1 || fail "doctor failed on a healthy fixture"
_pass_or_fail

it "doctor fails and names the problem when the recipient is unknown"
$WORKCFG_BIN _test_state_set work-entrypoint.sh recipient=DEADBEEFDEADBEEF
# Capture status separately: `local out=$(cmd)` sets $? from `local`, not cmd.
# Named dr_out/dr_rc, not out/rc: test_dismiss.zsh (sourced earlier in this
# same process) assigns globals named out/rc without `local`. A bare
# `local out rc` here (no assignment) then has zsh print those leftover
# global values to stdout as a side effect of the declaration itself —
# a real scoping hazard, same class as the harness's `kv`/`path` traps.
local dr_out dr_rc
dr_out="$($WORKCFG_BIN doctor 2>&1)"; dr_rc=$?
(( dr_rc == 0 )) && fail "doctor should exit non-zero for an unknown recipient"
[[ "$dr_out" == *DEADBEEFDEADBEEF* ]] || fail "doctor did not name the bad recipient: $dr_out"
_pass_or_fail

it "doctor performs a trial encrypt (finding 11 regression)"
local dr_out2
dr_out2="$($WORKCFG_BIN doctor 2>&1)"
[[ "${dr_out2:l}" == *"trial encrypt"* ]] || fail "doctor has no trial-encrypt check: $dr_out2"
_pass_or_fail

it "doctor fails the trial encrypt for a key present in the keyring but incapable of encryption"
# A key generated with Key-Usage: sign has no encryption-capable subkey, so
# `gpg --list-keys` finds it (the earlier check passes) while `--encrypt`
# genuinely fails even under --trust-model always ("Unusable public key").
# This isolates the trial-encrypt check from the keyring-presence check: a
# doctor that hardcodes the trial encrypt as passing (rather than running
# it) would report this fixture as healthy, which is exactly the silent
# false-positive this command exists to prevent.
gpg --batch --quiet --gen-key 2>/dev/null <<'EOF'
Key-Type: RSA
Key-Length: 2048
Key-Usage: sign
Name-Real: signonly
Name-Email: signonly@test.invalid
Expire-Date: 0
%no-protection
%commit
EOF
local sokey
sokey="$(gpg --batch --with-colons --list-keys signonly@test.invalid 2>/dev/null \
  | awk -F: '/^pub:/ {print $5; exit}')"
[[ -n "$sokey" ]] || fail "setup: sign-only key was not generated"
$WORKCFG_BIN _test_state_set work-entrypoint.sh recipient="$sokey"
local dr_out3 dr_rc3
dr_out3="$($WORKCFG_BIN doctor 2>&1)"; dr_rc3=$?
(( dr_rc3 == 0 )) && fail "doctor should exit non-zero when trial encrypt fails for a non-encrypting key"
[[ "$dr_out3" == *"trial encrypt to $sokey FAILED"* ]] || \
  fail "doctor did not report the trial-encrypt failure for a non-encrypting key: $dr_out3"
_pass_or_fail

fixture_teardown
