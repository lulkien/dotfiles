if command -v git &>/dev/null; then
	alias gcl='do_command "git clone"'
	alias gpl='do_command "git pull"'
	alias grs='do_command "git reset --hard HEAD^; git pull"'

	alias glo='do_command "git log --oneline"'
	alias gst='do_command "git status"'
	alias gdf='do_command "git diff"'

	alias gad='do_command "git add"'
	alias gau='do_command "git add -u;"'

	alias gco='do_command "git checkout"'
	alias gbr='do_command "git branch"'

	alias gsh='do_command "git stash"'
	alias gcm='do_command "git commit;"'
fi
