# Set Lazygit config dir
export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yml

alias lg='lazygit'

# Git configuration for when we are SSHed into the machine.
# 1.) We configure Git to read config values from env via --config-env=<config_name>=<env_name>
# 2.) We set the various env vars to certain values
# 3.) Alias git to add the --config-env options.
if [[ -n "$SSH_CONNECTION" ]]; then
    export GIT_CONFIG_COUNT=2
    export GIT_CONFIG_KEY_0="gpg.format"
    export GIT_CONFIG_VALUE_0="openpgp"
    export GIT_CONFIG_KEY_1="user.signingkey"
    export GIT_CONFIG_VALUE_1="55BDEC097B885413"
fi

# Load the jump-to-git-root plugin and set an alias: mnemonics: go to (g)it (r)oot
zi ice \
  atload"alias gr=jump-to-git-root"
zi load bezhermoso/jump-to-git-root

# Load the jump-to-project-root plugin and set an alias: mnemonics: (j)ump to (r)oot of project
zi ice \
  atload"alias jr=jump-to-project-root"
zi load bezhermoso/jump-to-project-root

