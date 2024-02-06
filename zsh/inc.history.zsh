# References:
# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
# https://zsh.sourceforge.io/Doc/Release/Options.html

# Ignore these command patterns in history:
export HISTORY_IGNORE='(clear|history)'

# Ignore commands that start with a space:
export HIST_IGNORE_SPACE=1

# When searching for history entries in the line editor, do not display duplicates of a line previously found, even if the duplicates are not contiguous.
export HIST_FIND_NO_DUPS=1

# Do not enter command lines into the history list if they are duplicates of the previous event.
export HIST_IGNORE_DUPS=1

# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
export HIST_IGNORE_ALL_DUPS=1

# Whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
export HIST_VERIFY=1

