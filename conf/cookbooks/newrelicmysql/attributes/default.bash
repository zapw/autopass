user="newrelic"
extract_path="/usr/local/share/newrelic"
plugin_dir="/usr/local/share/newrelic/newrelic_mysql_plugin-2.0.0"
package="java-1.8.0-openjdk-headless"
delljre="/opt/dell/srvadmin/lib64/openmanage/jre"

license_key=""
log_level="info"
log_file_name="$newrelic_mysql_plugin.log"
log_file_path="/var/log/newrelic"

declare -A agent{0..0}

agent0["name"]="servername"
agent0["host"]="localhost"
agent0["metrics"]="status,slave,master,newrelic"
agent0["user"]=""
agent0["passwd"]=""
