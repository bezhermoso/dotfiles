# REFERENCE: https://zsh.sourceforge.io/Doc/Release/Options.html

# Protect from accidental overwriting of existing files e.g.
# echo "" > ~/.zshrc will not truncate the file
# echo "" >! ~/.zshrc will truncate the file
setopt NO_CLOBBER

# When command is not found, search for it in the current directory. If it is a directory, cd into it.
#setopt AUTO_CD

# Perform implicit tees or cats when multiple redirections are attempted e.g.
setopt MULTIOS

# cd pushes the old directory onto the directory stack
setopt AUTO_PUSHD

# When the current word has a glob pattern, do not insert all the words resulting from the expansion but generate matches as for completion and cycle through them like MENU_COMPLETE.
setopt GLOB_COMPLETE

# Exchanges the meanings of ‘+’ and ‘-’ when used with a number to specify a directory in the stack.
setopt PUSHD_MINUS

# Do not print the directory stack after `pushd` or `popd`.
#setopt PUSHD_SILENT

# Have pushd with no arguments act like ‘pushd $HOME’.
setopt PUSHD_TO_HOME

# Don’t push multiple copies of the same directory onto the directory stack.:w
setopt PUSHD_IGNORE_DUPS

# If querying the user before executing ‘rm *’ or ‘rm path/*’, first wait ten seconds and ignore anything typed in that time. 
setopt RM_STAR_WAIT

# Allow comments even in interactive shells.
setopt INTERACTIVE_COMMENTS

# Show trailing slash on directories on `ls`
alias ls="ls -GF"

# Superseded by Atuin!
#bindkey "^r" history-incremental-search-backward

# Hundredth-of-second for another key to be pressed when reading bound multi-character sequences.
# Helps when ESC is pressed while in zsh vim mode.
KEYTIMEOUT=1

# less options
export LESS=" -R"

# Add Homebrew's help directory to HELPDIR
HELPDIR=$(command brew --prefix)/share/zsh/help


# Add more lookup directories to the fpath
fpath=(
  # Custom functions:
  $HOME/.dotfiles/zsh/functions
  # Custom completions:
  $HOME/.dotfiles/zsh/completions
  # More custom functions:
  $HOME/.local/share/zsh/functions
  # Completions from Homebrew:
  /usr/local/share/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  # Existing fpaths:
  $fpath
)

autoload -Uz cd csview manpdf

