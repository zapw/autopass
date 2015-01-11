eval "$setvar transport_map" <<EOF
$mydomain smtp:$relayhost_internal
.$mydomain smtp:$relayhost_internal
EOF
