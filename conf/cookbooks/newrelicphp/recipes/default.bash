#!/bin/bash
set -e

package_install ed

export NR_INSTALL_SILENT=1
export NR_INSTALL_KEY="$license_key"

for php in /usr/bin/php /usr/local/zend/bin/php /usr/local/bin/php; do
      if rpm --quiet -qf "$php" 2>/dev/null; then
           export NR_INSTALL_PHPLIST="${php%/*}"
           break
      fi
done
if [[ ! $NR_INSTALL_PHPLIST ]] ; then
    if [[ ! -h /usr/local/bin/php && -x /usr/local/bin/php  ]] ; then
        export NR_INSTALL_PHPLIST="/usr/local/bin"
    else
        echo "Unable to find php installation"
        exit 1
    fi
fi


machine="$(uname -m)"
if [[ $machine != "x86_64" ]] ; then
     machine="i386"
fi

rpm -Uvh "http://yum.newrelic.com/pub/newrelic/el5/$machine/newrelic-repo-5-3.noarch.rpm" || true

php_ini="$(echo '<?php print PHP_CONFIG_FILE_PATH; ?>' | ${NR_INSTALL_PHPLIST}/php -n -d display_errors=Off -d display_startup_errors=Off -d error_reporting=0 -q 2> /dev/null)"
php_inidir="$(echo '<?php print PHP_CONFIG_FILE_SCAN_DIR; ?>' | ${NR_INSTALL_PHPLIST}/php -n -d display_errors=Off -d display_startup_errors=Off -d error_reporting=0 -q 2> /dev/null)"


package_install newrelic-php5
newrelic-install purge
newrelic-install install 

if [[ $php_inidir ]] ; then
     inifile="${php_inidir%/}/newrelic.ini"
else
     inifile="${php_ini%/}/php.ini"
fi
printf "%s\n" ",s/^;*\(newrelic\.appname = \).*/\1\"phpapp $(hostname -f)\"/" w | ed -s "$inifile" 
printf "%s\n" ",s/^;*\(newrelic\.enabled\).\+/\1 = true/" w | ed -s "$inifile"

if [[ $os_rel == "redhat" ]] ; then
    if (( os_relver == 7 )) ; then
        mkdir /run/newrelic
	printf "%s\n" ",s/^;*\(newrelic\.daemon\.port\).\+/\1 = \"\/run\/newrelic\/newrelic\"/" w | ed -s "$inifile"
    fi
fi

kill $(ps -C newrelic-daemon -o pid=)

service_name httpd restart
