eval "$setvar automap_sshfs" <<EOF
#!/bin/bash
options="-fstype=fuse,reconnect,compression=yes,allow_other,noatime,ro"
options+=",CheckHostIP=no,UserKnownHostsFile=/dev/null,StrictHostKeyChecking=no,ServerAliveInterval=30,ServerAliveCountMax=30,IdentityFile=$identifyfile"

regex="[[:space:]](\$1)([[:space:]]|$)"
while IFS= read -r server ; do
       if [[ \$server =~ \$regex ]] ; then
           serverfound="\${BASH_REMATCH[1]}"
           break
       fi
done </etc/hosts

if [[ \$serverfound = "" ]] ; then
     echo "Server <\$1> not found in /etc/hosts file" >&2
     exit 1
elif [[ \$serverfound = "\${HOST%%.*}" ]] ; then
       printf "%s\n" "-fstype=bind,ro :/var/log/$service"
       exit 0
fi

printf "%s\n" "\$options :sshfs\#$user@\$1\:/var/log/$service"
exit 0
EOF
