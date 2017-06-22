#!/bin/bash

set -e

if [[ $slickproject ]] ; then
	slickproject_file="$slickproject_file" username="$username" /usr/sbin/runuser "$username" -- -l <<'EOFLLLLLLL'
		cd "/home/$username/DenverTraining"
		/usr/bin/tar -zxPf ../"${slickproject_file##*/}"
EOFLLLLLLL
fi
