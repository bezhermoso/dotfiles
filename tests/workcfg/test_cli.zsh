fixture_setup
export PAGER=cat GIT_PAGER=cat

# A private TMPDIR for every workcfg call in this file, so "diff wrote nothing
# to $TMPDIR" is checkable without racing other processes on the real one.
CLI_TMPDIR="$FIXTURE_ROOT/tmp"
mkdir -p "$CLI_TMPDIR"

# Lists a directory's entries, dotfiles included, one per line.
_listing() { ls -A "$1" 2>/dev/null }

# A non-interactive $EDITOR. It demands its own flag, which proves workcfg
# word-splits $EDITOR, and it replaces the file by rename at 0644 the way
# vim's backupcopy=no does, which proves edit re-hardens the mode afterwards.
FAKE_EDITOR="$FIXTURE_ROOT/fake-editor"
cat > "$FAKE_EDITOR" <<'EOF'
#!/bin/sh
[ "$1" = "--append" ] || { echo "fake-editor: expected --append, got '$1'" >&2; exit 9; }
: > "${WORKCFG_TEST_EDITOR_RAN:-/dev/null}"
cp "$2" "$2.fake-editor"
printf '\nexport EDITED=1' >> "$2.fake-editor"
chmod 644 "$2.fake-editor"
mv -f "$2.fake-editor" "$2"
EOF
chmod +x "$FAKE_EDITOR"
EDITOR_MARK="$FIXTURE_ROOT/editor-ran"

it "status exits 1 for a DEFERRED file and shows the DEFERRED hint"
seed_encrypted work-entrypoint.sh "export A=1"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN defer work-entrypoint.sh >/dev/null 2>&1 </dev/null
assert_status work-entrypoint.sh DEFERRED
out="$($WORKCFG_BIN status 2>&1 </dev/null)"
rc=$?
assert_eq "1" "$rc" "exit: "
[[ "$out" == *"work-entrypoint.sh"*"DEFERRED"*"decrypt deferred — run: workcfg pull work-entrypoint.sh"* ]] \
  || fail "expected the DEFERRED hint, got: $out"
_pass_or_fail

it "status rejects an unknown flag with exit 2"
out="$($WORKCFG_BIN status --bogus 2>&1 >/dev/null </dev/null)"
rc=$?
assert_eq "2" "$rc" "exit: "
[[ "$out" == *"--bogus"* ]] || fail "expected stderr to name the flag, got: $out"
_pass_or_fail

it "status --porcelain-one with no name exits 2"
$WORKCFG_BIN status --porcelain-one >/dev/null 2>&1 </dev/null
assert_eq "2" "$?"
_pass_or_fail

it "status never changes permissions"
$WORKCFG_BIN pull work-entrypoint.sh >/dev/null 2>&1 </dev/null
chmod 755 "$WORKCFG_DATA_DIR"
chmod 644 "$WORKCFG_DATA_DIR/work-entrypoint.sh"
$WORKCFG_BIN status >/dev/null 2>&1 </dev/null
$WORKCFG_BIN status --json >/dev/null 2>&1 </dev/null
$WORKCFG_BIN status --porcelain >/dev/null 2>&1 </dev/null
assert_eq "755" "$(stat -f '%OLp' "$WORKCFG_DATA_DIR")" "data dir: "
assert_eq "644" "$(stat -f '%OLp' "$WORKCFG_DATA_DIR/work-entrypoint.sh")" "plaintext: "
chmod 700 "$WORKCFG_DATA_DIR"
chmod 600 "$WORKCFG_DATA_DIR/work-entrypoint.sh"
_pass_or_fail

it "diff on a CLEAN file exits 0 with empty output"
assert_status work-entrypoint.sh CLEAN
out="$(TMPDIR="$CLI_TMPDIR" $WORKCFG_BIN diff work-entrypoint.sh 2>&1 </dev/null)"
rc=$?
assert_eq "0" "$rc" "exit: "
assert_eq "" "$out" "output: "
_pass_or_fail

it "diff on a DRIFTED file exits 1 and shows the edited line"
print -r -- "export A=2" > "$WORKCFG_DATA_DIR/work-entrypoint.sh"
assert_status work-entrypoint.sh DRIFTED
data_before="$(_listing "$WORKCFG_DATA_DIR")"
repo_before="$(_listing "$WORKCFG_REPO_DIR")"
tmp_before="$(_listing "$CLI_TMPDIR")"
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
out="$(TMPDIR="$CLI_TMPDIR" $WORKCFG_BIN diff work-entrypoint.sh 2>&1 </dev/null)"
rc=$?
assert_eq "1" "$rc" "exit: "
[[ "$out" == *"-export A=1"*"+export A=2"* ]] || fail "expected the edited line in the diff, got: $out"
[[ "$out" == *"encrypted/work-entrypoint.sh"*"local/work-entrypoint.sh"* ]] \
  || fail "expected labelled sides, got: $out"
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
_pass_or_fail

