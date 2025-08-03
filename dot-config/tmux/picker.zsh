#!/usr/bin/env zsh
#
# Safe and efficient color setup
(( ${+functions[colors]} )) || autoload -U colors && colors

if (( ! $+commands[gum] )); then
    2>&1 echo "${fg[red]}Requires \`gum\`. Press any key to exit.${reset_color}"
    read -n 1
    exit 1
fi

if (( ! $+commands[zoxide] )); then
    2>&1 echo "${fg[red]}Requires \`zoxide\`. Press any key to exit.${reset_color}"
    read -n 1
    exit 1
fi

new_session_str="New session..."

function _session_list() {
    echo "New session..."
    tmux list-sessions -F "#{session_name}"
}

function _picker() {

    local shortcut_new_w_query="ctrl-n"
    local shortcut_pick_directory="ctrl-g"

    local session_count=$(tmux display-message -p "#{server_sessions}" 2>/dev/null)
    local session_count=${session_count:-0}

    if [[ -z $TMUX ]]; then
        # We are not attached to a session...
        if (( $session_count == 1 )); then
            # There is only 1 session. Attach to it.
            tmux attach
            return
        fi

        if (( $session_count == 0 )); then
            # There are no sessions.
            local name=$(gum input --header="Pick a name for new tmux session:")
            if [[ -n $name ]]; then
                _create_and_switch_to_session $name
            fi
            return
        fi

    fi

    # if [[ -n $TMUX && (( $session_count < 2)) ]]; then
    #     # We are attached to the only available sesssion in tmux. Prompt for a name:
    #     local name=$(gum input --header="No other sessions. Pick a name:")
    #     if [[ -n $name ]]; then
    #         _create_and_switch_to_session "$name"
    #     fi
    #     return
    # fi

    local output=$(_session_list | fzf --print-query --expect="${shortcut_new_w_query},${shortcut_pick_directory}" \
        --preview= \
        --layout=reverse --border=rounded \
        --border-label="  Session Picker " --border-label-pos=2 \
        --prompt="󱞩 " --no-separator --info=inline-right \
        --input-border=rounded \
        --footer="${fg[yellow]}${shortcut_new_w_query}${reset_color}: create new w/ query ${fg[yellow]}${shortcut_pick_directory}${reset_color}: pick directory..." \
        --color 'footer:20,label:11'
        
    )

    local lines=("${(@f)output}")

    local query_str=$lines[1]
    local target_session=$lines[3]

    if [[ "$lines[2]" == "$shortcut_pick_directory" ]]; then
        _session_from_directory_picker "$query_str"
        return
    fi

    local create=0

    if [[ $target_session == $new_session_str ]]; then
        _create_and_switch_to_session "$new_session_name"
    fi

    # If ctrl-n was pressed:
    if [[ "$lines[2]" == "$shortcut_new_w_query" ]]; then
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

    if [[ -z "$1" ]]; then
        local new_name=$(gum input --header="Pick a name for new tmux session:")
        if [[ -n $new_name ]]; then
            _create_and_switch_to_session "$new_name"
        fi
        return
    fi

    local extra_args=
    if [[ -n "$2" ]]; then
        extra_args="-c $2"
    fi

    local name=$(_safe_tmux_session_name "$1")
    if tmux has-session -t "$name" 2>/dev/null; then
        _create_and_switch_to_session \
            $(gum input --value="${name}-" --header="Session with ${name} already exists. Pick a new one:")
        return
    fi

    tmux new-session -s "$name" -c "${2:-$(pwd)}" -d
    _switch_to_session "$name"
}

function _safe_tmux_session_name() {
    echo "${1//[^a-zA-Z0-9_-]/_}"
}

function _switch_to_session() {
    local name="$1"
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$name"
    else
        tmux switch-client -t "$name"
    fi
}

function _list_dirs() {
    pwd
    zoxide query --list --exclude="$(pwd)"
}

function _session_from_directory_picker() {
    # TODO: Prefill as query in a way that can be undone w/ backspace. Not possible with zoxide.
    # May be possible to wrap zoxide query w/ fzf.
    local query="$1"
    local target_dir="$(_list_dirs | fzf --preview= --layout=reverse --border=rounded)"
    local dirname=${target_dir##*/}
    if [[ -n $dirname ]]; then
        _create_and_switch_to_session "$dirname" "$target_dir"
    fi
}

_picker
