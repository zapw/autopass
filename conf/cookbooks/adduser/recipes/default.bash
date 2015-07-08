#!/bin/env bash
#http://awk.freeshell.org/Frequently_Asked_Questions#toc1 -- How do I print a range of fields, e.g. from field 2 to the end?
set -e

bashversion
shopt -s extglob dotglob

declare -A usernosudo usernossh
package_install shadow-utils ed
#required:required:optional:optional:optional:required:required:optional:optional:optional
regex='^([^:]+:[^:]+:[^:]*:[^:]*:[^:]*:[^:]+:[^:]+)(:1?)?(:1?)?(:1?)?$'

while IFS= read -r list ; do
       [[ $list =~ ^(#|$) ]] && continue
       if [[ $list =~ [[:space:]]+#[^:]*$ ]]  ; then
           list="${list%%+(" ")#*}"
       fi
       userlist+=("$list")

done <<<"$newusers"

while read -r group ; do 
	if inarray "$group" "${sshgroup[@]}"; then 
	      sshgroups+=($group) 
	elif inarray "$group" "${sudogroup[@]}"; then
	      sudogroups+=($group) 
	fi
done < <(awk -v sudougrp="^%$sudogroup" \
	'BEGIN { OFS = "\n" } /^AllowGroups/ { $1=""; print } $0 ~ sudogrp { sub(/%/,"") ; print $1 }' /etc/ssh/sshd_config /etc/sudoers)

if (( ! ${#userlist[@]}  )) ; then
     echo 'userlist array is empty!'
     exit 1
else
     i=0
     for userstrip in "${userlist[@]}" ; do
         if [[ $userstrip =~ $regex ]] ; then
             userlist[i]="${BASH_REMATCH[1]}"
             { [[ ${BASH_REMATCH[2]} = ":1" ]] && userchpass+=("${userstrip%%:*}") ;} || true
             { [[ ${BASH_REMATCH[3]} = ":1" ]] && usernosudo["${userstrip%%:*}"]="true" ;} || true
             { [[ ${BASH_REMATCH[4]} = ":1" ]] && usernossh["${userstrip%%:*}"]="true" ;} || true
         fi
     ((i++)) || true
     done
     if printf "%s\n" "${userlist[@]}" | newusers; then
         for username in "${userlist[@]}"; do
              IFS=: read user password uid gid gecos dir shell <<<"$username"
              printf "%s\n" "${username}" | newusers || continue
              sudo -u $user cp -a /etc/skel/* "$dir/"
              if [[ ! ${usernossh["$user"]} ]] ; then
                   if (( ${#sshgroups[@]} )) ; then
	                IFS=,; usermod -a -G "${sshgroups[*]}" "$user"
			unset -v IFS
		  fi
                  if ! egrep -q -r '^AllowUsers.*[[:space:]]+'"$user"'([[:space:]]+|$).*' /etc/ssh/sshd_config ; then
                          if ! egrep -q -r '^AllowGroups' /etc/ssh/sshd_config ; then
			  	 if egrep -q -r '^AllowUsers' /etc/ssh/sshd_config; then
                                    cp -a /etc/ssh/sshd_config  /etc/ssh/sshd_config.new
		                    printf "%s\n" "/^Match /" i "AllowUsers $user" . w | ed -s /etc/ssh/sshd_config.new || true
                                    if /usr/sbin/sshd -t -f /etc/ssh/sshd_config.new; then 
					mv -f /etc/ssh/sshd_config.new /etc/ssh/sshd_config
				    else
					exit 1
				    fi
                                 fi
			  fi
                  fi
              fi
	      if [[ ! ${usernosudo["$user"]} ]] ; then
		   if (( ${#sudogroups[@]} )) ; then
	                IFS=,; usermod -a -G "${sudogroups[*]}" "$user"
			unset -v IFS
		  fi
                  while [[ -f /etc/sudoers.tmp ]] ; do
                         sleep 1
                  done
                  #if user isn't allowed to sudo
                  if ! sudo -u "$user" /bin/bash -c \
			"printf '%s\n' '$password' | sudo -S -v" 2>/dev/null; then
                         #set tmpfile
                     touch /etc/sudoers.tmp
                     cp -a /etc/sudoers{,.new}
                     echo "$user"$'\tALL=(ALL)\tNOPASSWD: ALL' >>/etc/sudoers.new && \
     		     visudo -c -f /etc/sudoers.new && mv -f /etc/sudoers{.new,}
                     rm -f /etc/sudoers.tmp
                  fi

              fi
         done

         #force change of password
         for user in "${userchpass[@]}" ; do
              chage -d0 "$user"
         done
         service sshd reload
     fi
fi
