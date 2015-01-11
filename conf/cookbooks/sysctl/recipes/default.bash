#!/bin/bash
checkvars sysctl_conf
echo "$sysctl_conf" >/etc/sysctl.conf
sysctl -q -p
