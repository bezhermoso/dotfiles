if ! [[ $(uname) == "Darwin" ]]; then
  # Only run on macOS
  return 0
fi

zi ice atpull"%atclone" atclone"_fix-omz-plugin"
zi snippet OMZP::macos

