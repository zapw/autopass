#!/bin/bash
set -e
if [[ "$repliweblicfile_shared_tmp" ]] ; then
     if iscenter ; then
           cp "/usr/repliweb/rds/license/lic_repliweb.rw" "/usr/repliweb/r1/license/lic_repliweb.rw"
     fi
else
     cp "/usr/repliweb/rds/license/lic_repliweb.rw" "/usr/repliweb/r1/license/lic_repliweb.rw"
fi
