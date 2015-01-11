#!/bin/bash
set -e
package_install socat rsync

printf "\n%s\n" "rsync wrapper at: $emptydir/$rsyncwrapper"
socat UNIX-LISTEN:"$socketpath",user="$loguser",perm=0600,unlink-early=1 EXEC:/bin/bash
