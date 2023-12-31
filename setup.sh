#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Missing arguments!!!"
  exit 1
fi

dotfiles_dir=$(realpath "$(dirname "$0")")

install_fish=false
install_kitty=false
install_hypr=false
install_eww=false

install_nvim=false
is_reset_nvim=false

install_vim=false
is_reset_vim=false

OPTS=$(getopt -o kfhen:v: -l kitty,fish,hypr,eww,nvim:,vim: -- "$@")

if [[ $? -ne 0 ]]; then
  echo "Invalid options. Exiting..."
  exit 1
fi

eval set -- "$OPTS"
while true; do
  case "$1" in
    -f | --fish)
      install_fish=true
      shift
      ;;
    -k | --kitty)
      install_kitty=true
      shift
      ;;
    -e | --eww)
      install_eww=true
      shift
      ;;
    -h | --hypr)
      install_hypr=true
      shift
      ;;
    -n | --nvim)
      install_nvim=true
      is_reset_nvim="$2"
      shift 2
      ;;
    -v | --vim)
      install_vim=true
      is_reset_vim="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
  esac
done

if [[ $install_nvim = true ]]; then
  echo "Create symlink for nvim configs"

  if [[ $is_reset_nvim = true ]]; then
    echo "Remove old nvim packages"
    rm -rf $HOME/.local/share/nvim
  fi

  test -L $HOME/.config/nvim      \
    && unlink $HOME/.config/nvim  \
    || rm -rf $HOME/.config/nvim

  ln -s $dotfiles_dir/configs/nvim $HOME/.config/nvim
fi
