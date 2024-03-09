#!/usr/bin/env bash

CMD="$1"
VOLUME=0
MUTED=false
NOTIFY_ID=865863
NOTIFY_TITLE="Volume changed"

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

increase_volume() {
    parse_volume
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
}

decrease_volume() {
    parse_volume
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-
}

toggle_mute() {
    parse_volume
    if [[ $MUTED = true && $VOLUME -gt 50 ]]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
    fi
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
}

parse_notify_title() {
    if [[ $MUTED = true ]]; then
        NOTIFY_TITLE="$1"
    else
        NOTIFY_TITLE="$2"
    fi
}

send_notify() {
    if [[ ! $(command -v dunstify) ]]; then
        exit 1
    fi
    dunstify --replace=$NOTIFY_ID --hints=int:value:"$VOLUME%" "$NOTIFY_TITLE" "$VOLUME%"
}

do_process() {
    case "$CMD" in
        '+' | 'inc' | 'INC')
            increase_volume
            parse_volume
            parse_notify_title "Muted" "Volume changed"
            if [[ $MUTED = true ]]; then
                NOTIFY_TITLE="Muted"
            fi
            send_notify
            ;;
        '-' | 'dec' | 'DEC')
            decrease_volume
            parse_volume
            parse_notify_title "Muted" "Volume changed"
            send_notify
            ;;
        '0' | 'toggle' | 'TOGGLE')
            toggle_mute
            parse_volume
            parse_notify_title "Muted" "Volume"
            dunstify --replace=$NOTIFY_ID --hints=int:value:"$VOLUME%" "$NOTIFY_TITLE" "$VOLUME%"
            ;;
        *)
            exit 1
            ;;
    esac
}

do_process
