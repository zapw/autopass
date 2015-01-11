eval "$setvar dir_conf" <<EOF
<Directory ${basedir%/}/${companyname}/*/public_html/>
 Options FollowSymlinks
 AllowOverride FileInfo Indexes
$({ [[ $os_relver = 7 ]] && printf "%s\n" "$grant_all_2_4";} || { [[ $os_relver = 6 ]] && printf "%s\n" "$grant_all_2_2";})
</Directory>

<Directory ${basedir%/}/${companyprefix}sys/>
$({ [[ $os_relver = 7 ]] && printf "%s\n" "$grant_all_2_4" ;} || { [[ $os_relver = 6 ]] && printf "%s\n" "$grant_all_2_2";})
 AllowOverride none
</Directory>

<Directory ${basedir%/}/crm/>
$({ [[ $os_relver = 7 ]] && printf "%s\n" "$grant_all_2_4" ;} || { [[ $os_relver = 6 ]] && printf "%s\n" "$grant_all_2_2";})
 AllowOverride FileInfo Indexes Options
</Directory>
EOF
