declare -a GOOGLE_CLOUD_SDK_TO_SOURCE
GOOGLE_CLOUD_SDK_TO_SOURCE=(
  "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
)
for gcf in $GOOGLE_CLOUD_SDK_TO_SOURCE; do
  if [ -f "$gcf" ]; then
    source "$gcf"
  fi
done

