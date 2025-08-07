RUNTIME_DIR=$HOME/.config/bash

for conf in $(find "$RUNTIME_DIR/conf.d/profile" -type f -name '*.bash' | sort); do
	source $conf
done
