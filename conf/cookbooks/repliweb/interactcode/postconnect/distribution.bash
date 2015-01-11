#!/bin/bash
. "$envdir/interactcode.bash"
loguser="$user"
logport="$port"
logserver="$server"
emptydir="$tmpdir"

exec 1>&5 5>&- 4>&-
declare -p loguser logport logserver emptydir
