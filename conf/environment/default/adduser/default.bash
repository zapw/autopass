sshgroup=("foobars")
sudogroup=("bars")

#       pw_name:pw_passwd:pw_uid:pw_gid:pw_gecos:pw_dir:pw_shell:enforcechpasswd
#       man newusers(8) -  last field is custom and is removed
#       set last field to 1 to enforce password change
eval "$setvar newusers" <<'EOF'
#foobar1:Password1:::Foobar User1:/home/foobar1:/bin/bash:1
#foobar2:Password2:::Foobar User2:/home/foobar2:/bin/bash # no enforce password change
EOF
