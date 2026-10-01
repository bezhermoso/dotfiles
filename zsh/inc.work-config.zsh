# Work configuration management.
#
# All decryption, drift detection and re-encryption live in `bin/workcfg`.
# This file only: decides cheaply at source time whether anything might need
# attention, and if so registers a ONE-SHOT precmd hook that reports it and,
# when a plaintext is missing or stale, offers to decrypt.
#
# Why the first prompt and not a timer: precmd runs between commands, so no
# foreground job owns the terminal and the shell is fully initialised. The old
# `{ sleep 5; ... } &!` job read the terminal (`read -r`) from the background
# and ran an unattended `gpg --decrypt`, whose pinentry-mac dialog stole focus
# from whatever you had started by then. The old synchronous decrypt during
# .zshrc prompted mid-startup instead.
#
# Sourced by .zshrc's source_config, i.e. inside a function: anything meant to
# outlive this file must be a plain assignment or `export`/`typeset -g`, and
# every function here keeps its variables local.
#
# See docs/superpowers/specs/2026-09-03-work-config-gpg-workflow-design.md

: ${WORKCFG_REPO_DIR:=$HOME/.dotfiles/zsh}
: ${WORKCFG_DATA_DIR:=$HOME/.local/share/dotfiles/work}
: ${WORKCFG_HOST_PATTERN:=^BLK}

export WORK_CONFIG_DECRYPTED_PRE="${WORKCFG_DATA_DIR}/work-entrypoint.sh"
export WORK_CONFIG_DECRYPTED_POST="${WORKCFG_DATA_DIR}/work-entrypoint.post.sh"

# Resolved by path, never via PATH or $commands: PATH only gains
# ~/.dotfiles/bin in login shells, and this also sidesteps any alias or
# function named `workcfg`.
typeset -g _workcfg_bin="${WORKCFG_BIN:-${WORKCFG_REPO_DIR:h}/bin/workcfg}"

# workcfg falls back to the same defaults, but passing both dirs keeps it on
# the exact files this file checked even if they were set without `export`.
_workcfg_run() {
  WORKCFG_DATA_DIR="$WORKCFG_DATA_DIR" WORKCFG_REPO_DIR="$WORKCFG_REPO_DIR" "$_workcfg_bin" "$@"
}

# `=~` sets MATCH/MBEGIN/MEND and match/mbegin/mend; keep them in here.
_workcfg_on_work_host() {
  emulate -L zsh
  local MATCH MBEGIN MEND
  local -a match mbegin mend
  [[ "${HOST%%.*}" =~ $WORKCFG_HOST_PATTERN ]]
}

# Fast path, run at source time with no fork: 0 only if mtime+size of every
# managed file match the recorded baseline, i.e. nothing changed since both
# sides last agreed. Anything doubtful is 1, which never means "assume
# last-known-good": it means "ask workcfg", which always re-hashes. That is
# also what makes the `adopt --assume=local` sentinel (mtime/size 0) safe.
_workcfg_unchanged() {
  emulate -L zsh
  # -F b:zstat loads only zstat; a bare zmodload would shadow /usr/bin/stat.
  zmodload -F zsh/stat b:zstat 2>/dev/null || return 1
  local name sfile pt ct line
  local -A acc st
  for name in work-entrypoint.sh work-entrypoint.post.sh; do
    sfile="${WORKCFG_DATA_DIR}/.state/${name}.state"
    pt="${WORKCFG_DATA_DIR}/${name}"
    ct="${WORKCFG_REPO_DIR}/${name}.gpg"
    [[ -f "$sfile" && -s "$pt" && -f "$ct" ]] || return 1
    acc=()
    while IFS= read -r line; do
      [[ "$line" == *=* ]] && acc[${line%%=*}]="${line#*=}"
    done < "$sfile"
    zstat -H st -- "$pt" 2>/dev/null || return 1
    [[ "${st[mtime]}" == "${acc[plaintext_mtime]:-}" && "${st[size]}" == "${acc[plaintext_size]:-}" ]] || return 1
    zstat -H st -- "$ct" 2>/dev/null || return 1
    [[ "${st[mtime]}" == "${acc[ciphertext_mtime]:-}" && "${st[size]}" == "${acc[ciphertext_size]:-}" ]] || return 1
  done
  return 0
}

# Prints a notice to stderr for each file needing attention and, to stdout,
# the names that warrant a decrypt prompt (MISSING/STALE). Returns 1, having
# printed why, when workcfg is absent or its status is unusable. Needs no
# terminal. Only CLEAN, DISMISSED and UNMANAGED are ever silent.
_workcfg_report() {
  emulate -L zsh
  if [[ ! -x "$_workcfg_bin" ]]; then
    print -u2 "⚠ workcfg not found at ${_workcfg_bin} — work config unmanaged"
    return 1
  fi
  local out rc
  out="$(_workcfg_run status --porcelain 2>/dev/null </dev/null)"
  rc=$?
  # status --porcelain exits 1 when something needs action; that is success.
  if (( rc != 0 && rc != 1 )) || [[ -z "$out" ]]; then
    print -u2 "⚠ workcfg status failed (rc=${rc}) — run: workcfg doctor"
    return 1
  fi
  local line name st
  for line in ${(f)out}; do
    name="${line%% *}"; st="${line##* }"
    case "$st" in
      CLEAN|DISMISSED|UNMANAGED) ;;
      MISSING|STALE) print -r -- "$name" ;;
      DRIFTED)   print -u2 "⚠ ${name} drifted — workcfg push ${name} · workcfg dismiss ${name}" ;;
      CONFLICT)  print -u2 "⚠ ${name} changed on both sides — workcfg diff ${name}" ;;
      UNTRACKED) print -u2 "⚠ ${name} has no baseline — workcfg adopt ${name}" ;;
      # Deferred is never silent: declining a prompt downgrades it to this
      # line, every shell, until the condition is resolved.
      DEFERRED)  print -u2 "⚠ ${name} needs decrypting (deferred) — workcfg pull ${name}" ;;
      # A status added to workcfg later must still be seen.
      *)         print -u2 "⚠ ${name}: ${st} — run: workcfg status" ;;
    esac
  done
  return 0
}

