RUNTIME_DIR=$HOME/.config/bash

if [[ -d $RUNTIME_DIR/conf.d ]]; then
    for config in $RUNTIME_DIR/conf.d/*.sh; do
        source $config
    done
fi

if [[ -d $RUNTIME_DIR/functions ]]; then
    for func in $RUNTIME_DIR/functions/*.sh; do
        source $func
    done
fi

export PS1=$(bash_prompt)

