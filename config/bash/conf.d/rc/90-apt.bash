if command -v apt &>/dev/null; then
  alias pit='do_command "sudo apt install"'
  alias prm='do_command "sudo apt purge"'
  alias puf='do_command "sudo apt update; sudo apt upgrade;"'
  alias pcl='do_command "sudo apt autoclean; sudo apt autoremove;"'
  alias pss='do_command "apt-cache search"'
fi
