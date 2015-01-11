#!/bin/bash
set -e

machine="$(uname -m)"
if [[ $machine != "x86_64" ]] ; then
     machine="32"
else
     machine="64"
fi

wget --quiet "http://stedolan.github.io/jq/download/linux${machine}/jq" -O "$download_path/jq"
chmod +x "$download_path/jq"
