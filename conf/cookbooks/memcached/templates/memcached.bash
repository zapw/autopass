eval "$setvar sysconfig_memcached" <<EOF
$(
  for key in "${!memcached[@]}" ; do
       printf "%s\n" "$key=\"${memcached["$key"]}"\"
  done
)
EOF
