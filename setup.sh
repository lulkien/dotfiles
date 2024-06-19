#!/usr/bin/env bash

# Env
PATH=/opt/homebrew/bin:$PATH

# Source path
script_path=$(realpath "$(dirname $0)")
all_configs=${script_path}/configs

# MacOS check
is_darwin=false
if test $(uname -s) = 'Darwin'; then
	is_darwin=true
fi

# Root check
is_root_user=false
if test $(whoami) = 'root'; then
	is_root_user=true
fi

# Config directory
user_config_dir=${HOME}/.config

# choices
options=('Hyprland' 'General Desktop Environment' 'Windows Subsystem for Linux' 'Cancel')

# Define configs list
hypr_conf=('hypr' 'eww' 'wofi' 'alacritty' 'dunst')
general_conf=('kitty')
wsl_conf=
mac_conf=('alacritty')
root_conf=

configs=('fish' 'nvim')

setup_dotfiles() {
	if test $(pwd) != "${script_path}"; then
		echo "[DEBUG] cd ${script_path}"
		cd ${script_path}
		echo "--------------------------------------"
	fi

	echo "[INFO] Backup or unlink old config"
	for config in "${configs[@]}"; do
		local conf_path=${user_config_dir}/${config}
		local conf_path_bak=${user_config_dir}/${config}.bak

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

	echo "[INFO] Symlink new configs"
	for config in "${configs[@]}"; do
		echo "[DEBUG] Create symlink: ${user_config_dir}/${config} -> ${all_configs}/${config}"
		ln -s ${all_configs}/${config} ${user_config_dir}/${config}
	done
	echo "--------------------------------------"

	echo
	echo "[INFO] Completed."
}

main() {
	if test $is_root_user = true; then
		echo -e '\e[1;32mTarget: Root profile\e[00m'
		# keep configs for root
	elif test $is_darwin = true; then
		echo -e '\e[1;32mTarget: MacOS profile\e[00m'
		configs+=("${mac_conf[@]}")
	else
		echo -e '\e[1;32mSelect target:\e[00m'
		select opt in "${options[@]}"; do
			case $REPLY in
			1)
				echo -e "\e[1;33mTarget: \e[00m${opt}"
				configs+=("${hypr_conf[@]}")
				break
				;;
			2)
				echo -e "\e[1;33mTarget: \e[00m${opt}"
				configs+=("${general_conf[@]}")
				break
				;;
			3)
				echo -e "\e[1;33mTarget: \e[00m${opt}"
				# keep configs for WSL
				break
				;;
			4)
				echo -e "\e[1;33mCanceled\e[00m"
				exit 0
				;;
			*)
				echo -e "\e[1;31mInvalid\e[00m"
				exit 1
				;;
			esac
		done
		echo
	fi

	sleep 0.5
	echo -e '\e[1;32mThe following configs will be linked:\e[00m'
	for conf in "${configs[@]}"; do
		echo " - $conf"
	done

	sleep 0.5
	echo -e '\e[1;33mAre you sure?\e[00m [y/N]'
	read -r -p 'Answer: ' response

	echo
	case "$response" in
	[Y/y])
		echo -e '\e[1;32mSetting up...\e[00m'
		setup_dotfiles
		;;
	*)
		echo -e '\e[1;33mCanceled\e[00m'
		exit 0
		;;
	esac
}

main
