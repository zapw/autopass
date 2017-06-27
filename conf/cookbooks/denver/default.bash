#!/bin/bash

set -e

[[ -d "/home/$username/.ssh/.${git_user}" ]] || mkdir -p "/home/${username}/.ssh/.${git_user}"
printf "%s\n" "$git_login_key" >"/home/$username/.ssh/.${git_user}/id_dsa" || exit 1
chmod 700 "/home/$username/.ssh/" "/home/$username/.ssh/.${git_user}/" || exit 1
chmod 400 "/home/$username/.ssh/.${git_user}/id_dsa" || exit 1

chown "$username" "/home/$username/.ssh/" "/home/$username/.ssh/.${git_user}" "/home/$username/.ssh/.$git_user/id_dsa"

if [[ -d /home/$username/DenverTraining ]]; then
	chown -R "$username" "/home/$username/DenverTraining"
	cd "/home/$username/DenverTraining" || exit 1
	rm -rf ForNightlyRegression.out install_denver.log Denver services sv_driver 2>/dev/null || true
else
	mkdir "/home/$username/DenverTraining"
	chown "$username" "/home/$username/DenverTraining"
fi


install_denver="$install_denver" team="$team" git_user="$git_user" username="$username" /usr/sbin/runuser "$username" -- -l <<'EOXXZZZZZZZZZZZ'

cd "/home/$username/DenverTraining" || exit 1

rm -rf ../.ccache 2>/dev/null || true

. /etc/profile.d/git.sh
git_default_env "$git_user"
git_default_config
git_default_hooks
#git_user_env

if "/home/$username/${install_denver##*/}" -t "$team"; then
	exit 0
else
	exit 1
fi
EOXXZZZZZZZZZZZ
