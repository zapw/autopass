#!/bin/bash

username="$username" team="$team" /usr/sbin/runuser "$username" -- -l <<'EOXXqwewqeCZ'

cd /home/$username/DenverTraining/sv_driver || exit 1
./load.sh i40e
./load.sh ixgbe -link=1gfull

cd "/home/$username/DenverTraining/" || exit 1
make -C "Denver/teams/$team" || exit 1

cd "/home/$username/DenverTraining/Denver/teams/$team" || exit 1
bin/Denver -r bin/GoldenRegression.xml -s bin/GoldenSetup.xml
bin/Denver -r bin/GoldenNianticRegression.xml -s bin/GoldenNianticSetup.xml

exit 0
EOXXqwewqeCZ

if (($? == 1)); then
        exit 1
else
        exit 0
fi
