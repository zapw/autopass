#!/bin/bash
. "$envdir/preconnect.bash"
checkvars lockd_tcpport lockd_udpport mountd_port statd_port statd_outgoing_port callback_tcpport rpcnfsdcount rpcnfsdargs mountd_nfs_v2 clientips
