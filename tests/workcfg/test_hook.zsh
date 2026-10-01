fixture_setup

# zsh/inc.work-config.zsh is sourced into the user's interactive shell, so
# every test drives it in a fresh `zsh -f`, sourced from inside a function
# exactly as .zshrc's source_config does (a top-level `typeset` in the hook
# would be local to that function and vanish; these tests would see it).
#
# No test here ever lets _workcfg_first_prompt past its terminal guard: zsh's
# `read -q` reads the controlling terminal even with stdin redirected.
HOOK="${WORKCFG_BIN:A:h:h}/zsh/inc.work-config.zsh"
HOOK_HOME="$FIXTURE_ROOT/home"          # so the hook's bzf line never loads the real plugin
mkdir -p "$HOOK_HOME"

# Runs zsh code after sourcing the hook. The prompt-suppressing variables are
# cleared so that a guard in the hook, not this environment, decides.
_hook() {
  env -u CLAUDECODE -u CI -u WORKCFG_NO_PROMPT HOME="$HOOK_HOME" \
    WORKCFG_BIN="${HOOK_BIN:-$WORKCFG_BIN}" \
    perl -e 'alarm shift; exec @ARGV' 20 \
    zsh -f -c '_src() { source "$1" }; _src "$1"; eval "$2"' _ "$HOOK" "$1" </dev/null
}

# A stand-in workcfg: logs each invocation, and answers `status` with
# $STUB_OUT (printf %b) and exit $STUB_RC.
STUB="$FIXTURE_ROOT/stub-workcfg"
STUB_LOG="$FIXTURE_ROOT/stub.log"
cat > "$STUB" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$STUB_LOG"
if [ "$1" = status ]; then printf '%b' "${STUB_OUT:-}"; exit "${STUB_RC:-0}"; fi
exit 0
EOF
chmod +x "$STUB"
export STUB_LOG

# A gpg shim first on PATH that only records that it ran.
SHIM_DIR="$FIXTURE_ROOT/gpg-shim"
GPG_MARK="$FIXTURE_ROOT/gpg-ran"
mkdir -p "$SHIM_DIR"
print -r -- "#!/bin/sh
: > '$GPG_MARK'
exit 1" > "$SHIM_DIR/gpg"
chmod +x "$SHIM_DIR/gpg"

PT="$WORKCFG_DATA_DIR/work-entrypoint.sh"
CT="$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
PT_POST="$WORKCFG_DATA_DIR/work-entrypoint.post.sh"

# Both files encrypted, decrypted and adopted: CLEAN with a real baseline.
_clean_fixture() {
  rm -rf "$WORKCFG_DATA_DIR/.state"
  seed_encrypted work-entrypoint.sh "export PRE=1"
  seed_encrypted work-entrypoint.post.sh "export POST=1"
  $WORKCFG_BIN adopt >/dev/null 2>&1 </dev/null || fail "adopt exited non-zero"
  assert_status work-entrypoint.sh CLEAN
  assert_status work-entrypoint.post.sh CLEAN
}

_unchanged() { _hook '_workcfg_unchanged; print -r -- $?' }
_registered() { _hook 'print -r -- ${#${(@M)precmd_functions:#_workcfg_first_prompt}}' }

