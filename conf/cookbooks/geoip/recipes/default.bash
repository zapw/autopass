#!/bin/bash
set -e

shopt -s nullglob

copydst="$(readlink -m "$copydst")"
type="$(stat -f -L --printf %T "${copydst%/*}")"

search_php_pkg () {
   if read -r pkg < <(rpm -qf /usr/bin/php 2>/dev/null); then
       pkg="${pkg%%-*}-pecl-geoip"
   else
       echo "no php package installed under /usr/bin/php"
       exit 1
   fi
}

if iscenter ; then
    if [[ $type == "nfs" ]] ; then
	 search_php_pkg
         package_install GeoIP "$pkg" 

	 [[ ! -d $copydst ]] && mkdir "$copydst"
         rm -rf "/usr/share/GeoIP" && ln -s -f "$copydst" /usr/share/GeoIP

         echo "$geoipupdate_cron" >/etc/cron.weekly/geoipupdate && chmod +x /etc/cron.weekly/geoipupdate
         echo "$geoip_conf" >/etc/GeoIP.conf
	 files=("$copydst"/*.dat) 
         if (( ${#files[@]} > 0 )) ; then
              cd "$copydst" && rm -f *.dat
	 fi
         geoipupdate -d "$copydst"
    else
         echo "$copydst is not on nfs"
         exit 1
    fi
else
    package="$(rpm -qf /etc/cron.weekly/geoipupdate 2>/dev/null || true)"
    [[ -n $package ]] && yum remove "$package" -y

    if [[ $type == "nfs" ]] ; then 
	search_php_pkg
        package_install GeoIP "$pkg"

	[[ ! -d $copydst ]] && echo "Warning dir $copydst missing" 
        rm -rf "/usr/share/GeoIP" && ln -s -f "$copydst" /usr/share/GeoIP
    else
        echo "$copydst is not on nfs"
        exit 1
    fi
fi
