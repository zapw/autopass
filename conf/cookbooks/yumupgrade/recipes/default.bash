#!/bin/bash
set -e
if [[ $os_rel = "redhat" ]] ; then
    yum upgrade "${packages[@]}" -y 
fi
