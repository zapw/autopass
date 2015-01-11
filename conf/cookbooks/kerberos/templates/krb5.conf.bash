eval "$setvar krb5_conf" <<EOF
[logging]
 default = FILE:/var/log/krb5libs.log

[libdefaults]
 default_realm = ${domainname^^}
 dns_lookup_realm = true
 dns_lookup_kdc = true
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
EOF
