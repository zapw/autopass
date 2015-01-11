eval "$setvar phpmyadmin_conf" <<EOF
<Directory "${dstdir%/}/phpMyAdmin/">
$( 
if [[ $os_relver = 7 ]] ; then 
    printf "%s\n" " <RequireAll>" "   <RequireAny>" "      Require ip ${allowedips[*]}" "      Require env AllowIP" "   </RequireAny>"
elif [[ $os_relver = 6 ]] ; then
      printf " %s\n" "Order Deny,Allow" "Deny from all" "Allow from ${allowedips[*]}" "Allow from env=AllowIP"
fi
if [[ $os_relver = 7 ]] ; then
     pad="       "
elif [[ $os_relver = 6 ]] ; then
     pad=" "
fi

printf "$pad%s\n" "AuthUserFile \"$passwd_dir/$passwd_file\"" "AuthName \"phpmyadmin\"" "AuthType Basic"
printf -vformat " \"%%s\"%.s" "${allowedusers[@]}"
printf "$pad%s$format\n" "Require user" "${allowedusers[@]}"
[[ $os_relver = 7 ]] && printf "%s\n" " </RequireAll>"

for ip in "${allowedips[@]}" ; do 
     printf " SetEnvIF X-FORWARDED-FOR \"%s\" AllowIP\n" "$ip"
done
)
</Directory>
EOF
