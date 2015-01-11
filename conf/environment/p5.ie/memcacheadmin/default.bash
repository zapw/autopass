url="http://phpmemcacheadmin.googlecode.com/files/phpMemcachedAdmin-1.2.2-r262.tar.gz"
dstdir="/var/www/html"
passwd_phpmyadmin_dir="/etc/httpd/conf/passwd"
phpmyadmin_passwd_file="passwd.phpmyadmin"
apacheuser="apache"

read -d '' passwd_phpmyadmin <<'EOF'
xxx:xxxxx
xxx:xxxxxx
xxx:xxxxxx
EOF

read -d '' -r htaccess <<EOF
Order Deny,Allow
Deny from all
Allow from 1.1.1.1
Allow from 1.1.1.1
Allow from 1.1.1.1
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
Allow from env=AllowIP
AuthUserFile /etc/httpd/conf/passwd/passwd.phpmyadmin
AuthGroupFile /dev/null
AuthName "phpmyadmin"
AuthType Basic
require user xxx xxx xxx
EOF

read -d '' -r memcache_php <<EOF
<?php
return array (
  'stats_api' => 'Server',
  'slabs_api' => 'Server',
  'items_api' => 'Server',
  'get_api' => 'Server',
  'set_api' => 'Server',
  'delete_api' => 'Server',
  'flush_all_api' => 'Server',
  'connection_timeout' => '1',
  'max_item_dump' => '100',
  'refresh_rate' => 5,
  'memory_alert' => '80',
  'hit_rate_alert' => '90',
  'eviction_alert' => '0',
  'file_path' => 'Temp/',
  'servers' =>
  array (
    'Default' =>
    array (
      'memcache1' =>
      array (
        'hostname' => '1.1.1.1',
        'port' => '11211',
      ),
      'memcache2' =>
      array (
        'hostname' => '1.1.1.1',
        'port' => '22122',
      ),
    ),
  ),
);
EOF
