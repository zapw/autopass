#!/bin/bash
set -e
. "$envdir/postconnect.bash"

if [[ -f "${repliweblicfile_tmp["$server"]}" ]] ; then
     rm -f "${repliweblicfile_tmp["$server"]}"
elif [[ -f "$repliweblicfile_shared_tmp" ]] ; then
     rm -f "$repliweblicfile_shared_tmp"
fi
