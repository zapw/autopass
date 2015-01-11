#!/bin/bash
set -e

ipdev="$(ip -o r get "$(ip r ls exact 0/0 | cut -d ' ' -f 3)" | cut -d ' ' -f 6)"

if [[ ! ${ipdev} ]] ; then
     echo "<${ipdev}> null"
     exit 1
fi
read -r nodehostname < <(awk -v address="${ipdev}" '{ if (index($0, address)) print $(NF-1) }' /etc/hosts)

if [[ "$os_rel" = "redhat" ]] ; then
    if (( os_relver == 6 )) ; then
          printf "%s\n" "/HOSTNAME=/s/=.*/=$nodehostname/" w | ed -s /etc/sysconfig/network 2>/dev/null
	  hostname "$nodehostname"
    elif (( os_relver == 7 )) ; then
          hostnamectl set-hostname "$nodehostname"
    else
          echo "Redhat Release '$os_relver' not supported"
          exit 1
    fi
fi
if package_exist cloud-init 2>/dev/null ; then
    echo "hostname: $nodehostname" >/etc/cloud/cloud.cfg.d/99_hostname.cfg
fi
