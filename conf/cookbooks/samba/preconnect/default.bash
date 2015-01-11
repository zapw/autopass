#!/bin/bash
. "$envdir/preconnect.bash"
checkvars domainname apacheuser adminuser

echo "Enter Microsoft Active Directory Password for user $adminuser"
while [[ -z $dc_adminpassword ]] ; do 
       IFS= read -s -r -p "Password: " dc_adminpassword 
       printf "\n"
done

exec 1>&5 5>&- 4>&-
declare -p dc_adminpassword
