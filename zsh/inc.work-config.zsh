# Smart Work Configuration Management
# Auto-decrypts work configs on work machines, tracks changes, prompts for re-encryption

# Configuration
WORK_HOSTNAME_PATTERN="^block-.*"
WORK_GPG_RECIPIENT="bezalelhermoso@gmail.com"
WORK_CONFIG_DIR="${HOME}/.local/share/dotfiles/work"
WORK_CONFIG_SYNC_MARKER="${WORK_CONFIG_DIR}/.last-sync"

# Encrypted source files
WORK_CONFIG_ENCRYPTED_PRE="${HOME}/.dotfiles/zsh/work-entrypoint.sh.gpg"
WORK_CONFIG_ENCRYPTED_POST="${HOME}/.dotfiles/zsh/work-entrypoint.post.sh.gpg"

# Decrypted target files (persistent, survives restarts)
WORK_CONFIG_DECRYPTED_PRE="${WORK_CONFIG_DIR}/work-entrypoint.sh"
WORK_CONFIG_DECRYPTED_POST="${WORK_CONFIG_DIR}/work-entrypoint.post.sh"

# Check if running on work machine
_is_work_machine() {
  [[ "$(hostname)" =~ $WORK_HOSTNAME_PATTERN ]]
}

# Decrypt work config file (one-time per machine)
_decrypt_work_config() {
  local encrypted="$1"
  local decrypted="$2"

  # Skip if already decrypted
  if [[ -f "$decrypted" ]] && [[ -r "$decrypted" ]]; then
    return 0
  fi

  # Ensure directory exists
  mkdir -p "$(dirname "$decrypted")"

  # Attempt decryption
  if gpg --decrypt "$encrypted" > "$decrypted" 2>/dev/null; then
    echo "✓ Decrypted $(basename "$encrypted") to persistent location" >&2
    touch "$WORK_CONFIG_SYNC_MARKER"
    return 0
  else
    echo "✗ Failed to decrypt $(basename "$encrypted")" >&2
    return 1
  fi
}

# Check if re-encryption is needed
_check_work_config_sync() {
  local encrypted="$1"
  local decrypted="$2"

  # Both files must exist
  [[ ! -f "$encrypted" ]] && return 1
  [[ ! -f "$decrypted" ]] && return 1

  # Check if >= 3 days since last sync check
  if [[ -f "$WORK_CONFIG_SYNC_MARKER" ]]; then
    local last_sync=$(stat -f "%m" "$WORK_CONFIG_SYNC_MARKER" 2>/dev/null || echo 0)
    local now=$(date +%s)
    local days_since=$(( (now - last_sync) / 86400 ))

    if [[ $days_since -lt 3 ]]; then
      return 1  # Not time to check yet
    fi
  fi

  # Compare decrypted file with encrypted version
  local temp_decrypt=$(mktemp)
  if gpg --decrypt "$encrypted" > "$temp_decrypt" 2>/dev/null; then
    if ! diff -q "$decrypted" "$temp_decrypt" >/dev/null 2>&1; then
      rm -f "$temp_decrypt"
      return 0  # Changes detected
    fi
    rm -f "$temp_decrypt"
  fi

  # Update sync marker even if no changes (reset 3-day timer)
  touch "$WORK_CONFIG_SYNC_MARKER"
  return 1
}

# Re-encrypt modified work config
_reencrypt_work_config() {
  local decrypted="$1"
  local encrypted="$2"

  if gpg --encrypt --recipient "$WORK_GPG_RECIPIENT" --armor --output "$encrypted" "$decrypted" 2>/dev/null; then
    touch "$WORK_CONFIG_SYNC_MARKER"
    echo "✓ Re-encrypted $(basename "$encrypted")" >&2
    return 0
  else
    echo "✗ Failed to re-encrypt $(basename "$encrypted")" >&2
    return 1
  fi
}

# Prompt user to re-encrypt if changes detected
_prompt_reencrypt_work_config() {
  local decrypted="$1"
  local encrypted="$2"
  local basename=$(basename "$decrypted")

  if (( $+commands[gum] )); then
    if gum confirm "Work config '$basename' has local changes. Re-encrypt to preserve?"; then
      _reencrypt_work_config "$decrypted" "$encrypted"
    else
      # User declined, update marker to avoid re-prompting for 3 days
      touch "$WORK_CONFIG_SYNC_MARKER"
    fi
  else
    # Fallback to simple prompt
    echo -n "Work config '$basename' has local changes. Re-encrypt? [y/N] " >&2
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      _reencrypt_work_config "$decrypted" "$encrypted"
    else
      touch "$WORK_CONFIG_SYNC_MARKER"
    fi
  fi
}

# Main execution: only on work machines
if _is_work_machine; then
  # Decrypt work configs if needed (one-time per machine)
  if [[ -f "$WORK_CONFIG_ENCRYPTED_PRE" ]]; then
    _decrypt_work_config "$WORK_CONFIG_ENCRYPTED_PRE" "$WORK_CONFIG_DECRYPTED_PRE"
  fi

  if [[ -f "$WORK_CONFIG_ENCRYPTED_POST" ]]; then
    _decrypt_work_config "$WORK_CONFIG_ENCRYPTED_POST" "$WORK_CONFIG_DECRYPTED_POST"
  fi

  # Load decrypted pre-config
  if [[ -f "$WORK_CONFIG_DECRYPTED_PRE" ]]; then
    source "$WORK_CONFIG_DECRYPTED_PRE"
  fi

  # Check for changes and prompt for re-encryption (in background, non-blocking)
  # This runs after shell startup to avoid slowing down prompt
  {
    sleep 1  # Brief delay to let shell fully initialize

    if _check_work_config_sync "$WORK_CONFIG_ENCRYPTED_PRE" "$WORK_CONFIG_DECRYPTED_PRE"; then
      _prompt_reencrypt_work_config "$WORK_CONFIG_DECRYPTED_PRE" "$WORK_CONFIG_ENCRYPTED_PRE"
    fi

    if _check_work_config_sync "$WORK_CONFIG_ENCRYPTED_POST" "$WORK_CONFIG_DECRYPTED_POST"; then
      _prompt_reencrypt_work_config "$WORK_CONFIG_DECRYPTED_POST" "$WORK_CONFIG_ENCRYPTED_POST"
    fi
  } &!
fi

# Note: Post-config needs to be loaded later in .zshrc (after zprezto)
# See .zshrc for work_config_post loading
