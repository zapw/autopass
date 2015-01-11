#!/bin/bash
set -e
bashversion

shopt -s nocaseglob nullglob

cd "$dstdir"

[[ -d "./$phpdir_name" ]] && rm -rf "./$phpdir_name"
mkdir "$phpdir_name" && cd "$phpdir_name"

curl -s "$url" | tar -Jxvf - --strip-components=1
echo "$config_inc_php" >config.inc.php
echo "$phpmyadmin_conf" >/etc/httpd/conf.d/phpmyadmin.conf

service_name httpd reload
