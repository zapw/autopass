eval $setvar grant_all_2_2 <<'EOF'
 Order allow,deny
 Allow from all
EOF
eval $setvar grant_all_2_4 <<'EOF'
 Require all granted
EOF
eval $setvar deny_all_2_2 <<'EOF'
 Order allow,deny
 Deny from all
EOF
eval $setvar deny_all_2_4 <<'EOF'
 Require all denied
EOF
eval $setvar allow_ip_host_2_2 <<'EOF'
 Allow from
EOF
eval $setvar allow_ip_2_4 <<'EOF'
 Require ip
EOF
eval $setvar allow_host_2_4 <<'EOF'
 Require host
EOF
