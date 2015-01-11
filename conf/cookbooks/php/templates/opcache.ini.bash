eval "$setvar opcache_ini" <<EOF
zend_extension=/usr/lib64/php/modules/opcache.so
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.blacklist_filename=/etc/php.d/opcache*.blacklist
EOF
