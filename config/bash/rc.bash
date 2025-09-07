RUNTIME_DIR=$HOME/.config/bash

for conf in $(find "$RUNTIME_DIR/conf.d/rc" -type f -name '*.bash' | sort); do
    . $conf
done

for func in $(find "$RUNTIME_DIR/functions" -type f -name '*.bash' | sort); do
    . $func
done

for comp in $(find "$RUNTIME_DIR/completion" -type f -name '*.bash' | sort); do
    . $comp
done

bash_greeting
