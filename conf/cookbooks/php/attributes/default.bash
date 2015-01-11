packages=(php54 php54-mysqlnd php54-common php54-gd php54-mbstring php54-mcrypt php54-devel php54-xml php54-pecl-memcache php54-pecl-memcached php54-bcmath php54-pecl-geoip php54-intl php54-soap php54-pecl-redis php54-pecl-zendopcache)

packages56u=(php56u php56u-mysqlnd php56u-common php56u-gd php56u-mbstring php56u-mcrypt php56u-devel php56u-xml php56-pecl-memcache php56u-memcached php56u-bcmath php56u-pecl-geoip php56u-intl php56u-soap php56u-pecl-redis php56u-opcache)

declare -A enviros qa_enviros
qa_servers=(web1)
enviros=(["ENVIRONMENT"]="" ["SYS_PATH"]="" ["APPLICATION_ENV"]="production")
qa_enviros=(["APPLICATION_ENV"]="qa")

opcache_ini_file56u="10-opcache.ini"
opcache_ini_file="opcache.ini"

phpini_dir="/etc/php.d"
php_main_ini_file="/etc/php.ini"
profile_d="/etc/profile.d"
