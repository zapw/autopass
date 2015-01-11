eval "$setvar expires_conf" <<EOF
ExpiresActive On
ExpiresDefault A0

<FilesMatch "\.(flv|xml|bmp|gif|jpg|jpeg|png|swf)$">
ExpiresDefault A86400
Header append Cache-Control "public"
</FilesMatch>

<FilesMatch "\.(css|js)$">
ExpiresDefault A172800
Header append Cache-Control "proxy-revalidate"
</FilesMatch>

<FilesMatch "\.(json|j${companyprefix,,})$">
ExpiresDefault A900
Header append Cache-Control "proxy-revalidate"
</FilesMatch>

# 86400
<FilesMatch "\.(flv|xml|bmp|jpg|jpeg|png|gif|swf)$">
Header set Cache-Control "max-age=86400, public"
</FilesMatch>

# 172800
<FilesMatch "\.(js|css)$">
Header set Cache-Control "max-age=172800, public"
</FilesMatch>

# 900
<FilesMatch "\.(json|j${companyprefix,,})$">
Header set Cache-Control "max-age=900, public"
</FilesMatch>

# 300
<FilesMatch "^($(prefix="${companyprefix,,}";fullname="${companyname,,}";suffix="${fullname#$prefix}";echo "${prefix^}${suffix^}Plugin|${fullname^}")Plugin)\.js">
Header set Cache-Control "max-age=300, public"
</FilesMatch>
EOF
