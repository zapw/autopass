eval "$setvar memcache_php" <<EOF
<?php
return array (
  'stats_api' => 'Server',
  'slabs_api' => 'Server',
  'items_api' => 'Server',
  'get_api' => 'Server',
  'set_api' => 'Server',
  'delete_api' => 'Server',
  'flush_all_api' => 'Server',
  'connection_timeout' => '1',
  'max_item_dump' => '100',
  'refresh_rate' => 5,
  'memory_alert' => '80',
  'hit_rate_alert' => '90',
  'eviction_alert' => '0',
  'file_path' => 'Temp/',
  'servers' =>
  array (
    'Default' =>
    array (
$(
  i=0
  while true; do
   	printf "      %s\n" "'$(eval "echo \${server$i[\"verbose\"]}")' =>" "array (" \
               		"  'hostname' => '$(eval "echo \${server$i[\"host\"]}")'," \
               		"  'port' => '$(eval "echo \${server$i[\"port\"]}")'," "),"
       	if ! declare -p server$((i+1)) &>/dev/null ; then
            	break
       	fi
       	((i++))
 done
)
    ),
  ),
);
EOF
