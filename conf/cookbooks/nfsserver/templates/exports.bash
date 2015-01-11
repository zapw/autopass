eval "$setvar  exports_file" <<EOF
$(
  for client in "${clientips[@]}"; do
       printf "%s\n" "$mntpoint		$client(rw,sync,no_root_squash)"
  done
)
EOF
