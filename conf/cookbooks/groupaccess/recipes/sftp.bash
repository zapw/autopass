#!/bin/bash
set -e

package_install ed
for group in "$sftpgroup"; do
     getent group "$group" >/dev/null || /usr/sbin/groupadd "$group"
done

cp /etc/ssh/sshd_config{,.new}

if ! printf "%s\n" "/^Match Group \"\?$sftpgroup\"\?\(\$\|[[:space:]]\)/;/^Match /-1 c" "$match_block" . w| ed -s /etc/ssh/sshd_config.new &>/dev/null; then 
   if ! printf "%s\n" "/^Match Group \"\?$sftpgroup\"\?\(\$\|[[:space:]]\)/;\$ c" "$match_block" . w| ed -s /etc/ssh/sshd_config.new &>/dev/null; then 
      if grep -q -E '/^Match /' /etc/ssh/sshd_config.new ; then
          printf "%s\n" "/^Match /" i "$match_block" . w| ed -s /etc/ssh/sshd_config.new &>/dev/null
      else
          printf "%s\n" a "$match_block" . w| ed -s /etc/ssh/sshd_config.new &>/dev/null
      fi
   fi
fi

if sshd -t -f /etc/ssh/sshd_config.new; then
    mv -f /etc/ssh/sshd_config{.new,}
else
    exit 1
fi

service_name sshd reload
