#!/bin/bash
. "$envdir/postconnect.bash"

printf "\n%s\n" "Testing Remote VNC connection to our server $server: "
exec 2> >(tr -d '\n')
for port in $remote_port; do 
	printf "%s " "$port " 
	if nc -w 5 "$remotehost" $remote_port <<<'' | grep -q ^RFB; then
		echo "PASS"
		exit 0
	else
		echo "FAIL"
		exit 1
	fi
done
