#!/bin/bash
set -e
bashversion

package_install memcached

echo "$sysconfig_memcached" >/etc/sysconfig/memcached

if [[ $os_rel = "redhat" ]] ; then
    if (( os_relver == 7 )) ; then
        systemctl restart memcached
	systemctl enable memcached
    else
        service memcached restart
	chkconfig memcached on
    fi
fi
