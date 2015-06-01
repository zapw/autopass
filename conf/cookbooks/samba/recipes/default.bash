#!/bin/bash
set -e

if [[ $os_rel = "redhat" ]] ; then
    if (( os_relver == 7 ))  ; then
	package_install samba
        systemctl enable nmb smb
	systemctl restart smb nmb
    elif (( os_relver == 6 )) ; then
	  package_install samba4
	  chkconfig nmb on
	  chkconfig smb on
	  service smb restart
	  service nmb restart
    fi
fi

echo "$mkhomedir" >"/usr/local/sbin/mkhomedir"
echo "$smb_conf" >"/etc/samba/smb.conf"
chmod +x /usr/local/sbin/mkhomedir
