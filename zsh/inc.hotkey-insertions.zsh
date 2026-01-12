# Hotkey Insertions
# Configure hotkeys to insert specific text into your command buffer, including
# cursor placement, which is highly useful for boilerplate commands.
#
# Usage: Use bindkey -s to map a key sequence to text insertion
#
# Special characters:
#   ^[  = Alt/Esc
#   ^A-^Z = Ctrl+A through Ctrl+Z
#   ^?  = Backspace
#   ^H  = Ctrl+H (also backspace on some systems)
#
# Cursor control (emacs mode only):
#   ^B  = Move cursor back one character
#   ^F  = Move cursor forward one character
#   ^A  = Move cursor to beginning of line
#   ^E  = Move cursor to end of line
#
# Vi mode: Use ZLE widgets with {CURSOR} marker for cursor placement (see below)
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (15:19-16:50)

# Example from video (emacs mode): Git commit with cursor inside quotes
# bindkey -s '^XGC' 'git commit -m ""^B'
# Typing Ctrl+X then G then C inserts: git commit -m ""
# and places cursor between the quotes (^B moves cursor back one)

# --- ZLE Widget Helper for Cursor Placement ---
#
# Helper: Insert text with cursor positioned at {CURSOR} marker
#
# ZLE Buffer Model:
#   LBUFFER = text to the LEFT of cursor
#   RBUFFER = text to the RIGHT of cursor
#   Full line = LBUFFER + RBUFFER (cursor sits between them)
#
# Example: _insert_with_cursor 'git commit -m "{CURSOR}"'
#   Input text: 'git commit -m "{CURSOR}"'
#   ${text%%{CURSOR}*} → 'git commit -m "'   (everything BEFORE marker)
#   ${text#*{CURSOR}}  → '"'                  (everything AFTER marker)
#   Result: LBUFFER='git commit -m "', RBUFFER='"'
#   Display: git commit -m "|"  (cursor at |)
#
_insert_with_cursor() {
  local text="$1"
  local marker='{CURSOR}'
  # ${text%%$marker*} = delete longest match of $marker* from end (keeps before)
  # ${text#*$marker}  = delete shortest match of *$marker from start (keeps after)
  LBUFFER+="${text%%$marker*}"
  RBUFFER="${text#*$marker}$RBUFFER"
}

# Git shortcuts with cursor placement
_hotkey_git_commit() { _insert_with_cursor 'git commit -m "{CURSOR}"' }
zle -N _hotkey_git_commit
bindkey '^Xgc' _hotkey_git_commit
bindkey -s '^Xga' 'git add '
bindkey -s '^Xgp' 'git push'
bindkey -s '^XgP' 'git push --force-with-lease'
bindkey -s '^Xgs' 'git status^M'  # ^M = Enter (auto-execute)
bindkey -s '^Xgd' 'git diff '
bindkey -s '^Xgl' 'git log --oneline -10^M'

# Docker shortcuts
bindkey -s '^Xdc' 'docker compose '
bindkey -s '^Xdp' 'docker ps'
_hotkey_docker_exec() { _insert_with_cursor 'docker exec -it {CURSOR} /bin/bash' }
zle -N _hotkey_docker_exec
bindkey '^Xde' _hotkey_docker_exec

# Common command patterns
# bindkey -s '^Xll' 'ls -lah^M'
# bindkey -s '^Xcd' 'cd ..^M'
bindkey -s '^Xmk' 'mkdir -p '

# Date insertion
_hotkey_insert_date() { LBUFFER+=$(date '+%Y-%m-%d') }
zle -N _hotkey_insert_date
bindkey '^Xdd' _hotkey_insert_date

# Search patterns
_hotkey_find() { _insert_with_cursor 'find . -name "{CURSOR}"' }
zle -N _hotkey_find
bindkey '^Xfg' _hotkey_find

_hotkey_rg() { _insert_with_cursor 'rg "{CURSOR}" .' }
zle -N _hotkey_rg
bindkey '^Xrg' _hotkey_rg

# SSH shortcuts (customize with your common hosts)
# bindkey -s '^Xsh' 'ssh user@hostname'

# Kubernetes shortcuts
# bindkey -s '^Xkp' 'kubectl get pods^M'
# bindkey -s '^Xkl' 'kubectl logs -f '
# _hotkey_kubectl_exec() { _insert_with_cursor 'kubectl exec -it {CURSOR} -- /bin/bash' }
# zle -N _hotkey_kubectl_exec
# bindkey '^Xke' _hotkey_kubectl_exec

# Python/venv shortcuts
# bindkey -s '^Xpy' 'python3 '
# bindkey -s '^Xve' 'source venv/bin/activate^M'

# npm/yarn shortcuts
# bindkey -s '^Xni' 'npm install '
# bindkey -s '^Xnr' 'npm run '
# bindkey -s '^Xns' 'npm start^M'

# systemctl shortcuts
# bindkey -s '^Xsr' 'sudo systemctl restart '
# bindkey -s '^Xss' 'sudo systemctl status '

# Tips:
# - Use ^M at the end to auto-execute the command (bindkey -s only)
# - For cursor placement, use ZLE widgets with _insert_with_cursor '{CURSOR}' marker
#   (works in both vi and emacs modes)
# - Test bindings carefully - they expand immediately when you press the key combo
# - Avoid conflicts with existing keybindings (check with: bindkey)

# Add your own custom hotkey insertions below:
