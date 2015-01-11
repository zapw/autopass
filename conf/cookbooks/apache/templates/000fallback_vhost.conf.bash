eval "$setvar fallback_vhost" <<'EOF'
<VirtualHost *:80>
 ServerName default
 DocumentRoot /var/www/html
 ErrorLog logs/general-error-log
 CustomLog logs/general-acces-log common
</VirtualHost>
EOF
