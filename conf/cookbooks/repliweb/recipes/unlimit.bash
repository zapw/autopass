#!/bin/bash
set -e

package_install ed
if ! grep -q per_source /etc/xinetd.d/rw_server &>/dev/null && [[ -f /etc/xinetd.d/rw_server ]] ; then
   printf "%s\n" "/server/a" $'\t'"per_source  = UNLIMITED" "." "w" | ed -s /etc/xinetd.d/rw_server
fi

if [[ -f "/usr/repliweb/rds/config/server.conf" ]] ; then
     printf "%s\n" ",s/^\([[:space:]]*Maximum server threads number\)\>.*/\1 = $maxserver_threads/"\
	 ",s/^\([[:space:]]*Maximum system process number\)\>.*/\1 = $maxsystem_proc/" w | ed -s /usr/repliweb/rds/config/server.conf
fi

service_name xinetd reload
