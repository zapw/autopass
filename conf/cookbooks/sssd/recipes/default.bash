#!/bin/bash
package_install sssd
echo "$sssd_conf" >/etc/sssd/sssd.conf
chmod 0600 /etc/sssd/sssd.conf

service sssd restart
