#!/bin/bash

username="$username" team="$team" /usr/sbin/runuser "$username" -- -l <<'EZXzczxc2OXX'

cd /home/$username/DenverTraining/services/ || exit 1
./run_tests

EZXzczxc2OXX

if (($? == 1)); then
	exit 1
else
	exit 0
fi
