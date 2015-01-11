#!/bin/bash

set -e
shopt -s extglob

for repliweb_user in "${repliweb_users[@]}"; do
     { getent passwd |grep -q "$repliweb_user" ;} || /usr/sbin/useradd -m -s /sbin/nologin "$repliweb_user"
done

cd /tmp && [[ -d ./repliweb ]] && rm -rf ./repliweb

package_install ncompress ed xinetd tcp_wrappers

service_name xinetd restart enable
mkdir repliweb
cd repliweb

set +e
while ! curl -s "$url" ; do
        continue
done | tar -Zxvf -
if (( $? )) ; then
     while ! curl -s "$url" ; do
             continue
     done | tar -xvf -
fi
set -e

if iscenter; then
    echo "$rws" >/etc/init.d/rws
    chmod +x /etc/init.d/rws && chkconfig --add rws && chkconfig rws on
    for repliweb_sysuser in "${repliweb_sysusers[@]}"; do
        { getent passwd |grep -q "$repliweb_sysuser" ;} || /usr/sbin/useradd -m -s /sbin/nologin "$repliweb_sysuser"
    done
fi
