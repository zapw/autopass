#!/bin/bash

cp -a /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/ || exit 1
sed -i "s/<USER>/$username/" /etc/systemd/system/vncserver@.service || exit 1
systemctl daemon-reload
systemctl stop vncserver@:1.service 2>/dev/null
for pid in $(pgrep Xvnc); do
	kill -15 "$pid" || kill -9 "$pid"
done
while pgrep Xvnc >/dev/null; do
	 sleep 1
done
for i in 1 2 3 4; do
	systemctl start vncserver@:1.service && break
	sleep 1
done
systemctl enable vncserver@.service
mv /etc/systemd/system/multi-user.target.wants/vncserver@.service /etc/systemd/system/multi-user.target.wants/vncserver@:1.service
