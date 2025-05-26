if command -sq zellij
    abbr -a -- zn zellij
    abbr -a -- za 'zellij attach'
    abbr -a -- zd 'zellij delete-session'
    abbr -a -- zda 'zellij delete-all-sessions'
    abbr -a -- zl 'zellij list-sessions'
    abbr -a -- zk 'zellij kill-session'
    abbr -a -- zka 'zellij kill-all-sessions'
end
