#!/bin/bash
. "$envdir/postconnect.bash"

if [[ $slickproject ]] ; then
	scp -o ControlPath="$tmpdir/$server-$port-$user"  -o CheckHostIP=no -o UserKnownHostsFile=/dev/null \
                         -o StrictHostKeyChecking=no "$slickproject_file" "$server":
fi
