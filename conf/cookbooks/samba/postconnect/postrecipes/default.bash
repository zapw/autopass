#!/bin/bash
. "$envdir/postconnect.bash"

empty -s -c -o "$tmpdir/in.fifo" <<<"$(declare -p adminuser); if net ads join -U\"\${adminuser}\"; then echo done; else echo fail;fi"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" '[Pp]assword:' ''
if (( $? == 1 )) ; then
    empty -s -c -o "$tmpdir/in.fifo" <<<"$dc_adminpassword"
else
    exit 1
fi
empty -w -t 3600 -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" 'done' '' 'fail' ''

returnval="$?"
if (( returnval == 1 )) ; then
    exit 0
elif (( returnval == 2 )) ; then
      exit 1
else
    exit 1
fi
