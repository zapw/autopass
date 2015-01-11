eval "$setvar geoipupdate_cron" <<EOF
#!/bin/sh

geoipupdate -d "$copydst" > /dev/null
EOF
