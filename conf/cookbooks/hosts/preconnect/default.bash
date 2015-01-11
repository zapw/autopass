#!/bin/bash
. "$envdir/preconnect.bash"
checkvars hosts keys

for key in "${keys[@]}"; do
      if [[ ! "${hosts["$key"]}" ]] ; then
           missing+=("\${hosts["$key"]}")
      fi
done

if (( ${#missing[@]} )) ; then
      printf "%s%s " "missing variables :" "<${missing[@]}>"
      echo
fi
