#!/bin/bash
. "$envdir/preconnect.bash"
checkvars passwd_dir passwd_file apacheuser

declare -a password
getpass() {
 local num passwordtype
 num="$1"
 passwordtype="$2"
 while IFS= read -s -p "${passwordtype}" -e -r "password["$num"]" && [[ -z "${password["$num"]}" ]] ; do
  printf "\n"
 done
 printf "\n"
}

declare -A users
for user in "${allowedusers[@]}"; do
    unset -v 'password'
    echo "Enter password for user <$user>"
    while [[ -z "$password" ]] ; do
        getpass 0 "New password: " 2>&4
        getpass 1 "Retype password: " 2>&4
        if [[ "${password[0]}" != "${password[1]}" ]] ; then
            echo "Password mismatch"
            password=""
        else
            break
        fi
    done
    users["$user"]="$password"
done
exec 1>&5 5>&- 4>&-
declare -p users
