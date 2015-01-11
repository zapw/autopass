eval "$setvar varwww_conf" <<EOF
<Directory "/var/www/html">
 Options -Indexes
$({ [[ $os_relver = 7 ]] && printf "%s\n" "$grant_all_2_4";} || { [[ $os_relver = 6 ]] && printf "%s\n" "$grant_all_2_2";})
 AllowOverride none
</Directory>
EOF
