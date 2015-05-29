#!/bin/env bash
bashversion

declare -A DocumentRoot type name filesite allsites csum
export src_environment curl_contimeout curl_maxtime

exec 6>&1
if [[ ! ${src_environment} ]] ; then
     src_environment="$(hostname -f)"
     src_environment="${src_environment#*.}"
     printf "\n%s\n%s\n" "Warning! <src_environment> not set" "using hostname's extracted domain name <$src_environment> as string to match with <$uripath>"
fi

homedir="$(getent passwd "$loguser" | awk -F: '{print $6}')"
if cd "$homedir"; then 
    if [[ -f "$filename" ]]; then
         rm -f "$filename" || exit 1
    fi
else
     exit 1
fi

printf "\n%s\r" "Scanning files for ServerName and ServerAlias, please wait..."
files=($(apachectl -S 2>/dev/null| awk -F'[[:space:](:]*' '$2 == "port" && !seen[$6]++ {print $6}'))
for file in "${files[@]}"; do 
      for site in $(awk '$1 ~ /^Server(Alias|Name)/{for (i=2; i <=NF; i++) if ( !seen[$i]++ )  print $i}' "$file"); do
            (( allsites["$site"]++ ))
            [[ ! ${filesite["$site"]} ]] && filesite["$site"]="$file"
      done
done

if [[ ${sites[@]} && ${sites[0]} != "all" ]] ; then
     tmp_sites=("${sites[@]}")
     unset -v sites ; declare -A sites
     for site in "${tmp_sites[@]}"; do
          (( sites["$site"]++ ))
     done
     unset -v 'tmp_sites'
else
     unset -v 'sites'
     declare -A sites

     for site in "${!allsites[@]}" ; do 
          if [[ ! $site =~ $regex ]] ; then
              (( sites["$site"]++ ))
          fi
     done
fi

SECONDS=
tmp_sites=("${!sites[@]}")
domains=(
     $(xargs -n1 -P"${max_curl_procs}" /bin/bash -c 'read -r line < <(curl -s --connect-timeout "$curl_contimeout" --max-time "$curl_maxtime" -H"Host: ${0%%./*}" "http://$0" 2>/dev/null)
             shopt -s extglob
	     host=${line%%@( |<|>|-)*}
	     if [[ $src_environment = "${host#*.}" ]] ; then
                  echo "${0%%./*}"
	     fi' <<<"${tmp_sites[@]/%/./${uripath#/}}" & banner "Scanning for sites in environment <$src_environment> using <$uripath>" >&6)
)
seconds=$SECONDS
if (( seconds < 60 )); then
     min=0
elif (( seconds >= 60 )); then
       min=$(( seconds / 60 ))
       seconds=$(( seconds % 60 ))
fi
printf "scan time %s minutes %s seconds.\n" "$min" "$seconds"

sedversion=($(sed --version  | awk  '{gsub(/\./," ",$NF);print $NF ; exit}'))

case ${sedversion[0]} in
          [3210]*)
                  emptypattern='s/.*//'
                  ;;
                4)
                  if (( sedversion[1] == 1 )) ; then
                       emptypattern='s/.*//'
                  elif (( sedversion[1] >= 2 )) ; then
                         emptypattern='z'
                  fi
	          ;;
                *)
                  emptypattern='z'
	          ;;
esac

for domain in "${domains[@]}" ; do
      docroot="$(sed -nr '\%^[[:blank:]]*<VirtualHost[[:blank:]]+.+>($|[[:blank:]]+)%,\%^[[:blank:]]*</VirtualHost[[:blank:]]*>($|[[:blank:]]+)%{
                    /^[[:blank:]]*Server(Name|Alias)([[:blank:]]+|[[:blank:]]+([^[:blank:]]+[[:blank:]]+)+)'"$domain"'([[:blank:]]|$)/b docroot
                    s/^[[:blank:]]*DocumentRoot[[:blank:]]+(.+)$/\1/; t serverna
                    b 

                    : docroot
                    n
		    \%^[[:blank:]]*</VirtualHost[[:blank:]]*>($|[[:blank:]]+)% b
                    s/^[[:blank:]]*DocumentRoot[[:blank:]]+(.+)$/\1/p;t quit
                    b docroot

		    : serverna
		    h

		    : loop1
                    n
		    \%^[[:blank:]]*</VirtualHost[[:blank:]]*>($|[[:blank:]]+)%{'"$emptypattern"';h; b}
                    /^[[:blank:]]*Server(Name|Alias)([[:blank:]]+|[[:blank:]]+([^[:blank:]]+[[:blank:]]+)+)'"$domain"'([[:blank:]]|$)/{g;p;Q}
		    b loop1

		    : quit
		    Q }' "${filesite["$domain"]}")"
      if [[ $docroot ]] ; then 
           DocumentRoot["$domain"]="$docroot"
      fi
      if [[ ! ${DocumentRoot["$domain"]} ]] ; then
           missing+=("$domain")
      fi
