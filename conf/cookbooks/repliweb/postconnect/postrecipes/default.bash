#!/bin/bash
. "$envdir/postconnect.bash"

printf -v centers "%s|" "${centers_hostnames[@]}"
centers_regex="(${centers%|})(\>|\.)"

empty -s -o "$tmpdir/in.fifo" "printf '\n%s\n' '###begin##repliweb###'\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" '###begin##repliweb###'
empty -s -o "$tmpdir/in.fifo" "echo Host is \$(hostname)\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "$centers_regex" '' '.*' ''

returnval=$?
[[ $returnval = 1 ]] && component=(center)
[[ $returnval = 2 ]] && component=(edge)

echo -e "Configuring as ${component[@]^*}\n"

empty -s -o "$tmpdir/in.fifo" "cd /tmp/repliweb/ ; if ./install ; then cd /tmp/ && rm -rf ./repliweb && echo 'done' ; else echo 'fail' ; fi\n"

empty -w -t 30 -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "press any other key." "\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "installation directory" "\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "path has write permissions" "\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "perform a standard installation" "n\n"
empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "Console[[:space:]]+y/n" "n\n"
if inarray "center" "${component[@]}" ; then
      empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "Center[[:space:]]+y/n" "y\n"
      empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "Edge[[:space:]]+y/n" "y\n"
elif inarray "edge" "${component[@]}" ; then
      empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "Center[[:space:]]+y/n" "n\n"
      empty -w -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "Edge[[:space:]]+y/n" "y\n"
fi
empty -w -t 120 -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" "email notification" "n\n" ".*" ""

[[ $? = 255 ]] && exit 1

empty -w -t 3600 -i "$tmpdir/out.fifo" -o "$tmpdir/in.fifo" 'done' '' 'fail' ''

returnval="$?"

if (( returnval == 1 )) ; then
    exit 0
elif (( returnval == 2 )) ; then
      exit 1
else
    exit 1
fi
