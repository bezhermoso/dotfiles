# vim: ft=zsh
#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#
# Editors
#
if [[ -z "$EDITOR" ]]; then
  export EDITOR='nvim'
fi
if [[ -z "$VISUAL" ]]; then
  export VISUAL='nvim'
fi
if [[ -z "$PAGER" ]]; then
  export PAGER='less'
fi

#
# Langs
#
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Paths
#
export PATH="$HOME/Library/Python/3.5/bin:$PATH"

# phpbrew
[[ -s "${HOME}/.phpbrew/bashrc" ]] && source "$HOME/.phpbrew/bashrc"

# Executables installed via Composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Rust executables
export PATH="$HOME/.cargo/bin:$PATH"

# Temporary Files
#
# Set TMPDIR if the variable is not set/empty or the directory doesn't exist
if [[ -z "${TMPDIR}" ]]; then
  export TMPDIR="/tmp/zsh-${UID}"
fi

if [[ ! -d "${TMPDIR}" ]]; then
  mkdir -m 700 "${TMPDIR}"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# custom executables
export PATH="$HOME/.dotfiles/bin:$HOME/.local/bin:$HOME/.symfony/bin:$HOME/.jetbrains/bin:$PATH"

export VAGRANT_I_KNOW_WHAT_IM_DOING_PLEASE_BE_QUIET=true
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export TILLER_NAMESPACE=tiller
export GO111MODULE=on
export GOROOT="$HOMEBREW_PREFIX/opt/go/libexec"

export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# Added by Toolbox App
export PATH="$PATH:/Users/bez/Library/Application Support/JetBrains/Toolbox/scripts"

# Make tmux-256color work on macOS. See https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
export TERMINFO_DIRS="$TERMINFO_DIRS:$HOME/.local/share/terminfo"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# From zprrezto:
#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
if [[ -z "$LESS" ]]; then
  export LESS='-g -i -M -R -S -w -X -z-4'
fi

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
