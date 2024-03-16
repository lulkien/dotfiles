#!/usr/bin/env bash

# Env
PATH=/opt/homebrew/bin:$PATH
is_macos=$(test $(uname -s) = 'Darwin' && echo true || echo false)
is_root_user=$(test $USER = root && echo true || echo false)

# Source path
script_path=$(realpath "$(dirname $0)")
all_dots_dir=${script_path}/config
stow_home_dir=${script_path}/target_home
stow_conf_dir=${stow_home_dir}/.config

# Config home
user_conf_dir=$HOME/.config

distro_target=
dots=

setup_dotfiles() {
	echo "[INFO] Setup dotfiles for $distro_target"
	echo "--------------------------------------"

	if test $(pwd) != $script_path; then
		echo "[DEBUG] cd $script_path"
		cd ${script_path}
		echo "--------------------------------------"
	fi

	echo "[INFO] Remake target config"
	if test -d ${stow_home_dir}; then
		rm -r ${stow_home_dir}
	fi
	mkdir -p $stow_conf_dir

	for conf in "${dots[@]}"; do
		local conf_path_real=$all_dots_dir/$conf
		echo "[DEBUG] Link: $conf_path_real -> $stow_conf_dir"
		ln -s $conf_path_real $stow_conf_dir
	done
	echo "--------------------------------------"

	echo "[INFO] Backup or unlink old config"
	for conf in "${dots[@]}"; do
		local conf_path=$user_conf_dir/$conf
		local conf_path_bak=${user_conf_dir}/${conf}.bak

		if [[ -L $conf_path ]]; then
			echo "[DEBUG] unlink $conf_path"
			unlink $conf_path
		elif [[ -d $conf_path ]]; then
			rm -rf $conf_path_bak
			echo "[DEBUG] Rename: $conf_path -> $conf_path_bak"
			mv $conf_path $conf_path_bak
		fi
	done
	echo "--------------------------------------"

	echo -n "[INFO] Do you want to setup NvChad? [y/N] "
	read nvchad_confirm
	case "$nvchad_confirm" in
	'y' | 'Y')
		setup_nvchad
		;;
	*)
		echo "Hmm, nah."
		;;
	esac
	echo "--------------------------------------"

	echo "[INFO] Start stow --verbose=2 --dir=$stow_home_dir --target=$HOME ."
	echo
	stow --verbose=2 --dir=$stow_home_dir --target=$HOME .
	echo "--------------------------------------"

	# if [[ "$TARGET" = 'Hyprland' ]]; then
	# 	echo "[INFO] Init submodules for Hyprland"
	# 	git submodule update --init --recursive
	# 	echo "--------------------------------------"
	#
	# 	echo "[WARN] Please install all submodules for Hyprland."
	# fi

	echo
	echo "[INFO] Completed."
}

setup_nvchad() {
	local nvchad_dot_conf=$all_dots_dir/nvim
	local nvchad_conf_dir=$user_conf_dir/nvim
	local nvchad_conf_bak=$user_conf_dir/nvim.bak

	if [[ -L $nvchad_conf_dir ]]; then
		echo "[DEBUG] unlink $nvchad_conf_dir"
		unlink $nvchad_conf_dir
	elif [[ -d $nvchad_conf_dir ]]; then
		rm -rf $nvchad_conf_bak
		echo "[DEBUG] Rename: $nvchad_conf_dir -> $nvchad_conf_bak"
		mv $nvchad_conf_dir $nvchad_conf_bak
	fi

	echo "[DEBUG] Link: $nvchad_dot_conf -> $stow_conf_dir"
	ln -s $nvchad_dot_conf $stow_conf_dir
}

main() {
	if ! command -v stow &>/dev/null; then
		echo "[ERROR] stow: command not found. Please install stow first."
		return 1
	fi

	if [[ ${is_root_user} = true ]]; then
		dots=("fish")
		distro_target='Root'
	elif [[ ${is_macos} = true ]]; then
		dots=("fish" "alacritty")
		distro_target='MacOS'
	else
		echo "Target list:"
		echo "1: For Hyprland           (everything you need)"
		echo "2: For KDE, GNOME, etc    (fish + kitty)"
		echo "3: For WSL                (fish only)"
		echo "_: Cancel"
		echo -n "Select: "
		read answer

		case "${answer}" in
		1)
			dots=("hypr" "fish" "ags" "wofi" "alacritty" "dunst")
			distro_target='Hyprland'
			;;
		2)
			dots=("fish" "kitty")
			distro_target='General'
			;;
		3)
			dots=("fish")
			distro_target='WSL'
			;;
		*)
			echo "Canceled."
			return 0
			;;
		esac
	fi

	setup_dotfiles
}

main