it "diff leaves no temp behind in the data dir, \$TMPDIR or the repo"
[[ -n "$(print -l -- $WORKCFG_DATA_DIR/*.diff.*(N))" ]] && fail "a *.diff.* temp remains in the data dir"
assert_eq "$data_before" "$(_listing "$WORKCFG_DATA_DIR")" "data dir listing: "
assert_eq "$repo_before" "$(_listing "$WORKCFG_REPO_DIR")" "repo listing: "
assert_eq "$tmp_before"  "$(_listing "$CLI_TMPDIR")"       "TMPDIR listing: "
_pass_or_fail

it "diff reads the decrypted copy from the data dir at mode 600"
# A diff shim on PATH records the directory and mode of its first file
# operand (the decrypted copy), then hands off to the real diff.
SHIM_DIR="$FIXTURE_ROOT/shim"
mkdir -p "$SHIM_DIR"
cat > "$SHIM_DIR/diff" <<'EOF'
#!/bin/sh
f="" skip=0
for a in "$@"; do
  [ "$skip" = 1 ] && { skip=0; continue; }
  case "$a" in --label) skip=1 ;; -*) ;; *) f="$a"; break ;; esac
done
printf '%s %s\n' "$(dirname "$f")" "$(stat -f '%OLp' "$f")" > "$DIFF_SHIM_LOG"
exec /usr/bin/diff "$@"
EOF
chmod +x "$SHIM_DIR/diff"
DIFF_SHIM_LOG="$FIXTURE_ROOT/diff-shim.log"
PATH="$SHIM_DIR:$PATH" DIFF_SHIM_LOG="$DIFF_SHIM_LOG" TMPDIR="$CLI_TMPDIR" \
  $WORKCFG_BIN diff work-entrypoint.sh >/dev/null 2>&1 </dev/null
assert_eq "$WORKCFG_DATA_DIR 600" "$(<$DIFF_SHIM_LOG)" "decrypted temp: "
_pass_or_fail

it "diff cleans up its temp when the decrypt fails"
seed_encrypted work-entrypoint.post.sh "export B=1"
print -rn -- "not actually gpg data" > "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg"
data_before="$(_listing "$WORKCFG_DATA_DIR")"
out="$(TMPDIR="$CLI_TMPDIR" $WORKCFG_BIN diff work-entrypoint.post.sh 2>&1 </dev/null)"
rc=$?
assert_eq "1" "$rc" "exit: "
[[ "$out" == *"cannot decrypt work-entrypoint.post.sh"* ]] || fail "expected a decrypt error, got: $out"
assert_eq "$data_before" "$(_listing "$WORKCFG_DATA_DIR")" "data dir listing: "
assert_eq "$tmp_before"  "$(_listing "$CLI_TMPDIR")"       "TMPDIR listing: "
rm -f "$WORKCFG_REPO_DIR/work-entrypoint.post.sh.gpg" "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
_pass_or_fail

it "diff with no name exits 2"
out="$($WORKCFG_BIN diff 2>&1 >/dev/null </dev/null)"
rc=$?
assert_eq "2" "$rc" "exit: "
[[ "$out" == *"diff needs a file name"* ]] || fail "expected a usage error, got: $out"
_pass_or_fail

it "diff on a MISSING file exits 1 with the pull hint"
seed_encrypted work-entrypoint.post.sh "export B=1"
rm -f "$WORKCFG_DATA_DIR/work-entrypoint.post.sh"
assert_status work-entrypoint.post.sh MISSING
out="$($WORKCFG_BIN diff work-entrypoint.post.sh 2>&1 >/dev/null </dev/null)"
rc=$?
assert_eq "1" "$rc" "exit: "
assert_eq "workcfg: no plaintext for work-entrypoint.post.sh — run: workcfg pull work-entrypoint.post.sh" \
  "$out" "stderr: "
_pass_or_fail

it "edit runs \$EDITOR with its args, re-hardens the mode, and leaves the file unencrypted"
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1 </dev/null
assert_status work-entrypoint.sh CLEAN
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
before_sha="$(sha_of "$WORKCFG_DATA_DIR/work-entrypoint.sh")"
out="$(EDITOR="$FAKE_EDITOR --append" $WORKCFG_BIN edit work-entrypoint.sh 2>&1 </dev/null)"
rc=$?
assert_eq "0" "$rc" "exit: "
[[ "$before_sha" != "$(sha_of "$WORKCFG_DATA_DIR/work-entrypoint.sh")" ]] || fail "plaintext did not change"
[[ "$(<$WORKCFG_DATA_DIR/work-entrypoint.sh)" == *"export EDITED=1" ]] || fail "editor's line missing"
assert_eq "600" "$(stat -f '%OLp' "$WORKCFG_DATA_DIR/work-entrypoint.sh")" "plaintext mode: "
assert_status work-entrypoint.sh DRIFTED
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
[[ "$out" == *"Left unencrypted. Run: workcfg push work-entrypoint.sh"* ]] \
  || fail "expected 'Left unencrypted', got: $out"
