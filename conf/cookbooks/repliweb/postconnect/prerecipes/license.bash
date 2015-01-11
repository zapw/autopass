#!/bin/bash
. "$envdir/postconnect.bash"

if [[ $repliweblicfile_shared_tmp ]] ; then
     empty -s -o "$tmpdir/in.fifo" "if iscenter; then echo iscenter; else echo notcenter;fi\n"
     empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "iscenter" "" "notcenter" ""
     returnval=$?
     if (( returnval = 1 )); then
          empty -s -o "$tmpdir/in.fifo" "cat >/usr/repliweb/rds/license/lic_repliweb.rw <<'EOF'\n"
          empty -s -c -o "$tmpdir/in.fifo" <"$repliweblicfile_shared_tmp"
          empty -s -o "$tmpdir/in.fifo" "EOF\n"
     elif (( returnval == 2 )); then
            empty -s -o "$tmpdir/in.fifo" 'rm "/usr/repliweb/rds/license/lic_repliweb.rw" "/usr/repliweb/r1/license/lic_repliweb.rw" 2>/dev/null\n'
     else
          exit 1
     fi
       
else
     empty -s -o "$tmpdir/in.fifo" "cat >/usr/repliweb/rds/license/lic_repliweb.rw <<'EOF'\n"
     empty -s -c -o "$tmpdir/in.fifo" <"${repliweblicfile_tmp["$server"]}"
     empty -s -o "$tmpdir/in.fifo" "EOF\n"
fi
