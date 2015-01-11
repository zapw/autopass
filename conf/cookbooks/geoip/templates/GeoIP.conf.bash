eval "$setvar geoip_conf" <<EOF
# If you purchase a subscription to the GeoIP database,
# then you will obtain a license key which you can
# use to automatically obtain updates.
# for more details, please go to
# http://www.maxmind.com/app/products

# see https://www.maxmind.com/app/license_key_login to obtain License Key,
# UserId, and available ProductIds

# Enter your license key here
LicenseKey $licensekey

# Enter your User ID here
UserId $userid

# Enter the Product ID(s) of the database(s) you would like to update
# By default 106 (MaxMind GeoIP Country) is listed below
ProductIds $productids
EOF
