#!/bin/bash


/usr/bin/chown -R "$username" "/home/$username/DenverTraining/"

username="$username" team="$team" /usr/sbin/runuser "$username" -- -l <<'EOXX'

cd /home/"$username"/DenverTraining/
make -C services install || exit 1
make -C sv_driver install || exit 1

cd /home/"$username"/DenverTraining/sv_driver || exit 1

./load.sh i40e
./load.sh ixgbe -link=1gfull

cd "/home/$username/DenverTraining/" || exit 1
make -C "Denver/teams/$team" clean_lib
make -C "Denver/teams/$team" clean

make -C "Denver/teams/$team"

EOXX
if (($? == 1)); then
        exit 1
else
        exit 0
fi
