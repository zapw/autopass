#!/bin/bash
set -e
bashversion

checkvars package user extract_path delljre sysconfig_newrelic_mysql newrelic_init_mysql_plugin newrelic_plugin_wrapper newrelic_json plugin_json plugin_dir

getent passwd "$user" >/dev/null || useradd -r "$user" -s /bin/false
for path in "$extract_path" /var/log/newrelic /var/run/newrelic ; do
    [[ ! -d "$path" ]] && mkdir -p "$path"
done

chown "$user"."$user" /var/log/newrelic /var/run/newrelic
for i in 1 2 ; do curl -s https://raw.githubusercontent.com/newrelic-platform/newrelic_mysql_java_plugin/master/dist/newrelic_mysql_plugin-2.0.0.tar.gz \
 | sudo tar zxvf - -C "$extract_path" && break
 package_update openssl
done

if ! { type -P java || type -P "${delljre}/bin/java" ;} &>/dev/null ; then
     package_install "$package"
fi

echo "$sysconfig_newrelic_mysql" >/etc/sysconfig/newrelic-mysql-plugin
echo "$newrelic_init_mysql_plugin" >/etc/init.d/newrelic-mysql-plugin
echo "$newrelic_plugin_wrapper" >"$plugin_dir/newrelic-plugin-wrapper"
echo "$newrelic_json" >"$plugin_dir/config/newrelic.json"
echo "$plugin_json" >"$plugin_dir/config/plugin.json"

chmod +x /etc/init.d/newrelic-mysql-plugin "$plugin_dir/newrelic-plugin-wrapper"

chkconfig newrelic-mysql-plugin on

service newrelic-mysql-plugin restart