it "sourcing on a CLEAN fixture prints nothing, forks neither gpg nor workcfg, registers no hook"
_clean_fixture
rm -f "$GPG_MARK" "$STUB_LOG"
out="$(PATH="$SHIM_DIR:$PATH" HOOK_BIN="$STUB" _hook 'print -r -- "REG=${#${(@M)precmd_functions:#_workcfg_first_prompt}}"' 2>&1)"
assert_eq "REG=0" "$out" "output: "
[[ -e "$GPG_MARK" ]] && fail "sourcing ran gpg"
[[ -e "$STUB_LOG" ]] && fail "sourcing ran workcfg: $(<$STUB_LOG)"
_pass_or_fail

it "sourcing with drift still prints nothing and forks neither gpg nor workcfg"
print -r -- "export LOCAL=1" >> "$PT"
rm -f "$GPG_MARK" "$STUB_LOG"
out="$(PATH="$SHIM_DIR:$PATH" HOOK_BIN="$STUB" _hook 'print -r -- "REG=${#${(@M)precmd_functions:#_workcfg_first_prompt}}"' 2>&1)"
assert_eq "REG=1" "$out" "output: "
[[ -e "$GPG_MARK" ]] && fail "sourcing ran gpg"
[[ -e "$STUB_LOG" ]] && fail "sourcing ran workcfg: $(<$STUB_LOG)"
_pass_or_fail

it "sourcing exports both WORK_CONFIG_DECRYPTED_* paths under WORKCFG_DATA_DIR"
out="$(_hook 'print -r -- "$WORK_CONFIG_DECRYPTED_PRE|$WORK_CONFIG_DECRYPTED_POST"; env | grep -c "^WORK_CONFIG_DECRYPTED_"')"
assert_eq "$PT|$PT_POST"$'\n'"2" "$out"
_pass_or_fail

it "without WORKCFG_BIN the bin resolves from WORKCFG_REPO_DIR, not PATH"
out="$(env -u WORKCFG_BIN -u CLAUDECODE HOME="$HOOK_HOME" WORKCFG_REPO_DIR=/nowhere/zsh PATH=/usr/bin:/bin \
  perl -e 'alarm shift; exec @ARGV' 20 zsh -f -c '_src() { source "$1" }; _src "$1"
    print -r -- "$_workcfg_bin ${#${(@M)precmd_functions:#_workcfg_first_prompt}}"' _ "$HOOK" </dev/null 2>&1)"
assert_eq "/nowhere/bin/workcfg 1" "$out" "bin, registered: "
_pass_or_fail

it "_workcfg_unchanged is 0 on a CLEAN, adopted fixture"
_clean_fixture
assert_eq "0" "$(_unchanged)"
_pass_or_fail

it "_workcfg_unchanged is 1 once the plaintext is edited"
print -r -- "export LOCAL=1" >> "$PT"
assert_eq "1" "$(_unchanged)"
_pass_or_fail

it "_workcfg_unchanged is 1 when only the plaintext mtime moves (same size, same content)"
_clean_fixture
touch -t 202001010000 "$PT"
assert_status work-entrypoint.sh CLEAN
assert_eq "1" "$(_unchanged)"
_pass_or_fail

it "_workcfg_unchanged is 1 once the ciphertext changes"
_clean_fixture
print -rn -- "x" >> "$CT"
assert_eq "1" "$(_unchanged)"
_pass_or_fail

it "_workcfg_unchanged is 1 when only the ciphertext mtime moves"
_clean_fixture
touch -t 202001010000 "$CT"
assert_eq "1" "$(_unchanged)"
_pass_or_fail

it "_workcfg_unchanged is 1 when the plaintext is deleted, or emptied"
_clean_fixture
rm -f "$PT"
assert_eq "1" "$(_unchanged)" "deleted: "
_clean_fixture
: >| "$PT"
assert_eq "1" "$(_unchanged)" "emptied: "
_pass_or_fail

it "_workcfg_unchanged is 1 when the state file, or the ciphertext, is deleted"
_clean_fixture
rm -f "$WORKCFG_DATA_DIR/.state/work-entrypoint.sh.state"
assert_eq "1" "$(_unchanged)" "state: "
_clean_fixture
rm -f "$CT"
assert_eq "1" "$(_unchanged)" "ciphertext: "
_pass_or_fail

it "_workcfg_unchanged checks the second file too (post edited, pre clean)"
_clean_fixture
print -r -- "export LOCAL=1" >> "$PT_POST"
assert_eq "1" "$(_unchanged)"
_pass_or_fail

it "_workcfg_unchanged is 1 on the adopt --assume=local sentinel (always recompute)"
_clean_fixture
rm -f "$WORKCFG_DATA_DIR/.state/work-entrypoint.sh.state"
print -r -- "export LOCAL=1" >> "$PT"
$WORKCFG_BIN adopt --assume=local work-entrypoint.sh >/dev/null 2>&1 </dev/null || fail "adopt --assume=local failed"
assert_eq "0" "$($WORKCFG_BIN _test_state_get work-entrypoint.sh plaintext_mtime)" "sentinel mtime: "
assert_status work-entrypoint.sh DRIFTED
# The plaintext is untouched since adopt, so only the 0/0 sentinel can make
# the cheap check inconclusive here.
assert_eq "1" "$(_unchanged)"
_pass_or_fail

it "the precmd hook is registered iff _workcfg_unchanged is false"
_clean_fixture
assert_eq "0" "$(_registered)" "clean: "
print -r -- "export LOCAL=1" >> "$PT"
assert_eq "1" "$(_registered)" "drifted: "
_pass_or_fail

it "a missing workcfg on a clean work host still registers the hook (it says so at first prompt)"
_clean_fixture
assert_eq "1" "$(HOOK_BIN="$FIXTURE_ROOT/no-such-workcfg" _registered)"
_pass_or_fail

it "a non-matching host registers nothing, even with drift"
print -r -- "export LOCAL=1" >> "$PT"
assert_eq "0" "$(WORKCFG_HOST_PATTERN='^no-such-host$' _registered)"
_pass_or_fail

it "_workcfg_lock_acquire works on a fresh machine with no .state, and creates it 0700"
FRESH="$FIXTURE_ROOT/fresh-data"
rm -rf "$FRESH"; mkdir -p "$FRESH"
out="$(WORKCFG_DATA_DIR="$FRESH" _hook '
  _workcfg_lock_acquire "$WORKCFG_DATA_DIR/.state/.lock"; print -r -- "rc=$?"
  [[ "$(<$WORKCFG_DATA_DIR/.state/.lock/pid)" == $$ ]] && print -r -- "pid=mine"')"
assert_eq "rc=0"$'\n'"pid=mine" "$out"
assert_eq "700" "$(stat -f '%OLp' "$FRESH/.state" 2>/dev/null)" ".state mode: "
rm -rf "$FRESH"
out="$(WORKCFG_DATA_DIR="$FRESH" _hook '_workcfg_lock_acquire "$WORKCFG_DATA_DIR/.state/.lock"; print -r -- "rc=$?"')"
assert_eq "rc=0" "$out" "no data dir at all: "
[[ -d "$FRESH/.state/.lock" ]] || fail "no lock dir created when the data dir was absent"
_pass_or_fail

LOCK="$WORKCFG_DATA_DIR/.state/.lock"
_acquire() { _hook '_workcfg_lock_acquire "$WORKCFG_DATA_DIR/.state/.lock"; print -r -- "rc=$?"' }

it "_workcfg_lock_acquire refuses while a live pid holds the lock"
rm -rf "$LOCK"; mkdir -p "$LOCK"; print -r -- $$ > "$LOCK/pid"
assert_eq "rc=1" "$(_acquire)"
assert_eq "$$" "$(<$LOCK/pid)" "holder: "
_pass_or_fail

it "_workcfg_lock_acquire reclaims a lock whose pid is dead"
dead="$(zsh -fc 'print $$')"
rm -rf "$LOCK"; mkdir -p "$LOCK"; print -r -- "$dead" > "$LOCK/pid"
out="$(_hook '_workcfg_lock_acquire "$WORKCFG_DATA_DIR/.state/.lock"; print -r -- "rc=$? $$"')"
assert_eq "rc=0 $(<$LOCK/pid)" "$out" "rc and new holder: "
[[ "$(<$LOCK/pid)" != "$dead" ]] || fail "the dead pid still holds the lock"
_pass_or_fail

it "_workcfg_lock_acquire refuses a pid-less lock under 10s old (holder mid-acquire)"
rm -rf "$LOCK"; mkdir -p "$LOCK"
assert_eq "rc=1" "$(_acquire)"
[[ -d "$LOCK" && ! -e "$LOCK/pid" ]] || fail "the young pid-less lock was reclaimed"
_pass_or_fail

it "_workcfg_lock_acquire reclaims a pid-less lock older than 10s"
rm -rf "$LOCK"; mkdir -p "$LOCK"; touch -t 202001010000 "$LOCK"
assert_eq "rc=0" "$(_acquire)"
[[ -s "$LOCK/pid" ]] || fail "reclaimed lock has no pid"
_pass_or_fail

it "_workcfg_lock_release removes only a lock this shell holds"
rm -rf "$LOCK"; mkdir -p "$LOCK"; print -r -- $$ > "$LOCK/pid"
_hook '_workcfg_lock_release "$WORKCFG_DATA_DIR/.state/.lock"'
[[ -d "$LOCK" ]] || fail "released another shell's lock"
rm -rf "$LOCK"
out="$(_hook '_workcfg_lock_acquire "$WORKCFG_DATA_DIR/.state/.lock"; _workcfg_lock_release "$WORKCFG_DATA_DIR/.state/.lock"; print -r -- "rc=$?"')"
assert_eq "rc=0" "$out"
[[ -e "$LOCK" ]] && fail "own lock survived release"
_pass_or_fail

REPORT_ERR="$FIXTURE_ROOT/report.err"
# Runs _workcfg_report against the stub; stdout is the prompt names plus
# "rc=N", stderr lands in $REPORT_ERR.
_report() { HOOK_BIN="${HOOK_BIN:-$STUB}" _hook '_workcfg_report; print -r -- "rc=$?"' 2>"$REPORT_ERR" }

it "_workcfg_report prints the DEFERRED notice and asks for no prompt"
rm -f "$STUB_LOG"
out="$(STUB_OUT='work-entrypoint.sh DEFERRED\nwork-entrypoint.post.sh CLEAN\n' STUB_RC=1 _report)"
assert_eq "rc=0" "$out" "stdout: "
assert_eq "⚠ work-entrypoint.sh needs decrypting (deferred) — workcfg pull work-entrypoint.sh" "$(<$REPORT_ERR)" "stderr: "
assert_eq "status --porcelain" "$(<$STUB_LOG)" "workcfg called as: "
_pass_or_fail

it "_workcfg_report prints a generic notice for an unknown status, never drops it"
out="$(STUB_OUT='work-entrypoint.sh FROBNICATED\n' STUB_RC=1 _report)"
assert_eq "rc=0" "$out" "stdout: "
assert_eq "⚠ work-entrypoint.sh: FROBNICATED — run: workcfg status" "$(<$REPORT_ERR)" "stderr: "
_pass_or_fail

it "_workcfg_report says status failed when workcfg exits 2, and asks for no prompt"
out="$(STUB_OUT='work-entrypoint.sh MISSING\n' STUB_RC=2 _report)"
assert_eq "rc=1" "$out" "stdout: "
assert_eq "⚠ workcfg status failed (rc=2) — run: workcfg doctor" "$(<$REPORT_ERR)" "stderr: "
_pass_or_fail

it "_workcfg_report says status failed when workcfg prints nothing"
out="$(STUB_OUT='' STUB_RC=0 _report)"
assert_eq "rc=1" "$out" "stdout: "
assert_eq "⚠ workcfg status failed (rc=0) — run: workcfg doctor" "$(<$REPORT_ERR)" "stderr: "
_pass_or_fail

it "_workcfg_report says so when workcfg is not there at all"
out="$(HOOK_BIN="$FIXTURE_ROOT/no-such-workcfg" _report)"
assert_eq "rc=1" "$out" "stdout: "
assert_eq "⚠ workcfg not found at $FIXTURE_ROOT/no-such-workcfg — work config unmanaged" "$(<$REPORT_ERR)" "stderr: "
_pass_or_fail

it "_workcfg_report returns MISSING and STALE as prompts, silently"
out="$(STUB_OUT='work-entrypoint.sh MISSING\nwork-entrypoint.post.sh STALE\n' STUB_RC=1 _report)"
assert_eq "work-entrypoint.sh"$'\n'"work-entrypoint.post.sh"$'\n'"rc=0" "$out" "stdout: "
assert_eq "" "$(<$REPORT_ERR)" "stderr: "
_pass_or_fail

it "_workcfg_report is silent for CLEAN, DISMISSED and UNMANAGED"
out="$(STUB_OUT='a CLEAN\nb DISMISSED\nc UNMANAGED\n' STUB_RC=0 _report)"
assert_eq "rc=0" "$out" "stdout: "
assert_eq "" "$(<$REPORT_ERR)" "stderr: "
_pass_or_fail

it "_workcfg_report names the remedy for DRIFTED, CONFLICT and UNTRACKED"
out="$(STUB_OUT='a DRIFTED\nb CONFLICT\nc UNTRACKED\n' STUB_RC=1 _report)"
assert_eq "rc=0" "$out" "stdout: "
assert_eq "⚠ a drifted — workcfg push a · workcfg dismiss a"$'\n'"⚠ b changed on both sides — workcfg diff b"$'\n'"⚠ c has no baseline — workcfg adopt c" \
  "$(<$REPORT_ERR)" "stderr: "
_pass_or_fail

it "_workcfg_report against the real CLI: MISSING prompts, DEFERRED notices"
_clean_fixture
rm -f "$PT"
out="$(HOOK_BIN="$WORKCFG_BIN" _report)"
assert_eq "work-entrypoint.sh"$'\n'"rc=0" "$out" "MISSING stdout: "
assert_eq "" "$(<$REPORT_ERR)" "MISSING stderr: "
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1 </dev/null
out="$(HOOK_BIN="$WORKCFG_BIN" _report)"
assert_eq "rc=0" "$out" "DEFERRED stdout: "
assert_eq "⚠ work-entrypoint.sh needs decrypting (deferred) — workcfg pull work-entrypoint.sh" "$(<$REPORT_ERR)" "DEFERRED stderr: "
_pass_or_fail

it "_workcfg_first_prompt without a terminal: silent, forks nothing, unhooks itself"
rm -f "$STUB_LOG"
out="$(STUB_OUT='work-entrypoint.sh MISSING\n' STUB_RC=1 HOOK_BIN="$STUB" _hook '
  print -r -- "before=${#${(@M)precmd_functions:#_workcfg_first_prompt}}"
  _workcfg_first_prompt
  print -r -- "after=${#${(@M)precmd_functions:#_workcfg_first_prompt}} fn=$+functions[_workcfg_first_prompt]"' 2>&1)"
assert_eq "before=1"$'\n'"after=0 fn=0" "$out" "output: "
[[ -e "$STUB_LOG" ]] && fail "ran workcfg before the terminal guard: $(<$STUB_LOG)"
_pass_or_fail

it "_workcfg_first_prompt in an interactive shell on a pty, stdin redirected: never prompts"
# Everything but stdin is a terminal here, so only the -t 0 guard stands
# between this call and `read -q` on script(1)'s pty. The "y" typed into the
# pty would answer a prompt that must never appear.
rm -f "$STUB_LOG"
out="$( { sleep 1; print y } | env -u CLAUDECODE -u CI -u WORKCFG_NO_PROMPT TERM=xterm-256color \
  HOME="$HOOK_HOME" WORKCFG_BIN="$STUB" STUB_OUT='work-entrypoint.sh MISSING\n' STUB_RC=1 \
  perl -e 'alarm shift; exec @ARGV' 20 script -q /dev/null zsh -f -i -c '
    _src() { source "$1" }; _src "$1"
    [[ -o interactive && -t 1 && -t 2 && "$TERM" != dumb ]] && print -r -- PRECOND_OK
    _workcfg_first_prompt </dev/null
    print -r -- DONE' _ "$HOOK" 2>&1)"
[[ "$out" == *PRECOND_OK* ]] || fail "the pty shell was not interactive with a terminal on 1/2: $out"
[[ "$out" == *DONE* ]]       || fail "the shell did not finish: $out"
[[ "$out" == *(Decrypt|decrypting|Deferred)* ]] && fail "first_prompt prompted: $out"
[[ -e "$STUB_LOG" ]] && fail "ran workcfg despite no terminal on stdin: $(<$STUB_LOG)"
_pass_or_fail

it "the hook leaks no parameters into the shell beyond _workcfg_*/WORKCFG_*/WORK_CONFIG_*"
_clean_fixture
out="$(env -u CLAUDECODE HOME="$HOOK_HOME" WORKCFG_BIN="$STUB" STUB_RC=1 \
  STUB_OUT='a MISSING\nb STALE\nc DRIFTED\nd CONFLICT\ne UNTRACKED\nf DEFERRED\ng FROB\nh CLEAN\n' \
  perl -e 'alarm shift; exec @ARGV' 20 zsh -f -c '
    typeset -ga _t_before _t_after _t_leak
    _t_before=(${(k)parameters})
    _src() { source "$1" }; _src "$1"
    _workcfg_unchanged
    _workcfg_report >/dev/null
    _workcfg_lock_acquire "$WORKCFG_DATA_DIR/.state/.lock"
    _workcfg_lock_release "$WORKCFG_DATA_DIR/.state/.lock"
    _workcfg_first_prompt
    _t_after=(${(k)parameters})
    _t_leak=(${${_t_after:|_t_before}:#(_workcfg_*|WORKCFG_*|WORK_CONFIG_*|_t_*|precmd_functions|EPOCHSECONDS)})
    (( $#_t_leak )) && print -rl -- $_t_leak
    print -r -- "traps=[$(trap)]"' _ "$HOOK" </dev/null 2>/dev/null)"
assert_eq "traps=[]" "$out" "leaked: "
_pass_or_fail

it "the hook parses and compiles (zsh -n, zcompile to a scratch file)"
zsh -n "$HOOK" 2>&1 || fail "zsh -n failed"
zsh -fc 'zcompile "$1" "$2"' _ "$FIXTURE_ROOT/hook-compiled" "$HOOK" 2>&1 || fail "zcompile failed"
[[ -s "$FIXTURE_ROOT/hook-compiled.zwc" ]] || fail "zcompile wrote no .zwc"
_pass_or_fail

fixture_teardown
