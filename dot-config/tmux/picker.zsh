#!/usr/bin/env zsh
#

new_session_str="New session..."

function _session_list() {
    tmux list-sessions -F "#{session_name}"
}

function _picker() {

    if (( $(tmux display-message -p "#{server_sessions}") < 2 )); then
        vared -p "New session name: " -c new_session_name
        _create_and_switch_to_session "$new_session_name"
        return
    fi

    local output=$(_session_list | fzf --print-query --expect=ctrl-n \
        --preview= \
        --layout=reverse --border=rounded \
        --border-label="  Session Picker " --border-label-pos=2 \
        --prompt="󱞩 " --no-separator --info=inline-right \
        --input-border=rounded \
        --footer="ctrl-n: create new w/ query " \
        --color 'footer:11,label:11'
        
    )

    local lines=("${(@f)output}")

    local query_str=$lines[1]
    local target_session=$lines[3]

    local create=0

    # If ctrl-n was pressed:
    if [[ -n $lines[2] ]]; then
        create=1
    fi

    # If there wasn't a match but an input was provided.
    if [[ -z "$target_session" && -n "$query_str" ]]; then
        create=1
    fi

    if (( $create == 1 )); then
        _create_and_switch_to_session "$query_str"
        return
    fi

    if [[ -n "$target_session" ]]; then
        _switch_to_session "$target_session"
        return
    fi
}

function _create_and_switch_to_session() {
    local name="${1//[^a-zA-Z0-9]/-}"
    if tmux has-session -t "$name" 2>/dev/null; then
        1>&2 echo "session with name "${name}" already exists"
        return
    fi

    tmux new-session -s "$name" -d
    _switch_to_session "$name"
}

function _switch_to_session() {
    local name="$1"
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$name"
    else
        tmux switch-client -t "$name"
    fi
}

_picker
