#!/bin/bash
set -e

package_install nfs-utils acl

mntpoint="$(readlink -m "$mntpoint")"
awk -v mntpoint="$mntpoint" -v mntregex="^[^#].+${mntpoint}/*" \
     '$0 ~ mntregex {
        if ( $2 == mntpoint) i++;
        if (i > 1) { 
	    print "More than one " mntpoint " record found" ; param="" ;  exit 1;
	}
	param=$4; 
      }
      END{ 
             if (param != "" && param !~ /(^|,)noatime(,|$)/) { 
		   print "<noatime> mount option for",mntpoint,"is missing in",FILENAME,"add it after defaults, example defaults,noatime"; exit 1;
	     }
             if (!i) { print "'\''"mntpoint"'\''","does not exist in fstab" ; exit 1 }
      }' /etc/fstab

tmpfile="$(mktemp --tmpdir=$mntpoint)"
if ! setfacl -m u:root:r "$tmpfile" ; then
     returnval="$?"
     echo "Posix ACL not supported or not enabled. set acl option in /etc/fstab for mount point <$mntpoint>"
fi
cd "$mntpoint" && rm -f "${tmpfile##*/}"

if (( returnval )); then
     exit 1
fi

write_conf_files () {
echo "$sysconfig_nfs" >/etc/sysconfig/nfs
echo "$nfs_module" >/etc/modprobe.d/nfs.conf
echo "$exports_file" >/etc/exports
}

if [[ $os_rel = "redhat" ]] ; then
     if (( os_relver == 6 )) ; then
         service nfslock stop
         service rpcbind stop
         write_conf_files
         service rpcbind start
         service nfslock start
         service nfs start
         chkconfig rpcbind on
         chkconfig nfslock on
         chkconfig nfs on
     elif (( os_relver == 7 )) ; then
	   systemctl stop nfs-config rpcbind rpc-statd-notify rpc-statd nfs-mountd nfs-server var-lib-nfs-rpc_pipefs.mount
           write_conf_files
           systemctl start nfs-config rpcbind var-lib-nfs-rpc_pipefs.mount rpc-statd-notify rpc-statd nfs-mountd nfs-server
           systemctl enable nfs-config rpcbind var-lib-nfs-rpc_pipefs.mount rpc-statd-notify rpc-statd nfs-mountd nfs-server
     fi
fi
