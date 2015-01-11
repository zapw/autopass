#!/bin/bash
set -e

if iscenter; then
    getent passwd "$user" >/dev/null || useradd -d "$homedir" -s /sbin/nologin -c 'sshfs user' "$user"
    for group in "$sshgroup" "$sftpgroup"; do
         if getent group "$group" >/dev/null ; then
             usermod -a -G "$group" "$user"
         fi
    done
fi
[[ -d "/var/log/$service" ]] && chmod 755 "/var/log/$service"
