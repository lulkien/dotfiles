bash_prepend_path() {
	[[ -d "$1" ]] || return # Directory exist
	[[ $PATH =~ "$1" ]] && return # PATH not contain

	export PATH="$1:$PATH"
}

# Init PATH
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

# Prepend PATH
bash_prepend_path $HOME/.local/bin
bash_prepend_path /home/linuxbrew/.linuxbrew/bin
bash_prepend_path /home/linuxbrew/.linuxbrew/sbin
bash_prepend_path $HOME/.cargo/bin

# Clean up
unset -f bash_prepend_path
