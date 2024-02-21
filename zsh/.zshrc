local current_dir="${funcstack[1]:a:h}"

function source_config() {
  local config_file="${1}"
  local source_path="${current_dir}/${config_file}"
  if [[ -f "${source_path}" ]]; then
      source "${source_path}"
  else
      echo "Cannot source ${source_path}: failed -f test."
  fi
}


# ./inc.theme.zsh
source_config "inc.theme.zsh"
source_config "inc.prompt.zsh"

# NOTE: This must be loaded before the zshrc from prezto. fpath should be final before loading prezto.
source_config "inc.options.zsh"

# Load the zshrc from prezto
local zprezto_zshrc="$ZDOTDIR/.zprezto/runcoms/zshrc"
if [[ -f "${zprezto_zshrc}" ]]; then
  source "${zprezto_zshrc}"
else
  echo "Cannot source ${zprezto_zshrc}. Did you install zprezto?"
fi
# .zprezto will load compinit. Otherwise, uncomment the following lines:
# autoload -U +X bashcompinit && bashcompinit
# autoload -U +X compinit && compinit

# Load $WORK configuration that needs to load early
work_config_entrypoint="${HOME}/.dotfiles/zsh/work-entrypoint.sh"
[ -f "$work_config_entrypoint" ] && source "$work_config_entrypoint"


source_config "inc.bat.zsh"
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
source_config "inc.gpg.zsh"
source_config "inc.zoxide.zsh"
source_config "inc.grep.zsh"

# Load $WORK configuration that needs to load after zprezto
work_config_post_entrypoint="${HOME}/.dotfiles/zsh/work-entrypoint.post.sh"
[ -f "$work_config_post_entrypoint" ] && source "$work_config_post_entrypoint"

# Clean up the local variables & functions
unset current_dir
unset -f source_config
