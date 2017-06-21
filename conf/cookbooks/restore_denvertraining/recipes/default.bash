#!/bin/bash
set -e

rootpath="/home/$username/DenverTraining"

for path in $rootpath/{services,sv_driver}; do
	cd $path/ && make install
done

./load.sh i40e || true
./load.sh ixgbe -link=1gfull || true

cd "$rootpath/Denver/teams/10Gs_team" && make
