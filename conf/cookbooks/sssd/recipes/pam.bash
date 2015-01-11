#!/bin/bash
set -e
if [[ -f /etc/sssd/sssd.conf ]] ; then
    input="$(awk '/services = / && !/pam/ { $0 = $0", pam"; sub(/= *,/,"="); } { print }' /etc/sssd/sssd.conf)"
    if [[ $input ]] ; then
	echo "$input" >/etc/sssd/sssd.conf
    else
	echo 'var $input is empty or null'
	exit 1
    fi
    authconfig --enablesssd --enablesssdauth --enablecachecreds --update
else
    echo "file /etc/sssd/sssd.conf missing."
    exit 1
fi
