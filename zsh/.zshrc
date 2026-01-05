local current_dir="${funcstack[1]:a:h}"

# This function is here just so the includes are "gf"able in Neovim
function source_config() {
  local config_file="${1}"
  local source_path="${current_dir}/${config_file}"
  if [[ -f "${source_path}" ]]; then
      source "${source_path}"
  else
      echo "Cannot source ${source_path}: failed -f test."
  fi
}

# Coerce 256-bit terminal colorspace
# See https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
#export TERM='xterm-256color'
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo:$HOME/.dotfiles/terminfo

# When using powerlevel10k, load inc.prompt.zsh before inc.zinit.zsh to take advantage of instant prompt
source_config "inc.powerlevel10k.zsh"
source_config "inc.zinit.zsh"

source_config "inc.theming.zsh"
source_config "inc.prompt.zsh"

# Load the following Zprezto modules
zi snippet PZTM::environment
zi snippet PZTM::terminal
zi snippet PZTM::directory
zi snippet PZTM::spectrum

# Enabled safe options. This aliases cp, ln, mv and rm so that they prompt
# before deleting or overwriting files. Set to 'no' to disable this safer
# behavior.
zstyle ':prezto:module:utility' safe-ops yes
zi snippet PZTM::utility

zi ice \
  atclone"git clone --recursive https://github.com/zsh-users/zsh-completions.git external" \
  blockf
zi snippet PZTM::completion


# NOTE: Load this before fpath needs to be finalized.
source_config "inc.options.zsh"

# Manages $WORK configuration system (handles decryption & populates env vars)
source_config "inc.work-config.zsh"

[[ -f "${WORK_CONFIG_DECRYPTED_PRE}" ]] && source "${WORK_CONFIG_DECRYPTED_PRE}"


source_config "inc.bat.zsh"
source_config "inc.direnv.zsh"

source_config "inc.python.zsh"
source_config "inc.nodejs.zsh"
source_config "inc.ruby.zsh"
source_config "inc.golang.zsh"
source_config "inc.java.zsh"
source_config "inc.rust.zsh"

source_config "inc.aliases.zsh"


# NOTE: The following needs to be included in the right order:
source_config "inc.grep.zsh"
source_config "inc.ripgrep.zsh"

# Loads history-related settings
source_config "inc.history.zsh"
# Initializes FZF & loads FZF-related settings, which may read history-related settings.
source_config "inc.fzf.zsh"
# Configures atuin to be the history manager. Will override history-related zsh & FZF settings.
source_config "inc.atuin.zsh"

source_config "inc.gcloud.zsh"
source_config "inc.ansible.zsh"
source_config "inc.neovim.zsh"
source_config "inc.suffix-aliases.zsh"
source_config "inc.tmux.zsh"

source_config "inc.git.zsh"
source_config "inc.gpg.zsh"
source_config "inc.zoxide.zsh"
source_config "inc.yazi.zsh"
source_config "inc.macos.zsh"
source_config "inc.gum.zsh"
source_config "inc.tinty.zsh"

# # Load $WORK post-configuration (from decrypted location if on work machine)
[[ -f "$WORK_CONFIG_DECRYPTED_POST" ]] && source "$WORK_CONFIG_DECRYPTED_POST"

# Secure ShellFish integration:
if [[ -f "$HOME/.shellfishrc" ]]; then
  source "$HOME/.shellfishrc"
fi

# Clean up the local variables & functions
unset current_dir
unset -f source_config
