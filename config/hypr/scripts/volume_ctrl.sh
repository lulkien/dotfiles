#!/usr/bin/env bash

VOLUME=0
MUTED=false
MAXIMUM_VOLUME=1.0
DELTA_VOLUME=5
MID_VOLUME=45

# For dunstify
NOTIFY_ID=865863
NOTIFY_TITLE=
NOTIFY_TIMEOUT=2500
NOTIFY_ICON=

ICON_PATH_PREFIX='/usr/share/icons/Papirus/48x48/status/notification-audio-volume-'
ICON_PATH_SUFFIX='.svg'

parse_volume() {
    # Extract volume value
    local volume_data=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    [[ -z "$volume_data" ]] && return 1

    local volume=$(echo $volume_data | cut -d ' ' -f 2)
    local mute_grep=$(echo $volume_data | grep 'MUTED')

    VOLUME=$(awk "BEGIN {print $volume * 100}")
    [[ -z "$mute_grep" ]] &&
        MUTED=false ||
        MUTED=true
}

parse_notify_title() {
    $MUTED && NOTIFY_TITLE="Muted" || NOTIFY_TITLE="Volume"
}

parse_volume_icon() {
    if $MUTED || [[ $VOLUME -eq 0 ]]; then
        NOTIFY_ICON="${ICON_PATH_PREFIX}muted${ICON_PATH_SUFFIX}"
        return
    fi

    if [[ $VOLUME -le 33 ]]; then
        NOTIFY_ICON="${ICON_PATH_PREFIX}low${ICON_PATH_SUFFIX}"
    elif [[ $VOLUME -le 66 ]]; then
        NOTIFY_ICON="${ICON_PATH_PREFIX}medium${ICON_PATH_SUFFIX}"
    else
        NOTIFY_ICON="${ICON_PATH_PREFIX}high${ICON_PATH_SUFFIX}"
    fi
}

send_notify() {
    [[ $(command -v dunstify) ]] || return 1
    dunstify --replace=$NOTIFY_ID --timeout=$NOTIFY_TIMEOUT --icon=$NOTIFY_ICON --hints=int:value:"$VOLUME%" "$NOTIFY_TITLE" "$VOLUME%"
}

play_sound() {
    pw-play /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga &
}

do_process() {
    [[ -z "$1" ]] && return 1
    [[ $(command -v wpctl) ]] || return 1

    local cmd=${1,,}

    parse_volume || return 1

    case "$cmd" in
    '+' | 'inc')
        wpctl set-volume -l $MAXIMUM_VOLUME @DEFAULT_AUDIO_SINK@ ${DELTA_VOLUME}%+
        play_sound
        ;;
    '-' | 'dec')
        wpctl set-volume -l $MAXIMUM_VOLUME @DEFAULT_AUDIO_SINK@ ${DELTA_VOLUME}%-
        play_sound
        ;;
    'toggle')
        if $MUTED && [[ $VOLUME -gt $MID_VOLUME ]]; then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ ${MID_VOLUME}%
        fi
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *) ;;
    esac

    parse_volume || return 1
    parse_notify_title || return 1
    parse_volume_icon || return 1
    send_notify || return 1
}

do_process "$@"
