BASH_RUNTIME_DIR=$HOME/.config/bash

# Load all builtins
for builtin in $(find "$BASH_RUNTIME_DIR/builtins" -type f -name '*.bash'); do
  source $builtin
done

# Load all configs
for bash_config in $(find "$BASH_RUNTIME_DIR/conf.d" -type f -name '*.bash' | sort); do
	source $bash_config
done

# Load all functions
for bash_function in $(find "$BASH_RUNTIME_DIR/functions" -type f -name '*.bash' | sort); do
	source $bash_function
done

# Load all completions
for completion in $(find "$BASH_RUNTIME_DIR/completion" -type f -name '*.bash' | sort); do
	source $completion
done

# Load user config if existed
if [ -f $BASH_RUNTIME_DIR/user.bash ]; then
	source $BASH_RUNTIME_DIR/user.bash
fi

# Load input hook
source $BASH_RUNTIME_DIR/input.bash

