local current_dir="${funcstack[1]:a:h}"

# I think this ensures completions can be loaded properly.
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

function source_config() {
  local config_file="${1}"
  local source_path="${current_dir}/${config_file}"
  [ -f "${source_path}" ] && source "${source_path}" || 2>&1 echo "No such file: ${source_path}"
}

# ./inc.theme.zsh
source_config "inc.theme.zsh"
source_config "inc.prompt.zsh"
source_config "inc.bat.zsh"

# Load $WORK configuration that needs to load before zprezto
work_config_entrypoint="${HOME}/.dotfiles/work-entrypoint.sh"
[ -f "$work_config_entrypoint" ] && source "$work_config_entrypoint"

# Load the zshrc from prezto
source "$HOME/.dotfiles/zsh/.zprezto/runcoms/zshrc"

source_config "inc.options.zsh"
source_config "inc.autosuggest.zsh"
source_config "inc.surround.zsh"
source_config "inc.direnv.zsh"

source_config "inc.python.zsh"
source_config "inc.nodejs.zsh"
source_config "inc.ruby.zsh"
source_config "inc.golang.zsh"

source_config "inc.aliases.zsh"


# NOTE: The following needs to be included in the right order:

# Loads history-related settings
source_config "inc.history.zsh"
# Initializes FZF & loads FZF-related settings, which may read history-related settings.
source_config "inc.fzf.zsh"
# Configures atuin to be the history manager. Will override history-related zsh & FZF settings.
source_config "inc.atuin.zsh"

source_config "inc.fasd.zsh"
source_config "inc.gcloud.zsh"
source_config "inc.ansible.zsh"
source_config "inc.neovim.zsh"
source_config "inc.tmux.zsh"

source_config "inc.git.zsh"

# Load $WORK configuration that needs to load after zprezto
work_config_post_entrypoint="${HOME}/.dotfiles/work-entrypoint.post.sh"
[ -f "$work_config_post_entrypoint" ] && source "$work_config_post_entrypoint"

# Clean up the local variables & functions
unset current_dir
unset -f source_config
