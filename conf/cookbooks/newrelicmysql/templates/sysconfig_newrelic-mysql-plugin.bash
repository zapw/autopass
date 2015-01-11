eval "$setvar sysconfig_newrelic_mysql" <<EOF
export PLUGIN_DIR=$plugin_dir
export user="$user"
delljre="$delljre"
PROGRAM="newrelic-mysql-plugin"
LOG_DIR=/var/log/newrelic
wrapper_executable="$plugin_dir/newrelic-plugin-wrapper"
EOF
