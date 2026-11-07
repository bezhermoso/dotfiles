# sshtty — control ssh's TTY mode (bin/ssh-tty-mode, ssh/fallback_config):
# a passphrase key typed at the terminal instead of 1Password's Touch ID
# prompt, for when that prompt can't be seen (e.g. Rex on the iPhone).
#
#   sshtty                       status: mode, why, whether the key is unlocked
#   sshtty on|off [DURATION]     force the mode in every shell and agent;
#                                DURATION like 30m, 2h, 1d (default 8h), or 0
#   sshtty auto                  back to automatic detection
#   sshtty unlock [DURATION]     load the key into ssh-agent (default 4h)
#   sshtty lock                  remove the key from ssh-agent
#
# For one shell only: export SSH_TTY_MODE=on|off.

function sshtty() {
  emulate -L zsh
  zmodload zsh/datetime

  local key=~/.ssh/id_ed25519_tty
  local state=${XDG_STATE_HOME:-$HOME/.local/state}/ssh-tty-mode
  local cmd=${1:-status}
  (( $# )) && shift

  # DURATION → seconds; prints nothing for a bad value.
  local -A units=(s 1 m 60 h 3600 d 86400)
  _sshtty_secs() {
    [[ $1 == (0|forever) ]] && { print 0; return }
    [[ $1 =~ '^([0-9]+)([smhd]?)$' ]] || return 1
    print $(( match[1] * units[${match[2]:-s}] ))
  }

  case $cmd in
    status)
      ~/.dotfiles/bin/ssh-tty-mode --why
      if [[ ! -f $key ]]; then
        print -P "key: %F{yellow}missing%f — create it: ssh-keygen -t ed25519 -a 100 -f $key -C \"$USER@${HOST%%.*} tty\""
      elif [[ -f $key.pub ]] && ssh-add -l 2>/dev/null | grep -qF -- "$(ssh-keygen -lf $key.pub | cut -d' ' -f2)"; then
        print -P "key: %F{green}unlocked%f in ssh-agent"
      else
        print "key: locked (sshtty unlock, or ssh prompts for the passphrase)"
      fi
      ;;
    on|off)
      local secs
      secs=$(_sshtty_secs ${1:-8h}) || { print -u2 "sshtty: bad duration: $1"; return 1 }
      mkdir -p ${state:h}
      print "$cmd $(( secs ? EPOCHSECONDS + secs : 0 ))" > $state
      [[ $cmd == off ]] && ssh-add -d $key &>/dev/null
      ~/.dotfiles/bin/ssh-tty-mode --why
      ;;
    auto)
      rm -f $state
      ~/.dotfiles/bin/ssh-tty-mode --why
      ;;
    unlock)
      local secs
      secs=$(_sshtty_secs ${1:-4h}) || { print -u2 "sshtty: bad duration: $1"; return 1 }
      (( secs )) && ssh-add -t $secs $key || ssh-add $key
      ;;
    lock)
      ssh-add -d $key
      ;;
    *)
      print -u2 "usage: sshtty [status|on [DURATION]|off [DURATION]|auto|unlock [DURATION]|lock]"
      return 1
      ;;
  esac
}

function _sshtty() {
  _arguments '1:command:(status on off auto unlock lock)' '2:duration:(30m 1h 2h 4h 8h 1d 0)'
}
(( $+functions[compdef] )) && compdef _sshtty sshtty
