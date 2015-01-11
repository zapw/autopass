eval "$setvar mkhomedir" <<'EOF'
#!/bin/bash

umask 0022

(( ${#@} != 3 )) && exit 0

user="$1"
group="$2"
homedir="$3"

if [[ ! -e "$homedir" ]]; then
        mkdir -p "$homedir"
        chown "$user:$group" "$homedir"
fi
exit 0
EOF
