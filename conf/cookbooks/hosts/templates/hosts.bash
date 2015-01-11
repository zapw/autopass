eval "$setvar hostsfile" <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

$(
  i=0
  num="${#keys[@]}"
  for key in "${keys[@]}" ; do
       ((i++))
       echo "${hosts["$key"]}" | awk '$0 !~ /^$/'
       (( i < num )) && echo
  done
)
EOF
