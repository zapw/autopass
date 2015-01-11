#!/bin/bash
set -e

pushd /tmp >/dev/null
curl -s -k "$url" | tar -zxvf -
pushd ZendServer-RepositoryInstaller-linux >/dev/null
./install_zs.sh $phpversion --automatic && popd >/dev/null
rm -rf ./ZendServer-RepositoryInstaller-linux

service_name httpd restart
