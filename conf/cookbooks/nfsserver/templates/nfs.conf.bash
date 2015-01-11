eval "$setvar nfs_module" <<EOF
options lockd nlm_udpport=$lockd_udpport nlm_tcpport=$lockd_tcpport
options nfs callback_tcpport=$callback_tcpport
EOF
