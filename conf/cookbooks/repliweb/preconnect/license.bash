#!/bin/bash
. "$envdir/preconnect.bash"

checkvars repliweblic

package_install dos2unix unzip

showcookbook on
declare -A repliweblicfile_tmp

if [[ -d "$repliweblic" ]] ; then
     for server; do
           repliweblicfile=("${repliweblic%/}/"*"${server%.prod*}/lic_repliweb.rw")
           if (( ${#repliweblicfile[@]} > 1 )) ; then
                printf "%s\n" "more than one repliweb license matched:" "${repliweblicfile[@]}" "aborting".
                exit 1
           fi
           if [[ ! -f "$repliweblicfile" ]] ; then
                echo "can't find file 'lic_repliweb.rw' server:${server%.prod*} in $repliweblic"
                exit 1
           fi

           if cp "$repliweblicfile" "$tmpdir/${server%.prod*}-lic_repliweb.rw" && dos2unix "$tmpdir/${server%.prod*}-lic_repliweb.rw" ; then
                repliweblicfile_tmp["$server"]="$tmpdir/${server%.prod*}-lic_repliweb.rw"
           else
                exit 1
           fi
     done
elif [[ -e "$repliweblic" ]] ; then 
       if file -b "$repliweblic" | grep -q '^Zip[0-9]*' ; then
	   unzip -qq -aa -c "$repliweblic" 2>/dev/null >"$tmpdir/shared-lic_repliweb.rw" || exit 1
       else 
	   cp "$repliweblic" "$tmpdir/shared-lic_repliweb.rw" && dos2unix "$tmpdir/shared-lic_repliweb.rw" || exit 1
       fi
       repliweblicfile_shared_tmp="$tmpdir/shared-lic_repliweb.rw"
else
     echo "Unable to read repliweb license at <$repliweblic>"
     exit 1
fi
exec 1>&5 5>&- 4>&-
declare -p repliweblicfile_tmp repliweblicfile_shared_tmp 2>/dev/null
