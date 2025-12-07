if ! [[ $(uname) == "Darwin" ]]; then
  # Only run on macOS
  return 0
fi

zi ice atpull"%atclone" atclone"_fix-omz-plugin"
zi snippet OMZP::macos

# Command not found handler with Homebrew integration
# Suggests which formula to install when a command is not found
# Native in Homebrew since Sept 2025 (no tap required)
if (( $+commands[brew] )); then
  hb_cnf_handler="$(brew --repository)/Library/Homebrew/cmd/command-not-found-init.rb"
  if [[ -f "$hb_cnf_handler" ]]; then
    eval "$(brew command-not-found-init)"
  fi
  unset hb_cnf_handler
fi

