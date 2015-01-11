#!/bin/bash
. "$envdir/interactcode.bash"
loguser="$user"
logport="$port"
logserver="$server"
emptydir="$tmpdir"

cat >$tmpdir/$rsyncwrapper <<EOF
#!/bin/bash
if [[ \$child == 1 ]] ; then
     if [[ \$1 == "-l" ]]; then
          shift 3
     elif [[ \$2 == "rsync" && \$3 == "--server" ]]; then
            shift 1
     fi
     ssh -S $tmpdir/$server-$port-$user -o CheckHostIP=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 1 '{ echo exec '"\$(printf "%q " "\$@")"' ;cat ;} > >(socat UNIX:"$socketpath" -)'
else
    export child=1
    exec rsync -e '$tmpdir/rsync-wrapper' "\$@"
fi
EOF
chmod +x $tmpdir/$rsyncwrapper

exec 1>&5 5>&- 4>&-
declare -p loguser logport logserver emptydir
