export PATH="/opt/homebrew/op/grep/libexec/gnubin:${PATH}"
export GREP_COLOR='103;30'
if (( $+commands[ggrep] )); then
  # BSD grep, the one that comes w/ macOS does not respect GREP_COLORS, only GREP_COLOR
  # Only configure GREP_COLORS when GNU grep is present, unset GREP_COLOR, then alias grep to ggrep
  # See https://askubuntu.com/a/1042242 for a good breakdown what these integers mean
  export GREP_COLORS="ms=${GREP_COLOR}:cx=2;3"
  unset GREP_COLOR
  alias grep='nocorrect ggrep --color=auto'
fi
