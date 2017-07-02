#!/bin/bash

if systemctl  status vncserver@\:1.service 2>/dev/null >/dev/null; then
	systemctl stop vncserver@\:1.service
fi
rm -f /etc/systemd/system/vncserver@.service 2>/dev/null
systemctl daemon-reload
