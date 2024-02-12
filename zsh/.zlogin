
local zprezto_zlogin="$ZDOTDIR/.zprezto/runcoms/zlogin"
if [ -f "$zprezto_zlogin" ]; then
    source "$zprezto_zlogin"
else
    >&2 echo "Cannot source $zprezto_zlogin. Did you install zprezto?"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" || : # Load RVM into a shell session *as a function*
