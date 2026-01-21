if command -v zellij &>/dev/null; then
	abbr -a zn  'zellij'
	abbr -a zl  'zellij list-sessions'
	abbr -a za  'zellij attach'
	abbr -a zk  'zellij kill-session'
	abbr -a zka 'zellij kill-all-sessions'
	abbr -a zd  'zellij delete-session'
	abbr -a zda 'zellij delete-all-sessions'
fi
