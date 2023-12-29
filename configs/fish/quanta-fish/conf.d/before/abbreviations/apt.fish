if not command -sq apt
    return
end

abbr -a pud     'sudo apt update'
abbr -a prm     'sudo apt purge'
abbr -a pcl     'sudo apt autoclean; sudo apt autoremove'
abbr -a pss     'apt-cache search'
abbr -a pfm     'sudo apt install --fix-missing'

if command -sq apt-fast
    abbr -a pit     'sudo apt-fast install -y'
    abbr -a pug     'sudo apt-fast upgrade'
    abbr -a puf     'sudo apt update; sudo apt-fast upgrade'
else
    abbr -a pit     'sudo apt install -y'
    abbr -a pug     'sudo apt upgrade'
    abbr -a puf     'sudo apt update; sudo apt upgrade'
end
