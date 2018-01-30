# Enable gpg-agent if it is not running
GPG_AGENT_SOCKET="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
if [ ! -S $GPG_AGENT_SOCKET ]; then
	gpg-agent --daemon >/dev/null 2>&1
	export GPG_TTY=$(tty)
fi
# Set SSH to use gpg-agent if it is configured to do so 
GNUPGCONFIG=${GNUPGHOME:-"$HOME/.gnupg/gpg-agent.conf"}

if grep -q enable-ssh-support "$GNUPGCONFIG"; then
	unset SSH_AGENT_PID
	export SSH_AUTH_SOCK=$GPG_AGENT_SOCKET
fi

alias keys="sudo killall gpg-agent &>-; gpg-agent --daemon --write-env-file ~/.gpg-agent-info --enable-ssh-support &>-"
