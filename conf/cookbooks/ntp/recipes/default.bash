#!/bin/bash
set -e
package_install  ntp ntpdate

if [[ "$os_rel" = "redhat" ]] ; then
    if (( os_relver == 6 )) ; then
	echo "ZONE=\"$timezone\"" >/etc/sysconfig/clock
	tzdata-update
	if package_exist chrony >/dev/null ; then
	     service chronyd off
	     service chronyd stop
	fi
	service ntpd stop
	service ntpdate start
	service ntpd start
	chkconfig ntpdate on
	chkconfig ntpd on
    elif (( os_relver == 7 )) ; then
	  timedatectl set-local-rtc 0
	  timedatectl set-timezone "$timezone"
	  if package_exist chrony >/dev/null ; then
	      systemctl disable chronyd
	      systemctl stop chronyd
	  fi
 	  systemctl stop ntpd
 	  systemctl start ntpdate ntpd
	  systemctl enable ntpdate ntpd
    else
          echo "Redhat Release '$os_relver' not supported"
          exit 1
    fi
fi