_pass_or_fail

it "edit never asks the terminal when stdin is not a terminal"
# zsh's read -q reads the controlling terminal even with stdin redirected, so
# without a -t 0 guard this would block a test run started from a terminal.
# script(1) gives the child a pty and types "y" into it: the guard must never
# prompt, and must ignore the answer. The sleep lets a prompt start before the
# "y" arrives, because read -q discards typeahead; the no-prompt check below
# does not depend on that timing.
$WORKCFG_BIN pull --force work-entrypoint.sh >/dev/null 2>&1 </dev/null
snapshot_file "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
out="$( { sleep 1; print y } | EDITOR="$FAKE_EDITOR --append" perl -e 'alarm shift; exec @ARGV' 20 \
  script -q /dev/null zsh -c '"$0" edit work-entrypoint.sh </dev/null' "$WORKCFG_BIN" 2>&1)"
[[ "$out" == *"Re-encrypt"* ]] && fail "edit prompted on the terminal: $out"
assert_status work-entrypoint.sh DRIFTED
assert_unchanged "$WORKCFG_REPO_DIR/work-entrypoint.sh.gpg"
[[ "$out" == *"Left unencrypted"* ]] || fail "expected 'Left unencrypted', got: $out"
_pass_or_fail

it "edit on a MISSING file exits 1 without running the editor"
rm -f "$EDITOR_MARK"
out="$(WORKCFG_TEST_EDITOR_RAN="$EDITOR_MARK" EDITOR="$FAKE_EDITOR --append" \
  $WORKCFG_BIN edit work-entrypoint.post.sh 2>&1 >/dev/null </dev/null)"
rc=$?
assert_eq "1" "$rc" "exit: "
[[ "$out" == *"run: workcfg pull work-entrypoint.post.sh"* ]] || fail "expected the pull hint, got: $out"
[[ -e "$EDITOR_MARK" ]] && fail "the editor ran for a MISSING file"
[[ -e "$WORKCFG_DATA_DIR/work-entrypoint.post.sh" ]] && fail "edit created a plaintext"
_pass_or_fail

it "edit with no name exits 2"
out="$(EDITOR="$FAKE_EDITOR --append" $WORKCFG_BIN edit 2>&1 >/dev/null </dev/null)"
rc=$?
assert_eq "2" "$rc" "exit: "
[[ "$out" == *"edit needs a file name"* ]] || fail "expected a usage error, got: $out"
_pass_or_fail

it "edit exits non-zero when the editor fails, and offers nothing"
out="$(EDITOR="$FAKE_EDITOR --wrong-flag" $WORKCFG_BIN edit work-entrypoint.sh 2>&1 </dev/null)"
rc=$?
assert_eq "1" "$rc" "exit: "
[[ "$out" == *"editor exited 9"* ]] || fail "expected the editor failure, got: $out"
[[ "$out" == *"Left unencrypted"* ]] && fail "offered a push after a failed editor: $out"
_pass_or_fail

it "help prints only the usage header, covering every verb"
out="$(WORKCFG_REPO_DIR="$FIXTURE_ROOT/nope" $WORKCFG_BIN help 2>&1 </dev/null)"
rc=$?
assert_eq "0" "$rc" "exit: "
for verb in status pull push diff defer dismiss undismiss edit adopt doctor help; do
  [[ "$out" == *"workcfg $verb"* || "$out" == *"| $verb"* ]] || fail "help does not list '$verb'"
done
[[ "$out" == *"workcfg diff   <name>"* ]] || fail "diff should take <name>, got: $out"
[[ "$out" == *emulate* ]]             && fail "help leaked past the header (emulate)"
[[ "$out" == *"WORKCFG_REPO_DIR:="* ]] && fail "help leaked past the header (WORKCFG_REPO_DIR:=)"
[[ "$out" == *"#!"* ]]                && fail "help printed the shebang"
[[ "$out" == (*$'\n'|)"#"* ]]         && fail "help left a '#' prefix on a line"
_pass_or_fail

it "an unknown command exits 2 and points at workcfg help"
out="$($WORKCFG_BIN frobnicate 2>&1 >/dev/null </dev/null)"
rc=$?
assert_eq "2" "$rc" "exit: "
[[ "$out" == *"workcfg help"* ]] || fail "expected a pointer to workcfg help, got: $out"
_pass_or_fail

fixture_teardown
