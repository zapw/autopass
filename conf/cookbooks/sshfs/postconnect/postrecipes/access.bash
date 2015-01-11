#!/bin/bash
. "$envdir/postconnect.bash"

printf -v centers "%s|" "${centers_hostnames[@]}"
centers_regex="(${centers%|})(\>|\.)"

empty -s -o "$tmpdir/in.fifo" "printf '\n%s\n' '###begin##${cookbook}::${0##*/}###'\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "###begin##${cookbook}::${0##*/}###"
empty -s -o "$tmpdir/in.fifo" "echo Host is \$(hostname)\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "$centers_regex" '' '.*' ''

returnval=$?
[[ $returnval = 1 ]] && component="private"
[[ $returnval = 2 ]] && component="public"

echo -e "Copying ${component} key\n"

if [[ ${component} = "public" ]] ; then
    empty -s -c -o "$tmpdir/in.fifo" <<-EOF
	(umask 0077
	if [[ ! -d $homedir/.ssh ]] ; then
            sudo -u $user mkdir -p $homedir/.ssh
        fi
	[[ -f "$homedir/.ssh/authorized_keys" ]] && rm -f "$homedir/.ssh/authorized_keys"
        if sudo -u $user /bin/bash -c 'cat >$homedir/.ssh/authorized_keys' <<'EOF'
	EOF
    empty -s -c -o "$tmpdir/in.fifo" <"${sshfskey}.pub"
    empty -s -o "$tmpdir/in.fifo" "EOF\n"
    empty -s -o "$tmpdir/in.fifo" "then echo 'copied';else echo 'failed'; fi)\n"
    empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "copied" "" "failed" ""
    returnval="$?"
    if (( returnval == 1 )) ; then
         exit 0
    elif (( returnval == 2 )) ; then
           exit 1
    else
        exit 1
    fi
elif [[ ${component} = "private" ]] ; then
	empty -s -c -o "$tmpdir/in.fifo" <<-EOF
	(umask 0077
	[[ ! -d "${identifyfile%/*}" ]] && mkdir -p "${identifyfile%/*}" 
	if cat >"${identifyfile}" <<'EOF'
	EOF
	empty -s -c -o "$tmpdir/in.fifo" <"${sshfskey}"
	empty -s -o "$tmpdir/in.fifo" "EOF\n"
	empty -s -o "$tmpdir/in.fifo" "then echo 'copied'; else echo 'failed'; fi)\n"
	empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "copied" "" "failed" ""
	returnval="$?"
	if (( returnval == 1 )) ; then
		exit 0
	elif (( returnval == 2 )) ; then
		exit 1
	else
		exit 1
	fi
else
	exit 1
fi
