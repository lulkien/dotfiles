if not command -sq apt
    return
end

set -l APT_CMD 'sudo apt'

if test (whoami) = root
    set APT_CMD apt
else
    if command -sq apt-fast
        set APT_CMD apt-fast
    end
end

abbr -a pit "$APT_CMD install -y"
abbr -a prm "$APT_CMD purge"
abbr -a puf "$APT_CMD update; $APT_CMD upgrade"
abbr -a pcl "$APT_CMD autoclean; $APT_CMD autoremove"
abbr -a pss 'apt-cache search'
