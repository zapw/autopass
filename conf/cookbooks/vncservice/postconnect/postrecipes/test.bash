#!/bin/bash
. "$envdir/postconnect.bash"

printf "\n%s\n" "Testing VNC connection on port: "
exec 2> >(tr -d '\n')
for port in 5901; do 
	printf "%s " "$port " 
	if nc -w 5 "$server" $port <<<'' | grep -q ^RFB; then
		echo "PASS"
		exit 0
	else
		echo "FAIL"
		exit 1
	fi
done
