#!/bin/bash
set -e

package_install autofs autossh fuse-sshfs ed

echo "$automap_sshfs" >"/etc/auto.sshfs"
chmod +x "/etc/auto.sshfs"

printf "%s\n" 'g/[[:space:]]program:\/etc\/auto\.sshfs\($\|[[:space:]]\+\)/d' w | ed -s /etc/auto.master 2>/dev/null
printf "%s\t\t%s\n" "$mountpoint" "program:/etc/auto.sshfs" >>"/etc/auto.master"

service_name autofs restart
