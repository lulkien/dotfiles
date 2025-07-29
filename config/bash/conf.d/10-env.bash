bash_prepend_path() {
	[ -z "$1" ] && return
	[ -d "$1" ] || return
	[[ $PATH =~ "$1" ]] && return

	export PATH="$1:$PATH"
}

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

bash_prepend_path /home/linuxbrew/.linuxbrew/bin
bash_prepend_path /home/linuxbrew/.linuxbrew/sbin

bash_prepend_path $HOME/.cargo/bin
bash_prepend_path $HOME/.local/bin
