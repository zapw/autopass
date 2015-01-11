#!/bin/bash
set -e

if ! getent passwd "${apacheuser}" &>/dev/null ; then
      echo "${apacheuser} not found"
      exit 1
fi

if [[ ! -d "$passwd_dir" ]] ; then
    mkdir "$passwd_dir" 
fi

chmod 700 "$passwd_dir"
chown "${apacheuser}.${apacheuser}" "$passwd_dir"
if [[ $passwd_dir ]] ; then
    cd "$passwd_dir"
else
    echo "string empty for passwd_dir <$passwd_dir>"
    exit 1
fi

>"$passwd_file"
chown "${apacheuser}.${apacheuser}" "$passwd_file"
chmod 600 "$passwd_file"
