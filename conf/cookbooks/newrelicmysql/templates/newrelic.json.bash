eval "$setvar newrelic_json" <<EOF
{
  "license_key": "$license_key",
  "log_level": "$log_level",
  "log_file_name": "$log_file_name",
  "log_file_path": "$log_file_path"
}
EOF
