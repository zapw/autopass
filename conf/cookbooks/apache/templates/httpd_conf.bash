eval "$setvar httpd_conf" <<EOF
ServerRoot "/etc/httpd"
Listen 80
PidFile run/httpd.pid
Timeout 60
KeepAlive On
MaxKeepAliveRequests 300
KeepAliveTimeout 1

Include conf.modules.d/*.conf

<IfModule prefork.c>
$({ [[ $os_relver = 7 ]] && printf "%s" "MaxConnectionsPerChild";} || { [[ $os_relver = 6 ]] && printf "%s" "MaxRequestsPerChild";}) 2000
</IfModule>

User apache
Group apache

ServerAdmin root@localhost
ServerName localhost
DocumentRoot "/var/www/html"

TypesConfig /etc/mime.types

AddDefaultCharset UTF-8

<IfModule mod_mime_magic.c>
    MIMEMagicFile conf/magic
</IfModule>

FileETag MTime Size
TraceEnable off
Include conf.d/*.conf
$({ [[ $os_relver = 7 ]] && printf "%s" "IncludeOptional";} || { [[ $os_relver = 6 ]] && printf "%s" "Include";}) conf.d/users/*.conf
EOF
