#!/bin/bash
. "$envdir/postconnect.bash"

empty -s -c -o "$tmpdir/in.fifo" <<<'
   case $BASH_VERSION in
           [123]*)
		 homedir="$(getent passwd '\"$user\"' | awk -F: "{print \$6}")"
	         export PATH=$homedir/bin${PATH:+:${PATH}} LD_LIBRARY_PATH=$homedir/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                 if [[ -x $homedir/bin/bash ]] ; then 
                      if $homedir/bin/bash --version | awk '\''NR==1 && /version 4/ {var=1} END {exit !var}'\''; then
                           echo "Bash4 found in $homedir/bin/bash"
		      else
                           printf "\n%s\n\n" "Uploading bash4 to $homedir."
                      fi
                 else
                      printf "\n%s\n\n" "Uploading bash4 to $homedir"
                 fi
	         ;;
		*)
                 printf "%s\n" "Bash version $BASH_VERSION is running"
	         ;;
   esac'

empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "Uploading" "" "running" "" "found" ""
returnval="$?"

case $returnval in
          1)
            ssh -o ControlPath="$tmpdir/$server-$port-$user"  -o CheckHostIP=no -o UserKnownHostsFile=/dev/null \
                         -o StrictHostKeyChecking=no $server 'tar -C $HOME -xjf -' <"$centos5_bash" 2>/dev/null & banner " uploading "
            ;;
	  [23])
	    ;;
          *)
            exit 1
            ;;
esac
