#!/bin/bash
. "$envdir/preconnect.bash"

checkvars regex sites filename uripath max_curl_procs

if [[ $skipjobsubmit = @(true|on|1) ]]; then
     exit 0
fi

echo "Enter repliweb root password"
while [[ -z $repliwebpassword ]] ; do
       IFS= read -s -r -p "Password: " repliwebpassword
       printf "\n"
done

exec 1>&5 5>&- 4>&-
declare -p repliwebpassword

