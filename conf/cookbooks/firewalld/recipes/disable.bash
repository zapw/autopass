#!/bin/bash

if [[ $os_rel = redhat && $os_relver == 7 ]] ; then
    systemctl stop firewalld
    systemctl disable firewalld
fi
