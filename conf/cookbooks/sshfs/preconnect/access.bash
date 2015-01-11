#!/bin/bash
. "$envdir/preconnect.bash"

checkvars homedir user centers_hostnames sftpgroup sshgroup

if ! ssh-keygen -q -f "$tmpdir/${cookbook}_key" -N '' -C "$user"; then
   exit 1
fi
sshfskey="$tmpdir/${cookbook}_key"

for key in "$tmpdir/${cookbook}_key" "$tmpdir/${cookbook}_key.pub" ; do
     if [[ ! -f "$key" ]] ; then
          echo "key $key not found"
          exit 1
     fi
done

exec 1>&5 5>&- 4>&-
declare -p sshfskey
