#!/bin/bash
. "$envdir/preconnect.bash"
checkvars newusers sshgroup sudogroup

#required:required:optional:optional:optional:required:required:optional:optional:optional
regex='^[^:]+:[^:]*:[^:]*:[^:]*:[^:]*:[^:]+:[^:]+[^:]+(:1?){0,3}$'
while IFS= read -r list ; do
       [[ $list =~ ^(#|$) ]] && continue
       if [[ $list =~ [[:space:]]+#[^:]*$ ]]  ; then
           list="${list%%+(" ")#*}"
       fi
       if [[ ! $list =~ $regex ]] ; then
           missing+=("$list")
           continue
       fi

       userlist+=("$list")

done <<<"$newusers"

if (( ${#missing[@]} )) ; then
    printf "%s\n" "${missing[@]}" | awk -F: 'BEGIN{print "missing fields:"} {OFS=":"; $2 = "<password>"; print}'
    exit 1
elif (( ! ${#userlist[@]} )) ; then
         printf "%s\n" "no users found"
    exit 1
fi
