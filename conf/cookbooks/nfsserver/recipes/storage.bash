#!/bin/bash
set -e

package_install ed

if ! [[ -b $storage_devicename ]] ; then
       echo "<$storage_devicename> not a block device"
       exit 1
fi

mntpoint_ed="${mntpoint//\//\/}"


printf "%s\n" "g/^.\+[[:space:]]\+${mntpoint_ed}/d" w | ed -s /etc/fstab 2>/dev/null

umount -l "$mntpoint"
if [[ $os_rel == "redhat" ]] ; then
     if (( os_relver < 7 )); then
          fstype="ext4"
	  [[ $ext4_options ]] && printf -v storage_mntoptions "%s," "${ext4_options[@]}" "$storage_mntoptions" 
	  mkfs.ext4 "$storage_devicename"
     elif (( os_relver == 7 )) ; then
            fstype="xfs"
	  [[ $xfs_options ]] && printf -v storage_mntoptions "%s," "${xfs_options[@]}" "$storage_mntoptions" 
	  mkfs.xfs -f "$storage_devicename"
     fi
fi

storage_mntoptions="${storage_mntoptions%,}"
printf "%s\t\t%s\t\t%s\t%s\n" "$storage_devicename" "$mntpoint" "$fstype" "$storage_mntoptions" >>/etc/fstab

if [[ ! -d "$mntpoint" ]] ; then
      mkdir -p "$mntpoint"
fi
mount "$mntpoint"
