#!/bin/bash


/usr/bin/chown -R "$username" "/home/$username/DenverTraining/"

sudo username="$username" team="$team" /usr/sbin/runuser "$username" -- -l <<'EOXX'

cd "/home/$username/" && rm -rf .ccache/ 2>/dev/null
cd /home/"$username"/DenverTraining/ || exit 1
make -C services clean_lib
make -C services clean
make -C sv_driver clean
make -C "Denver/teams/$team" clean_lib
make -C "Denver/teams/$team" clean

make -C services
make -C sv_driver
make -C "Denver/teams/$team"


cd /home/"$username"/DenverTraining/sv_driver || exit 1

./load.sh i40e
./load.sh ixgbe -link=1gfull

exit 0

EOXX
if (($? == 1)); then
        exit 1
else
        exit 0
fi
