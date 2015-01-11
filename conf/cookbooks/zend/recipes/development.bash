#!/bin/bash
set -e

pushd /tmp >/dev/null
curl -s -k "$url" | tar -zxvf -
pushd ZendServer-RepositoryInstaller-linux >/dev/null
./install_zs.sh $phpversion --automatic && popd >/dev/null
rm -rf ./ZendServer-RepositoryInstaller-linux

echo "$newuser" | newusers
usermod -a -G "$sshgroup" "${zendsftp["user"]}"


pushd "${zendsftp["homedir"]}"  >/dev/null
mkdir -p ./.ssh
chmod -R 0600 ./.ssh
chown -R "${zendsftp["user"]}"."${zendsftp["user"]}" ./.ssh
setfacl -m u:"${zendsftp["user"]}":rwx -m g:"${zendsftp["user"]}":rwx -m g::rx -m o::rx "${zendsftp["homedir"]}"
setfacl -d -m u:"${zendsftp["user"]}":rwx -m g:"${zendsftp["user"]}":rwx -m g::rx -m o::rx "${zendsftp["homedir"]}"

zendsftp["homedir"]="${zendsftp["homedir"]%/}"
zenduser="$(stat -c %U "${zendsftp["homedir"]%/*}")"
chown $zenduser.$zenduser "${zendsftp["homedir"]}"

if [[ $os_rel = "redhat" ]] ; then
      if (( os_relver == 7 )) ; then
 	   systemctl restart httpd
	   systemctl reload sshd
      elif (( os_relver <= 6 )) ; then
           service httpd restart
	   service sshd reload
      fi
fi
