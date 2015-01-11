eval "$setvar plugin_json" <<EOF
{
  "agents": [
$(
	i=0
        while true; do
  	       printf "%s\n%s\n%s\n%s\n%s\n%s\n%s" \
	    "    {" "      \"name\"    : \"$(eval "echo \${agent$i[\"name\"]}")\"," \
                    "      \"host\"    : \"$(eval "echo \${agent$i[\"host\"]}")\"," \
                    "      \"metrics\" : \"$(eval "echo \${agent$i[\"metrics\"]}")\"," \
                    "      \"user\"    : \"$(eval "echo \${agent$i[\"user\"]}")\"," \
                    "      \"passwd\"  : \"$(eval "echo \${agent$i[\"passwd\"]}")\"" "    }"
               if declare -p agent$((i+1)) &>/dev/null ; then
                   printf "%s\n"  ","
	       else
		   break
	       fi
	       ((i++))
        done
)
  ]
}
EOF
