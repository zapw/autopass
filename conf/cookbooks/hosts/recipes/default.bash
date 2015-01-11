#!/bin/bash
checkvars hostsfile
bashversion
echo "$hostsfile" >/etc/hosts
