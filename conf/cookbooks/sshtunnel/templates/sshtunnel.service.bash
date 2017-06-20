eval "$setvar sshtunnel_service" <<EOF
[Unit]
Description=SSH Tunnel
After=network.target

[Service]
Restart=always
RestartSec=20
User=$service_user
ExecStart=/usr/bin/ssh -NT -o ServerAliveInterval=60 -R $remote_port:localhost:5901 $service_user@$remotehost

[Install]
WantedBy=multi-user.target
EOF
