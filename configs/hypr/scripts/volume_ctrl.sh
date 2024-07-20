#!/usr/bin/env bash

CMD="$1"

VOLUME=0
MUTED=false

# For dunstify
NOTIFY_ID=865863
NOTIFY_TITLE=
NOTIFY_TIMEOUT=2500
NOTIFY_ICON=

ICON_PATH_PREFIX='/usr/share/icons/Papirus/48x48/status/notification-audio-volume-'
ICON_PATH_SUFFIX='.svg'

if [[ -z "$CMD" || ! $(command -v wpctl) ]]; then
    exit 1
fi

parse_volume() {
    # Extract volume value
    local volume_data=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if [[ -z "$volume_data" ]]; then
        exit 1
    fi

    local volume=$(echo $volume_data | cut -d ' ' -f 2)
    local mute_grep=$(echo $volume_data | grep 'MUTED')

    VOLUME=$(awk "BEGIN {print $volume * 100}")
    if [[ -z "$mute_grep" ]]; then
        MUTED=false
    else
        MUTED=true
    fi
}

parse_notify_title() {
    if [[ $MUTED = true ]]; then
        NOTIFY_TITLE="Muted"
    else
        NOTIFY_TITLE="Volume"
    fi
}

parse_volume_icon() {
    if [[ $MUTED = true || $VOLUME -eq 0 ]]; then
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
    if [[ ! $(command -v dunstify) ]]; then
        exit 1
    fi
    dunstify --replace=$NOTIFY_ID --timeout=$NOTIFY_TIMEOUT --icon=$NOTIFY_ICON --hints=int:value:"$VOLUME%" "$NOTIFY_TITLE" "$VOLUME%"
}

do_process() {
    parse_volume

    case "$CMD" in
    '+' | 'inc' | 'INC')
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    '-' | 'dec' | 'DEC')
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    '0' | 'toggle' | 'TOGGLE')
        if [[ $MUTED = true && $VOLUME -gt 50 ]]; then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
        fi
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *)
        return
        ;;
    esac

    parse_volume
    parse_notify_title
    parse_volume_icon
    send_notify
}

do_process
