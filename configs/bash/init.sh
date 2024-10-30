RUNTIME_DIR=$HOME/.config/bash

CONF_DIR=$RUNTIME_DIR/conf.d
CONF_COUNT=$(ls $CONF_DIR | grep -E '.*\.sh$' | wc -l)

if [[ -d $CONF_DIR ]] && [[ $CONF_COUNT -gt 0 ]]; then
    for conf in $CONF_DIR/*.sh; do
        . $conf
    done
fi

FUNC_DIR=$RUNTIME_DIR/functions
FUNC_COUNT=$(ls $FUNC_DIR | grep -E '.*\.sh$' | wc -l)

if [[ -d $FUNC_DIR ]] && [[ $FUNC_COUNT -gt 0 ]]; then
    for func in $FUNC_DIR/*.sh; do
        . $func
    done
fi

bash_greeting
export PS1=$(bash_prompt)
