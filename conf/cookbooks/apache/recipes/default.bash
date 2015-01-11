#!/bin/bash
set -e

bashversion
package_install "${packages[@]}"
shopt -s nullglob extglob

if [[ ! -d "/etc/httpd/$conf_modules_dir" ]] ; then 
    mkdir /etc/httpd/"$conf_modules_dir"
else
   [[ -f "/etc/httpd/$conf_modules_dir/000-modules.conf" ]] && rm -f "/etc/httpd/$conf_modules_dir/000-modules.conf"
   for file in "/etc/httpd/$conf_modules_dir"/!(*-php|*-mod_security).conf; do
        mv -f "$file" ${file}.disabled
   done
fi

if grep -q "#start_custom" /etc/sysconfig/httpd ; then
     printf "%s\n" "/#start_custom/,/#end_custom/d" w | ed -s /etc/sysconfig/httpd
fi

shopt -s extglob
if [[ $os_rel == "redhat" ]] ; then
    case "$os_relver" in 
        7)
	   for conf in /etc/httpd/conf.d/{autoindex,welcome,userdir}.conf ; do
                [[ -f "$conf" ]] &&  mv -f "$conf" "$conf".disabled
           done
    esac
fi

echo "${conf_modules}" >/etc/httpd/$conf_modules_dir/000-modules.conf
for conf in /etc/httpd/conf.d/{autoindex,welcome,userdir}.conf ; do
    [[ -f "$conf" ]] &&  mv -f "${conf##.*}" "$conf".disabled
done

echo "$expires_conf" >/etc/httpd/conf.d/expires.conf
echo "$root_conf" >/etc/httpd/conf.d/root.conf
echo "$varwww_conf" >/etc/httpd/conf.d/varwww.conf
echo "$htaccess_conf" >/etc/httpd/conf.d/htaccess.conf
echo "$log_conf" >/etc/httpd/conf.d/log.conf
echo "$alias_conf" >/etc/httpd/conf.d/alias.conf
echo "$dir_conf" >/etc/httpd/conf.d/dir.conf
echo "$server_status_conf" >/etc/httpd/conf.d/server_status.conf
echo "$fallback_vhost" >/etc/httpd/conf.d/000fallback_vhost.conf
echo "$httpd_conf" >/etc/httpd/conf/httpd.conf

[[ ! -d $users_dir ]] && mkdir -p "$users_dir"
echo "$sysconfig_httpd" >>/etc/sysconfig/httpd

if [[ $os_rel == "redhat" ]] ; then
     if (( os_relver == 6 )) ; then
	  service httpd restart
	  chkconfig httpd on
     else
	  systemctl restart httpd
	  systemctl enable httpd
     fi
fi
