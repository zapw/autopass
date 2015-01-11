eval "$setvar root_conf" <<EOF
<Directory />
$({ [[ $os_relver = 7 ]] && printf "%s\n" "$deny_all_2_4";} || { [[ $os_relver = 6 ]] && printf "%s\n" "$deny_all_2_2";})
 AllowOverride none
</Directory>
EOF
