eval "$setvar newrelic_plugin_wrapper" <<'EOF'
#!/bin/bash

trap "kill $newrelic_modulepid &>/dev/null; wait $newrelic_modulepid; exit 1" INT
abort () {
   kill "$newrelic_modulepid" ; wait $newrelic_modulepid
   [[ -f "${PID_FILE}" ]] && rm -f "${PID_FILE}"
   exit 1
} &>/dev/null

if ! jqbin="$(type -P jq)" ; then
    if [[ ! -x /usr/local/bin/jq ]]  ; then
	echo "required 'jq' binary not found"
	echo "download from http://stedolan.github.io/jq/download or run autopass jq job"
	abort
    else
	jqbin=/usr/local/bin/jq
    fi
fi

"$@" & newrelic_modulepid=$!
echo "$newrelic_modulepid" >"${PID_FILE}"

time=0 timeout=15
read -ra hostports < <( "$jqbin" -r '.agents[].host' "${PLUGIN_DIR}/config/plugin.json" | tr '\n' ' ')

while sleep 5; do
     (( connected = 1 ))
     for hostport in "${hostports[@]}" ; do 
	  [[ $hostport = "${hostport%:*}" ]] && hostport="$hostport:3306"
	  lsof -a -u $user -i "tcp@$hostport" -Ts -p "$newrelic_modulepid" |grep ESTABLISHED &>/dev/null && continue
	  (( connected = 0 ))
	  break
     done
     if (( connected )) ; then
         echo "$newrelic_modulepid"  >"${PID_FILE}"
         break
     fi


     if ! kill -0 $newrelic_modulepid &>/dev/null; then
         wait "$newrelic_modulepid"; newrelicexit=$?
         exit "$newrelicexit"
     fi
     if (( ++time > timeout )); then
	 abort
     fi
done
EOF
