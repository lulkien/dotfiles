#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$(dirname ${BASH_SOURCE[0]})")

make_symlink() {
    local src=$1
    local dest=$2

    local dest_dir=$(dirname $dest)
    if [[ ! -d $dest_dir ]]; then
        mkdir -p $dest_dir || return 1
    fi

    if [[ -L $dest ]]; then
        local target="$(realpath $dest)"
        if [[ $target = $src ]]; then
            echo "[INFO] Already linked $dest -> $src"
            return 0
        else
            echo "[WARN] Unlink $dest x $target"
            unlink $dest || return 1
        fi
    elif [[ -d $dest ]]; then
        local dest_backup="${dest}_old"
        if [[ -d $dest_backup ]]; then
            rm -r $dest_backup || return 1
        fi

        mv $dest $dest_backup || return 1
        echo "[INFO] Rename $dest -> $dest_backup"
    fi

    ln -s $src $dest

    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to link $dest -> $src"
        return 1
    fi

    echo "[OK] Linked $dest -> $src"
    return 0
}

make_copy() {
    local src=$1
    local dest=$2
    local status=

    local dest_dir=$(dirname $dest)
    if [[ ! -d $dest_dir ]]; then
        mkdir -p $dest_dir || return 1
    fi

    if [[ -d $src ]]; then
        cp -r $src $dest
        status=$?
    elif [[ -e $src ]]; then
        cp $src $dest
        status=$?
    fi

    if [[ $status -ne 0 ]]; then
        echo "[ERROR] Failed to copy $src -> $dest"
        return 1
    fi

    echo "[OK] Copied $src -> $dest"
    return 0
}

do_manifest() {
    local source=
    local operation=
    local destination=
    local ret_code=0

    IFS="|" read -r source operation destination <<<"$2"

    if [[ -z "$source" || -z "$operation" || -z "$destination" ]]; then
        echo "[ERROR] Invalid format at line $1: $2"
        return 1
    fi

    source=$SCRIPT_DIR/$source
    destination=$HOME/$destination

    case $operation in
    symlink)
        make_symlink $source $destination
        ret_code=$?
        ;;
    copy)
        make_copy $source $destination
        ret_code=$?
        ;;
    extract)
        do_extract $source $destination
        ret_code=$?
        ;;
    *)
        echo "[WARNING] Unknown operation $operation. Skipping line $1"
        return 1
        ;;
    esac

    if [[ $ret_code -ne 0 ]]; then
        echo "[ERROR] Failed to process line $1: $2"
        return 1
    fi
}

load_manifest_file() {
    local line_numer=0
    while read -r line; do
        line_number=$(($line_number + 1))
        if [[ -z "$line" || "$line" =~ ^#.* ]]; then
            continue
        fi

        do_manifest "$line_number" "$line"
    done <$1
}

if [[ -z "$@" ]]; then
    echo "Usage: $0 <MANIFEST>"
    echo "ERROR: no MANIFEST file is provided"
    exit 1
fi

load_manifest_file $1