# Single-flight across shells: only one prompts, even if five tabs open at
# once. 0 = acquired, 1 = another shell holds it, 2 = cannot create it.
_workcfg_lock_acquire() {
  emulate -L zsh
  local lock="$1" holder=""
  local -A lst
  # A fresh machine has no .state yet; without this the mkdir below fails
  # and the user would never be asked.
  mkdir -p -m 700 "${lock:h}" 2>/dev/null
  if mkdir -m 700 "$lock" 2>/dev/null; then
    print -r -- $$ >| "$lock/pid"
    return 0
  fi
  [[ -d "$lock" ]] || return 2
  [[ -r "$lock/pid" ]] && holder="$(<"$lock/pid")"
  if [[ -n "$holder" && "$holder" != $$ ]]; then
    kill -0 "$holder" 2>/dev/null && return 1
  elif [[ -z "$holder" ]]; then
    # No pid yet: another shell may be between its mkdir and its write.
    # Held while young; only an abandoned (>=10s) pid-less lock is stale.
    zmodload -F zsh/stat b:zstat 2>/dev/null
    zmodload -F zsh/datetime p:EPOCHSECONDS 2>/dev/null
    zstat -H lst -- "$lock" 2>/dev/null || return 1
    (( EPOCHSECONDS - lst[mtime] < 10 )) && return 1
  fi
  # Dead holder, abandoned, or our own pid left behind across `exec zsh`.
  rm -rf -- "$lock"
  mkdir -m 700 "$lock" 2>/dev/null || return 1
  print -r -- $$ >| "$lock/pid"
  return 0
}

_workcfg_lock_release() {
  emulate -L zsh
  local lock="$1" holder=""
  [[ -r "$lock/pid" ]] && holder="$(<"$lock/pid")"
  [[ "$holder" == $$ ]] && rm -rf -- "$lock"
  return 0
}

_workcfg_first_prompt() {
  # localtraps: without it the INT/TERM traps below would stay installed in
  # the interactive shell after this returns.
  setopt localoptions localtraps
  add-zsh-hook -d precmd _workcfg_first_prompt
  unfunction _workcfg_first_prompt 2>/dev/null

  # Only ever act when we genuinely own an interactive terminal. This must
  # stay ahead of every `read -q`: zsh's read -q reads the controlling
  # terminal even when stdin is redirected.
  [[ -o interactive && -t 0 && -t 1 && -t 2 && "$TERM" != dumb ]] || return 0
  [[ -n "${WORKCFG_NO_PROMPT:-}" || -n "${CLAUDECODE:-}" || -n "${CI:-}" ]] && return 0

  local out rc lock
  local -a prompts
  out="$(_workcfg_report)"
  rc=$?
  (( rc == 0 )) || return 0              # _workcfg_report already said why
  prompts=(${(f)out})
  (( $#prompts )) || return 0

  lock="${WORKCFG_DATA_DIR}/.state/.lock"
  _workcfg_lock_acquire "$lock"
  rc=$?
  case $rc in
    0) ;;
    1) print -u2 "· work config needs decrypting; another shell is handling it"
       return 0 ;;
    *) print -u2 "⚠ cannot create the work-config lock at ${lock}; asking anyway" ;;
  esac
  trap "_workcfg_lock_release ${(q)lock}" EXIT
  # Ctrl-C abandons the prompt without deferring: the next shell asks again.
  trap "_workcfg_lock_release ${(q)lock}; return 130" INT TERM

  print -u2 "Work config needs decrypting: ${(j:, :)prompts}"
  if read -q "?Decrypt now? [y/N] "; then
    print -u2
    if _workcfg_run pull $prompts; then
      # A freshly pulled *pre* config is too late to source here — everything
      # that depends on it already loaded. Reloading is the honest fix.
      if read -q "?Reload shell to apply? [y/N] "; then
        print -u2
        _workcfg_lock_release "$lock"
        exec zsh
      fi
      print -u2
    else
      print -u2 "⚠ workcfg pull failed (see above) — run: workcfg doctor"
    fi
  else
    print -u2
    # Downgrade to a notice for later shells instead of re-prompting in every
    # tab. Never silent: DEFERRED still prints a line in each new shell.
    if _workcfg_run defer $prompts >/dev/null; then
      print -u2 "Deferred. You'll see a reminder in new shells until you run \`workcfg pull\`."
    else
      print -u2 "⚠ workcfg defer failed — you will be asked again in the next shell"
    fi
  fi
  _workcfg_lock_release "$lock"
}

# The only work done at source time: a regex on $HOST and some zstat calls.
# No workcfg, no gpg. A missing workcfg still registers the hook, so that it
# is reported at first prompt rather than silently doing nothing.
if _workcfg_on_work_host; then
  if [[ ! -x "$_workcfg_bin" ]] || ! _workcfg_unchanged; then
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _workcfg_first_prompt
  fi
fi

[ -f "$HOME/Development/bzf/bz.plugin.zsh" ] && source "$HOME/Development/bzf/bz.plugin.zsh"
