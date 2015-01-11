eval "$setvar config_inc_php" <<EOF
<?php
\$cfg['blowfish_secret'] = '$(package_install pwgen &>/dev/null;pwgen -sn1 46)'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
\$i = 0;
$(
  i=0
  while true; do
       printf "%s\n" '$i++;'
       printf "\$cfg['Servers'][\$i]%s\n" "['auth_type'] = 'cookie';" \
		  "['verbose']   = '$(eval "echo \${server$i[\"verbose\"]}")';" \
		  "['host'] = '$(eval "echo \${server$i[\"host\"]}")';" \
		  "['port'] = '$(eval "echo \${server$i[\"port\"]}")';" \
		  "['connect_type'] = 'tcp';" \
		  "['compress'] = false;" \
		  "['AllowNoPassword'] = false;"
       if ! declare -p server$((i+1)) &>/dev/null ; then
             break
       fi
       ((i++))
  done
)
\$cfg['ServerDefault'] = 1;
\$cfg['UploadDir'] = '';
\$cfg['SaveDir'] = '';
?>
EOF
