#!/bin/bash
. "$envdir/postconnect.bash"

for user in "${!users[@]}" ; do
     empty -s -c -o "$tmpdir/in.fifo" <<<"htpasswd $passwd_dir/$passwd_file $user"
     empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" '[Pp]assword:' ''
     if (( $? == 1 )) ; then 
          empty -s -c -o "$tmpdir/in.fifo" <<<"${users["$user"]}"
          empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" '[Pp]assword:' ''
          if (( $? == 1 )) ; then
               empty -s -c -o "$tmpdir/in.fifo" <<<"${users["$user"]}"
               empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" ''
	  else
              exit 1
	  fi
     else
         exit 1
     fi
done
empty -s -o "$tmpdir/in.fifo" "echo done\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" 'done' ''
(( $? == 1 )) && exit 0
