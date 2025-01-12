#!/usr/bin/env bash

set +e

SCRIPT_DIR=$(realpath "$(dirname ${BASH_SOURCE[0]})")

make_symlink() {
    local src=$1
    local dest=$2

    if [[ -L $dest ]]; then
        local current_target="$(realpath $dest)"
        if [[ $current_target = $src ]]; then
            echo "[WARNING] Already linked: $dest -> $src"
            return
        else
            echo "[WARNING] Unlink: $dest | $current_target"
            unlink $dest
        fi
        return
    elif [[ -d $dest ]]; then
        local dest_backup=$dest.bak
        rm -rf $dest_backup
        mv $dest $dest_backup
        echo "[WARNING] Backup current directory: $dest_backup"
    fi

    ln -s $src $dest

    if [[ $? -eq 0 ]]; then
        echo "[OK] Linked: $dest -> $src"
    else
        echo "[ERROR] Can't link: $dest | $src"
    fi
}

do_manifest() {
    local config=
    local operation=
    local destination=

    IFS="|" read -r config operation destination <<<"$1"

    if [[ -z "$config" || -z "$operation" ]]; then
        echo "[ERROR] Manifest invalid: $1"
        return
    fi

    local source=$SCRIPT_DIR/configs/$config
    if [[ -z "$destination" ]]; then
        destination=$HOME/.config/$config
    else
        destination=$HOME/$destination
    fi

    case $operation in
    symlink)
        make_symlink $source $destination
        ;;

    *)
        echo "[WARNING] Unknown operation $operation. Skipping..."
        ;;
    esac
}

load_manifest_file() {
    while read -r line; do
        if [[ "$line" =~ ^#.* || -z "$line" ]]; then
            continue
        fi

        do_manifest "$line"
    done <$1
}

if [[ -z "$@" ]]; then
    echo "Usage: $0 <MANIFEST>"
    echo "ERROR: no MANIFEST file is provided"
    exit 1
fi

load_manifest_file $1
