eval "$setvar alias_conf" <<EOF
Alias /serverid "/var/www/html/serverid.php"
Alias /${companyprefix^}SysPub "${basedir%/}/${companyprefix}sys/sys/public_html"
Alias /crm ${basedir%/}/crm/public_html/public
$( 
   shopt -s extglob
   for qa_server in "${qa_servers[@]}" ; do
     if [[ $HOSTNAME = "${qa_server%%.*}"@(|.*) ]] ; then
          printf "Alias %s\n" "/memcacheadmin \"${dstdir%/}/memcacheAdmin\"" "/phpmyadmin \"${dstdir%/}/phpMyAdmin\""
          break
     fi
   done
)
EOF
