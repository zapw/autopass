eval "$setvar sssd_conf" <<EOF
[sssd]
services = nss
config_file_version = 2
domains = ${domainname^^}

[nss]
filter_users = root
filter_groups = root

override_homedir = /home/$(domainname="${domainname^^}";echo ${domainname%%.*})/%u

[pam]

[domain/${domainname^^}]
# Using id_provider=ad sets the best defaults on its own
id_provider = ad
# In sssd, the default access provider is always 'permit'. The AD access
# provider by default checks for account expiration
access_provider = ad
auth_provider = ad

# Uncomment to use POSIX attributes on the server
ldap_id_mapping = False
default_shell = /bin/false

# Uncomment if the client machine hostname doesn't match the computer object on the DC.
# ad_hostname = dc1.samdom.example.com

# Uncomment if DNS SRV resolution is not working
# ad_server = dc1.samdom.example.com

# Uncomment if the domain section is named differently than your Samba domain
# ad_domain = samdom.example.com

# Enumeration is discouraged for performance reasons.
enumerate = True
subdomain_enumerate = all

#use_fully_qualified_names = True
EOF
