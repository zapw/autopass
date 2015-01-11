#!/bin/bash
set -e

#check if server is QA
if iscenter ; then
    getent passwd "$user" >/dev/null || useradd -d "$homedir" -s /sbin/nologin -c 'dev user' "$user"
    for group in "$sshgroup" "$sftpgroup"; do
         if getent group "$group" >/dev/null ; then
             usermod -a -G "$group" "$user"
         fi
    done
fi
