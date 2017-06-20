#!/bin/bash

cp -a /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/ || exit 1
sed -i "s/<USER>/$username/" /usr/lib/systemd/system/vncserver@.service
systemctl daemon-reload
sleep 1
systemctl stop vncserver@:1.service 2>/dev/null
sleep 1
for pid in $(pgrep Xvnc); do
	kill "$pid" || kill -9 "$pid"
done
sleep 1
systemctl start vncserver@:1.service || exit 1
systemctl enable vncserver@.service
mv /etc/systemd/system/multi-user.target.wants/vncserver@.service /etc/systemd/system/multi-user.target.wants/vncserver@:1.service
