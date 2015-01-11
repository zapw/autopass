declare -a packages=(httpd mod_ssl mod_security)
declare -A enviros qa_enviros

dstdir="/var/www/html"
users_dir="/etc/httpd/conf.d/users"
conf_modules_dir="conf.modules.d"
