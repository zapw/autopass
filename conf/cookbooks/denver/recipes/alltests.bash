#!/bin/bash

sudo username="$username" runuser -u "$username" -- /bin/bash <<'EOXX'
cd /home/$username/DenverTraining/services/ || exit 1
./run_tests

cd /home/$username/DenverTraining/sv_driver || exit 1
./load.sh i40e

cd /home/$username/DenverTraining/Denver/
bin/Denver  -r bin/GoldenRegression.xml -s bin/GoldenSetup.xml

./load.sh ixgbe  –link=1gfull
bin/Denver -r bin/GoldenNianticRegression.xml  -s bin/GoldenNianticSetup.xml
EOXX
