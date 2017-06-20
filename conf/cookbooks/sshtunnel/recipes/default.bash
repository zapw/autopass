#!/bin/bash

echo "$ssh_tunnel" >/etc/systemd/system/sshtunnel.service || exit 1
systemctl daemon-reload
systemctl stop sshtunnel 2>/dev/null
systemctl start sshtunnel
systemctl enable sshtunnel 
