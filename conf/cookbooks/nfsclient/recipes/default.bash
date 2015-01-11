set -e

package_install ed nfs-utils

local_mntpoint="$(readlink -m "$local_mntpoint")"
remote_mntpoint="$(readlink -m "$remote_mntpoint")"
     
[[ ! -d "$local_mntpoint" ]] && mkdir -p "$local_mntpoint"

type="$(stat -f -L --printf %T "$local_mntpoint" 2>/dev/null)"

if [[ $type = nfs ]] ; then
    umount -l "$local_mntpoint"
fi


local_mntpoint_ed="${local_mntpoint//\//\/}"

if ! printf "%s\n" "/^.\+:.\+[[:space:]]\+${local_mntpoint_ed}/d" w | ed -s /etc/fstab 2>/dev/null; then
   :
fi

printf "%s\t\t%s\t\t%s\t%s\n" "$nfsserver:$remote_mntpoint" "$local_mntpoint" nfs "$mntoptions" >>/etc/fstab

write_conf_files () {
  echo "$sysconfig_nfs" >/etc/sysconfig/nfs
  echo "$nfs_module" >/etc/modprobe.d/nfs.conf
}

if [[ $os_rel = "redhat" ]] ; then
     if (( os_relver == 6 )) ; then
	 service nfslock stop
	 service rpcbind stop
	 write_conf_files
	 service rpcbind start
	 service nfslock start
	 chkconfig rpcbind on
	 chkconfig nfslock on
     elif (( os_relver == 7 )) ; then
	   systemctl stop nfs-config rpcbind var-lib-nfs-rpc_pipefs.mount rpc-statd-notify rpc-statd 
           write_conf_files
	   systemctl start nfs-config rpcbind var-lib-nfs-rpc_pipefs.mount rpc-statd-notify rpc-statd
	   systemctl enable nfs-config rpcbind var-lib-nfs-rpc_pipefs.mount rpc-statd-notify rpc-statd 
     fi
fi
mount "$local_mntpoint"
