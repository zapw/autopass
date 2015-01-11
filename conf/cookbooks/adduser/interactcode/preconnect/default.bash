#!/bin/bash
. "$envdir/interactcode.bash"

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

getuser () {
  unset -v 'users'
  while [[ -z "$users" ]] ; do 
      read -a users -e -r -p "Enter user list seperated by space: "
  done
  printf "\n"
}

printf "%s" "===${cookbook}::${recipefile}=== "
getuser

for user in "${users[@]}" ; do
    line="$(user="$user" awk -F: '$1 == ENVIRON["user"] {if ($2 != "") { print ;exit 2 } ; exit 1}' <<<"$newusers")"
    returnval="$?"
    if (( returnval == 2 )) ; then
         printf -v newusers_tmp "%s\n%s" "$newusers_tmp" "$line"
	 continue
    elif (( returnval == 0 )) ; then
           printf -v format "<%%s> %.s" "${attributes[@]}"
     	   printf "%s $format%s\n"  "scanned files" "${attributes[@]}" "for user <$user> none found"
           exit 1
    fi 
    echo "Enter password for user <$user>"
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
    line="$(pass="$password" user="$user" awk -F: '$1 == ENVIRON["user"] {OFS=":"; $2 = ENVIRON["pass"]; print; exit}' <<<"$newusers")"
    printf -v newusers_tmp "%s\n%s" "$newusers_tmp" "$line"
    unset -v 'password'
done
exec 1>&5 5>&- 4>&-
#dump are new modified newusers variable
if [[ $newusers_tmp ]] ; then 
    newusers="$(sed 1d <<<"$newusers_tmp")"
    declare -p newusers
fi
