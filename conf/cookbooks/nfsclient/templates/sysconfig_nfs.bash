eval "$setvar sysconfig_nfs" <<EOF
LOCKD_TCPPORT="$lockd_tcpport"
LOCKD_UDPPORT="$lockd_udpport"
STATD_PORT="$statd_port"
STATD_OUTGOING_PORT="$statd_outgoing_port"
EOF
