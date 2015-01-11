#!/bin/bash
set -e

package_install ed
for group in "$sshgroup" "$sudogroup"; do
     getent group "$group" >/dev/null || /usr/sbin/groupadd "$group"
done

cp /etc/ssh/sshd_config{,.new}

printf "%s\n" 'g/^Permit\(EmptyPasswords\|RootLogin\).\+/s/^/#/' w | ed -s /etc/ssh/sshd_config.new >/dev/null

if grep -q ^PasswordAuthentication /etc/ssh/sshd_config.new ; then 
    printf "%s\n" '/^#\?PasswordAuthentication.\+/s/.\+/PasswordAuthentication yes/' '+1,$g/^PasswordAuthentication.\+/s/^/#/' w | sudo  ed -s /etc/ssh/sshd_config.new >/dev/null
else
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.new
fi

if ! grep -q -E "^[[:space:]]*(AllowGroups[[:space:]]+$sshgroup\>|AllowUsers[[:space:]]+)" /etc/ssh/sshd_config.new ; then
    printf "%s\n" "/^Match /" i "AllowGroups $sshgroup" . w | ed -s /etc/ssh/sshd_config.new || true
fi

while [[ -f /etc/sudoers.tmp ]] ; do
       sleep 1
done

if ! grep -q "^%$sudogroup" /etc/sudoers ; then
     touch /etc/sudoers.tmp
     cp -a /etc/sudoers{,.new}
     if printf "%s\t%s\t%s" "%$sudogroup" "ALL=(ALL)" "NOPASSWD: ALL" >>/etc/sudoers.new; then
          if visudo -c -f /etc/sudoers.new; then
               mv -f /etc/sudoers{.new,}
          else
               exit 1
          fi
     else
          exit 1
     fi
     rm -f /etc/sudoers.tmp
fi

if sshd -t -f /etc/ssh/sshd_config.new; then 
    mv -f /etc/ssh/sshd_config{.new,}
else
    exit 1
fi
service_name sshd reload
