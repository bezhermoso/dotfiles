# Required for vim-gnupg to work https://github.com/jamessan/vim-gnupg?tab=readme-ov-file#gpg-agent
#
# NOTE: powerlevel10k's instant prompt feature takes over a lot of things at startup, including file descriptors e.g. tty.
# https://github.com/romkatv/powerlevel10k/?tab=readme-ov-file#how-do-i-configure-instant-prompt Let's use $TTY instead.
# It works, and is actually faster:
# https://github.com/romkatv/powerlevel10k/?tab=readme-ov-file#how-do-i-export-gpg_tty-when-using-instant-prompt
#
export GPG_TTY=$TTY
#export PINENTRY_USER_DATA="USE_CURSES=1"

