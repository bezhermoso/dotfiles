# Nag until this machine has its coding-agent SSH key (bin/agent-key-setup).
# The key is per-machine and never synced, so every new machine starts
# without it; until then Claude Code falls back to 1Password and can't push
# or sign while I'm away. Silence with AGENT_KEY_NOTICE=0.
#
# Printed from a one-shot precmd rather than at startup so it doesn't
# disturb powerlevel10k's instant prompt.

if [[ -o interactive && -z ${CLAUDECODE-} && ${AGENT_KEY_NOTICE:-1} != 0 && ! -f ~/.ssh/agent_ed25519 ]]; then
  function _agent_key_notice() {
    add-zsh-hook -d precmd _agent_key_notice
    unfunction _agent_key_notice
    print -P "%F{yellow}No agent SSH key on this machine:%f Claude Code can't push or sign while 1Password is locked. Run %Bagent-key-setup%b (or set AGENT_KEY_NOTICE=0)."
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _agent_key_notice
fi
