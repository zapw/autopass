#!/bin/bash

set -e

cp -a /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/
sed -i "s/<USER>/$username/" /usr/lib/systemd/system/vncserver@.service
systemctl daemon-reload
systemctl start vncserver@:1.service
systemctl enable vncserver@.service
mv /etc/systemd/system/multi-user.target.wants/vncserver@.service /etc/systemd/system/multi-user.target.wants/vncserver@:1.service
