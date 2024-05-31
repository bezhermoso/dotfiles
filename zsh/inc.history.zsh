# References:
# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
# https://zsh.sourceforge.io/Doc/Release/Options.html

# Ignore these command patterns in history:
export HISTORY_IGNORE='(clear|history)'

# Treat the '!' character specially during expansion.
setopt BANG_HIST
setopt EXTENDED_HISTORY
# Share history between all sessions.
setopt SHARE_HISTORY
# Expire a duplicate event first when trimming history.
setopt HIST_EXPIRE_DUPS_FIRST
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS 
# When searching for history entries in the line editor, do not display duplicates of a line previously found, even if the duplicates are not contiguous.
setopt HIST_FIND_NO_DUPS
# Ignore commands that start with a space:
setopt HIST_IGNORE_SPACE
# Do not write a duplicate event to the history file.
setopt HIST_SAVE_NO_DUPS
# Expand history in place instead of executing immediately.
setopt HIST_VERIFY
