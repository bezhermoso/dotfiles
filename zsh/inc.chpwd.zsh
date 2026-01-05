# chpwd hook
# Allows you to execute a command automatically whenever you change into a
# different directory. This can be used for various purposes like loading
# Nix develop shells, activating Python virtual environments, or managing
# Node.js versions with nvm.
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (4:03-6:03)

# The chpwd function (and chpwd_functions array) is called after every
# directory change. You can define multiple functions and add them to the
# chpwd_functions array, or use add-zsh-hook to add them.

# Example 1: List directory contents on every directory change
# Uncomment to enable:
# chpwd_ls() {
#     ls -lah
# }
# chpwd_functions=(${chpwd_functions[@]} "chpwd_ls")

# Example 2: Show git status when entering a git repository
# Uncomment to enable:
# chpwd_git_status() {
#     if [[ -d .git ]]; then
#         git status -sb
#     fi
# }
# chpwd_functions=(${chpwd_functions[@]} "chpwd_git_status")

# Example 3: Auto-activate Python virtual environments
# Uncomment to enable:
# chpwd_python_venv() {
#     # Deactivate any current virtual environment
#     if [[ -n "$VIRTUAL_ENV" ]]; then
#         deactivate 2>/dev/null
#     fi
#
#     # Look for a virtual environment in common locations
#     for venv_dir in venv .venv env .env; do
#         if [[ -f "$venv_dir/bin/activate" ]]; then
#             source "$venv_dir/bin/activate"
#             echo "Activated Python virtual environment: $venv_dir"
#             break
#         fi
#     done
# }
# chpwd_functions=(${chpwd_functions[@]} "chpwd_python_venv")

# Example 4: Using add-zsh-hook (alternative method)
# This is cleaner for adding hooks programmatically
# autoload -Uz add-zsh-hook
# add-zsh-hook chpwd chpwd_ls

# Note: Some tools like direnv already use chpwd hooks, so be careful
# not to create conflicts with existing directory-based tools.

# Add your own custom chpwd functions below:
