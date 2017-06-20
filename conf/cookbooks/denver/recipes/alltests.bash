#!/bin/bash

su - "$username"
cd ~/DenverTraining/services/ || exit 1
./run_tests

cd ~/DenverTraining/sv_driver || exit 1
./load.sh i40e

cd ~/DenverTraining/Denver/
bin/Denver  -r bin/GoldenRegression.xml -s bin/GoldenSetup.xml

./load.sh ixgbe  –link=1gfull
bin/Denver -r bin/GoldenNianticRegression.xml  -s bin/GoldenNianticSetup.xml

exit 0
