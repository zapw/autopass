#!/bin/bash
set -e
bashversion

shopt -s nocaseglob nullglob

cd "$dstdir"

[[ -d ./memcacheAdmin ]] && rm -rf ./memcacheAdmin

mkdir memcacheAdmin
cd memcacheAdmin
curl -s "$url" | tar -xzf -

echo "$memcacheadmin_conf" >"/etc/httpd/conf.d/memcacheadmin.conf"
echo "$memcache_php" >"Config/Memcache.php"

service_name httpd reload
