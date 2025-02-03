[[ $- != *i* ]] && return

RUNTIME_DIR=$HOME/.config/bash

for conf in $(find "$RUNTIME_DIR/conf.d" -type f -name '*.sh'); do
    . $conf
done

for func in $(find "$RUNTIME_DIR/functions" -type f -name '*.sh'); do
    . $func
done

bash_greeting
PS1=$(bash_prompt)