done

if [[ ${missing[@]} ]] ; then
     printf "Unable to find DocumentRoot for <%s>\n" "${missing[@]}"
     exit 1
fi

for site in ${!DocumentRoot[@]}; do
          if [[ -f "${DocumentRoot[$site]}/wp-config.php" ]] ; then
                if tmpvar="$(sed -nr "/^[[:blank:]]*define\([[:blank:]]*'DB_NAME'[[:blank:]]*,[[:blank:]]*'.+'[[:blank:]]*\);/{s/\r//;p;q0};\$q1"\
					 "${DocumentRoot[$site]}/wp-config.php" 2>/dev/null)" ; then
			checksum=$(sed 's/\r//' "${DocumentRoot[$site]}/wp-config.php"|sha512sum|cut -d' ' -f1)
                        if [[ $checksum ]]; then
			     name[$site]=$tmpvar
			     csum[$checksum]+="$site,"
			     type[$site]="WP"
			     ((wp++))
                        else
                             exit 1
			fi
		else
	                echo "Unable to determine site type <$site> skipping."

		fi
          elif [[ -f "${DocumentRoot[$site]}/../config/controllers.php" ]] ; then
                if tmpvar="$(sed -nr "/^[[:blank:]]*SysReg::set\([[:blank:]]*'config.siteName'[[:blank:]]*,[[:blank:]]*'.+'[[:blank:]]*\);/{s/\r//;p;q0};\$q1"\
					 "${DocumentRoot[$site]}/../config/credentials.php" 2>/dev/null)"; then

			checksum=$(sed 's/\r//' "${DocumentRoot[$site]}/../config/credentials.php"|sha512sum|cut -d' ' -f1)
                        if [[ $checksum ]]; then
			     name[$site]=$tmpvar
			     csum[$checksum]+="$site,"
			     type[$site]="SPWL"
			     ((spwl++))
                        else
                             exit 1
			fi
		else
	                echo "Unable to determine site type <$site> skipping."
		fi
          elif [[ -f "${DocumentRoot[$site]}/../config/useSPOT2.txt" ]] ; then
                if tmpvar="$(sed -nr "/^[[:blank:]]*SysReg::set\([[:blank:]]*'config.siteName'[[:blank:]]*,[[:blank:]]*'.+'[[:blank:]]*\);/{s/\r//;p;q0};\$q1"\
					"${DocumentRoot[$site]}/../config/credentials.php" 2>/dev/null)" ; then
			checksum=$(sed 's/\r//' "${DocumentRoot[$site]}/../config/credentials.php"|sha512sum|cut -d' ' -f1)
                 	if [[ $checksum ]]; then
			     name[$site]=$tmpvar
			     csum[$checksum]+="$site,"
			     type[$site]="PLAT"
			     ((plat++))
                        else
                             exit 1
			fi

		else
			echo "Unable to determine site type <$site> skipping."
		fi
			
          else
		echo "Unable to determine site type <$site> skipping."
	  fi
done

if (( ${#type[@]} && ${#name[@]} )) ; then
     declare -p type name csum>"$filename"
else
     printf "%s\n" 'associative arrays <type> and <name> are empty.' 'was <src_environment> set?'
     exit 1
fi

declare -p wp spwl plat 2>/dev/null >>"$filename" 
chmod 600 "$filename" && chown "$loguser" "$filename"
printf "%s\n" "wordpress $((wp))" "newplatform $((plat))" "oldplatform $((spwl))"

exec 6>&-