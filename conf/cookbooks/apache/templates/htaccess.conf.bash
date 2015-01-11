eval "$setvar htaccess_conf" <<EOF
<Files ".ht*">
$({ [[ $os_relver = 7 ]] && printf "%s\n" "$deny_all_2_4";} || { [[ $os_relver = 6 ]] && printf "%s\n" "$deny_all_2_2";})
</Files>
EOF
