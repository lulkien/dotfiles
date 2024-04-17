if not command -sq apt
    return
end

set -l apt_wrapper apt
if command -sq apt-fast
    set apt_wrapper apt-fast
end

abbr -a pit "sudo $apt_wrapper install -y"
abbr -a pfm "sudo $apt_wrapper install --fix-missing"
abbr -a prm 'sudo apt purge'
abbr -a puf "sudo apt update; sudo $apt_wrapper upgrade"
abbr -a pcl 'sudo apt autoclean; sudo apt autoremove'

abbr -a pss 'apt-cache search'
