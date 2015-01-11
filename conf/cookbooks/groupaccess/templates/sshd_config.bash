eval "$setvar match_block" <<EOF
Match Group "$sftpgroup"
        X11Forwarding no
        AllowTcpForwarding no
        ForceCommand internal-sftp
EOF
