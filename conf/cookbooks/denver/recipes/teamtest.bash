#!/bin/bash

sudo username="$username" team="$team" runuser -u "$username" -- /bin/bash -l <<'EOXX'

cd /home/$username/DenverTraining/sv_driver || exit 1
./load.sh i40e

cd "/home/$username/DenverTraining/Denver/teams/$team" || exit 1
bin/Denver  -r bin/GoldenRegression.xml -s bin/GoldenSetup.xml

cd /home/$username/DenverTraining/sv_driver || exit 1
./load.sh ixgbe -link=1gfull

cd "/home/$username/DenverTraining/Denver/teams/$team" || exit 1
bin/Denver -r bin/GoldenNianticRegression.xml -s bin/GoldenNianticSetup.xml
EOXX
