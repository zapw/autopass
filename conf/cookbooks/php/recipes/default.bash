#!/bin/bash
set -e
bashversion

if [[ $os_rel = "redhat" ]] ; then
    if [[ $installphpver = '5.6' ]] ; then
	packages=("${packages56u[@]}")
        opcache_ini_file="$opcache_ini_file56u"
    fi
    if (( os_relver == 7 )) ; then
        packages=("${packages[@]/54/}")
    fi
fi
package_install "${packages[@]}"

echo "$php_ini" >"$php_main_ini_file"
echo "$opcache_ini" >"$phpini_dir/$opcache_ini_file"
echo "$phpenv" >"$profile_d/phpenv.sh"

if [[ ! -L "/usr/bin/php" && -x "/usr/bin/php" ]] ; then
    ln -s -f "/usr/bin/php" "/usr/local/bin/php"
fi

if package_exist httpd ; then
    service_name httpd restart
fi
