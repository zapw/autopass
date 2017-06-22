#!/bin/bash
. "$envdir/postconnect.bash"

scp -o ControlPath="$tmpdir/$server-$port-$user"  -o CheckHostIP=no -o UserKnownHostsFile=/dev/null \
                         -o StrictHostKeyChecking=no "$install_denver" "$server":

if [[ $slickproject ]] ; then
	scp -o ControlPath="$tmpdir/$server-$port-$user"  -o CheckHostIP=no -o UserKnownHostsFile=/dev/null \
                         -o StrictHostKeyChecking=no "$slickproject_file" "$server":
fi
