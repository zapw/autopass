#       pw_name:pw_passwd:pw_uid:pw_gid:pw_gecos:pw_dir:pw_shell:enforcechpasswd:nosudo:nossh
#       man newusers(8) -  last field is custom and is removed
#       set enforcechpasswd field to 1 to enforce password change
#       set nosudo field to 1 to disable sudo 
#       set nossh field to 1 to disable ssh access
eval "$setvar newusers" <<'EOF'
#foobar:foopassword:::Foobar User:/home/foobar:/bin/bash:1 # enforce changepasswd
#foobar:foopassword:::Foobar User:/home/foobar:/bin/bash # no enforce changepasswd
#foobar:foopassword:::Foobar User:/home/foobar:/bin/bash::1 # no enforce changepasswd, nosudo
#foobar:foopassword:::Foobar User:/home/foobar:/bin/bash:::1 # no enforce changepasswd, sudo, nossh
#foobar:foopassword:::Foobar User:/home/foobar:/bin/bash:1:1:1 # enforce changepasswd, nosudo, nossh
EOF
