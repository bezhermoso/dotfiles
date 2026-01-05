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
# Cursor control:
#   ^B  = Move cursor back one character
#   ^F  = Move cursor forward one character
#   ^A  = Move cursor to beginning of line
#   ^E  = Move cursor to end of line
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (15:19-16:50)

# Example from video: Git commit with cursor inside quotes
# bindkey -s '^XGC' 'git commit -m ""^B'
# Typing Ctrl+X then G then C inserts: git commit -m ""
# and places cursor between the quotes (^B moves cursor back one)

# Git shortcuts with cursor placement
bindkey -s '^Xgc' 'git commit -m ""^B'
bindkey -s '^Xga' 'git add '
bindkey -s '^Xgp' 'git push'
bindkey -s '^Xgs' 'git status^M'  # ^M = Enter (auto-execute)
bindkey -s '^Xgd' 'git diff '
bindkey -s '^Xgl' 'git log --oneline -10^M'

# Docker shortcuts
bindkey -s '^Xdc' 'docker compose '
bindkey -s '^Xdp' 'docker ps'
bindkey -s '^Xde' 'docker exec -it  /bin/bash^B^B^B^B^B^B^B^B^B^B'  # Cursor before container name

# Common command patterns
bindkey -s '^Xll' 'ls -lah^M'
bindkey -s '^Xcd' 'cd ..^M'
bindkey -s '^Xmk' 'mkdir -p '

# Search patterns
bindkey -s '^Xfg' 'find . -name ""^B'
bindkey -s '^Xrg' 'rg "" .^B^B^B'

# SSH shortcuts (customize with your common hosts)
# bindkey -s '^Xsh' 'ssh user@hostname'

# Kubernetes shortcuts
# bindkey -s '^Xkp' 'kubectl get pods^M'
# bindkey -s '^Xkl' 'kubectl logs -f '
# bindkey -s '^Xke' 'kubectl exec -it  -- /bin/bash^B^B^B^B^B^B^B^B^B^B^B^B^B^B^B'

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
# - Use ^M at the end to auto-execute the command
# - Use ^B to move cursor back (useful for placing cursor inside quotes/parentheses)
# - Multiple ^B moves cursor back multiple times
# - Test bindings carefully - they expand immediately when you press the key combo
# - Avoid conflicts with existing keybindings (check with: bindkey)

# Add your own custom hotkey insertions below:
