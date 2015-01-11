eval "$setvar server_status_conf" <<EOF
<Location /${companyprefix}status>
 SetHandler server-status
$( if [[ $os_relver = 7 ]] ; then
        printf "%s\n" "$deny_all_2_4" "$allow_ip_2_4 $officeips"
    elif [[ $os_relver = 6 ]] ; then
          printf "%s\n" "$deny_all_2_2" "$allow_ip_host_2_2 $officeips"
    fi
)
</Location>
EOF
