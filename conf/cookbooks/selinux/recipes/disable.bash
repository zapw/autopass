#!/bin/bash
set -e

printf "%s\n" ",s/^SELINUX=.\+/SELINUX=disabled/" w | ed -s /etc/selinux/config
setenforce 0 || true
sestatus | grep -q 'disabled'
