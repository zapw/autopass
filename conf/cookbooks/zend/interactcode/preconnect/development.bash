#!/bin/bash
. "$envdir/interactcode.bash"

getpass() {
 local num passwordtype
 num="$1"
 passwordtype="$2"
 while IFS= read -s -p "${passwordtype}" -e -r "password["$num"]" && [[ -z "${password["$num"]}" ]] ; do
  printf "\n"
 done
 printf "\n"
}

if [[ -z ${zendsftp["pass"]} ]] ; then
    echo "Enter password for user <${zendsftp["user"]}>"
    while [[ -z "$password" ]] ; do
           getpass 0 "New password: " 2>&4
           getpass 1 "Retype password: " 2>&4
           if [[ "${password[0]}" != "${password[1]}" ]] ; then
               echo "Password mismatch"
               password=""
           elif [[ ${password[0]} = *:* ]] ; then
                 echo "Password may not contain a colon character ':'."
           else
               break
           fi
    done
    zendsftp["pass"]="$password"
    unset -v 'password'
fi
newuser="${zendsftp["user"]}:${zendsftp["pass"]}:::ZendServer sftp user:${zendsftp["homedir"]}:/bin/sh"

exec 1>&5 5>&- 4>&-
#dump are new modified newuser variable
declare -p newuser
