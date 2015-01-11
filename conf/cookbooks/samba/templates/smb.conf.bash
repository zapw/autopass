eval "$setvar smb_conf" <<EOF
[global]
workgroup = $(domainname="${domainname^^}";echo "${domainname%%.*}")
   realm = ${domainname^^}
   kerberos method = system keytab
   security = ads
   client signing = yes
   client use spnego = yes
   server string = Samba Server Version %v
   local master = no
   preferred master = no
   socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192
   client ntlmv2 auth = yes
   encrypt passwords = yes
   restrict anonymous = 2
   log file = /var/log/samba/log.%m
   max log size = 50
[homes]
   comment = Home Directories
   browseable = no
   writable = yes
   valid users = %S
   map hidden = Yes
   hide dot files = no
   force group = "$apacheuser"
   root preexec = /usr/local/sbin/mkhomedir %u %g %H
EOF
