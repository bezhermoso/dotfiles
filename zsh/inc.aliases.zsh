
# Explicitly run command in Rosetta mode (Apple Silicon)
alias rosetta="arch -x86_64"

alias less='less -m -N -g -i -J --line-numbers --underline-special'
alias more='less'

alias vim="nvim"
alias vi="vim"

alias quit=exit

alias ydl="youtube-dl"
alias nvimdiff="nvim -d"

alias color-table="vim +XtermColorTable +only"

alias kb="kubectl"

if (( $+commands[yt-dlp] )); then
  alias youtube-dl="yt-dlp"
fi

# I forgot what this does...
alias reinit-markers='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed'

# Pretend you're a h4x0r
alias hacksh='$SHELL | tr -u eauiobBgGsSlL 34U1088995577'

# mnemonic: (r)oot of (p)roject
alias rp="jump-to-project-root"
# mnemonic: (j)ump to (r)oot of project
alias jr="jump-to-project-root"

