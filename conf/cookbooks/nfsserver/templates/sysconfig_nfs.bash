eval "$setvar sysconfig_nfs" <<EOF
MOUNTD_NFS_V2="$mountd_nfs_v2"
LOCKD_TCPPORT=$lockd_tcpport
LOCKD_UDPPORT=$lockd_udpport
RPCNFSDARGS="$rpcnfsdargs"
RPCNFSDCOUNT=$rpcnfsdcount
RPCMOUNTDOPTS="-p $mountd_port"
MOUNTD_PORT=$mountd_port
STATD_PORT=$statd_port
STATD_OUTGOING_PORT=$statd_outgoing_port
EOF
