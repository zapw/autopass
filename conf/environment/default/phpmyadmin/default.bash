#url="http://garr.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.3.11/phpMyAdmin-4.3.11-english.tar.xz"
url="http://hivelocity.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.5.7/phpMyAdmin-3.5.7-all-languages.tar.xz"
dstdir="/var/www/html"
passwd_phpmyadmin_dir="/etc/httpd/conf/passwd"
phpmyadmin_passwd_file="passwd.phpmyadmin"
apacheuser="apache"
phpdir_name="phpMyAdmin"

read -d '' passwd_phpmyadmin <<'EOF'
x:x
x:x
EOF

read -d '' -r htaccess <<EOF
Order Deny,Allow
Deny from all
Allow from 1.1.1.1
Allow from 1.1.1.1
Allow from 1.1.1.1
Allow from 1.1.1.1
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
SetEnvIF X-FORWARDED-FOR "1.1.1.1" AllowIP
Allow from env=AllowIP
AuthUserFile $passwd_phpmyadmin_dir/$phpmyadmin_passwd_file
AuthGroupFile /dev/null
AuthName "phpmyadmin"
AuthType Basic
require user foobarAdmin spdadmin
EOF

read -d '' -r config_inc_php <<'EOF'
<?php
$cfg['blowfish_secret'] = 'a8b7c6d'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['verbose']   = 'db-master';
$cfg['Servers'][$i]['host'] = 'db-master.hk1.foobar.com';
$cfg['Servers'][$i]['port'] = '3306';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['verbose']   = 'db-slave';
$cfg['Servers'][$i]['host'] = 'db-slave.hk1.foobar.com';
$cfg['Servers'][$i]['port'] = '3306';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['verbose']   = 'db-logs';
$cfg['Servers'][$i]['host'] = 'db-logs.hk1.foobar.com';
$cfg['Servers'][$i]['port'] = '3312';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;
$cfg['ServerDefault'] = 1;
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
?>
EOF
