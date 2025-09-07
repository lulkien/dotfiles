RUNTIME_DIR=$HOME/.config/bash

if [[ -z "$KBC_INIT" ]]; then
    export KBC_INIT=true
    source $RUNTIME_DIR/profile.bash
fi

source $RUNTIME_DIR/rc.bash

bash_greeting
