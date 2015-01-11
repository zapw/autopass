#!/bin/bash
. "$envdir/postconnect.bash"
shopt -s extglob

exec 6>&1
declare -A domainsitename domainsvnpath umatchedsum prev_platform new_platform wordpress replicenter=([integration]="" [qa]="")
platform_xpath="/lists/list/entry[@kind='dir']/name/text()"
wordpress_xpath="/lists/list/entry[@kind='dir']/name[starts-with(text(),'WP-') or starts-with(text(),'WP_')]/text()"

printf -vfilesrc %q "$filename"
ssh -o ControlPath="$tmpdir/$server-$port-$user" -o CheckHostIP=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$server" "cat $filesrc;rm $filesrc" >"$tmpdir/$filesrc"
source "$tmpdir/$filesrc"

pltchksumfile=${pltchksumfile#/}
wpchksumfile=${wpchksumfile#/}

svnurl=${svnurl%%+(/)}
new_platpath=${new_platpath%%+(/)}
new_platpath=${new_platpath##+(/)}

prev_platpath="${prev_platpath%%+(/)}"
prev_platpath="${prev_platpath##+(/)}"

wordpresspath="${wordpresspath##+(/)}"
wordpresspath="${wordpresspath%%+(/)}"

new_platpath_trunk=${new_platpath_trunk%%+(/)}
new_platpath_trunk=${new_platpath_trunk##+(/)}

prev_platpath_trunk="${prev_platpath_trunk%%+(/)}"
prev_platpath_trunk="${prev_platpath_trunk##+(/)}"


listsvndir () {
     (( $# == 2 )) || return 1

     if [[ $2 = @(prev_platform|new_platform) ]]; then 
          xpath="$platform_xpath"
          filepath=$pltchksumfile
     elif [[ $2 = "wordpress" ]]; then
            xpath="$wordpress_xpath"
  	    filepath=$wpchksumfile
     fi
     svn --no-auth-cache --username "$svnusername" --password "$svnpassword" --xml list "${svnurl}/$1" >"$2" || exit 1
     while read -r var; do 
            index="${var,,}" value="${svnurl}/$1/$var/$filepath" eval "$2"'["$index"]=$value'
     done < <(echo "cat $xpath" | xmllint --shell "$2" | sed -rn 'N;s/.+\n//;p')
     rm "$2"
}

svncat () {
    sitename=$(awk -F\' '{print $4}' <<<"${name[$domain]}")
    sitename=${sitename,,}
    if [[ $1 == "wordpress" ]]; then
	 sitename="${sitename/wordpress_/wp-}"
    fi
    uri=$(index="$sitename" eval 'echo ${'"$1"'["$index"]''}')
    if [[ $uri ]]; then
         IFS= read -d '' -r file < <(curl -s -u "$svnusername:$svnpassword" "$uri"|sed 's/\r//')
	 if [[ $file ]]; then
	      if [[ $(printf %s "$file" | sha512sum |cut -d' ' -f1) = "$checksum" ]]; then
                   domainsvnpath[$uri]=${csum[$checksum]%,}
		   unset -v 'csum[$checksum]' "$1"'[$sitename]'
              else
                   [[ $1 == new_platform ]] && umatchedsum[$checksum]="PLAT"
                   [[ $1 == prev_platform ]] && umatchedsum[$checksum]="SPWL"
                   [[ $1 == wordpress ]] && umatchedsum[$checksum]="WP"
	      fi
	 else
 	       printf "Error skipping %s unable to read <%s>\n" "${csum[$checksum]%,}" "$uri"
               continue
         fi
    else
         [[ $1 == new_platform ]] && umatchedsum[$checksum]="PLAT"
         [[ $1 == prev_platform ]] && umatchedsum[$checksum]="SPWL"
         [[ $1 == wordpress ]] && umatchedsum[$checksum]="WP"
    fi
}

searchsite () {
 unset -v 'uri'
 uri=$(
 curl -s -u "$svnusername:$svnpassword" -w"\n%{url_effective}\n" "$@" |
 sed -rn '
    : loop
    s/\r//
    N
    s/\r//
    t x
    : x
    s#^(.+)\n('"$svnurl"'.+)#if [[ $( head -c -1 <<"EOF" | sha512sum | cut -d" " -f1\n\1\nEOF\n) = "$key" ]]; then echo match \2; else echo nomatch;fi#e
    t output
    b loop
    : output
    s/nomatch//;t nomatch
    s/match (.+)/\1/p;Q
    : nomatch
    n
    b loop' &
    banner norefresh "Scanning keytype <${umatchedsum[$key]}> in $# directories. Total keys left ${#umatchedsum[@]} " 1>&6)

 if [[ $uri ]]; then 
      domainsvnpath[$uri]=${csum[$key]%,}
      unset -v 'umatchedsum[$key]'
 fi
}

resolve_umatchedsum () {
 for key in "${!umatchedsum[@]}"; do
     case ${umatchedsum[$key]} in
         PLAT) 
              searchsite "${new_platform[@]}" 
	      if [[ $uri ]]; then 
	           uri=${uri#${svnurl}/${new_platpath}/}
                   uri=${uri%/${pltchksumfile}}
		   uri=${uri,,}
      		   unset -v 'new_platform[$uri]'
              fi
	      ;;
	 SPWL)
              searchsite "${prev_platform[@]}"
	      if [[ $uri ]]; then 
	           uri=${uri#${svnurl}/${prev_platpath}/}
                   uri=${uri%/${pltchksumfile}}
		   uri=${uri,,}
      		   unset -v 'prev_platform[$uri]'
              fi
              ;;
	   WP)
              searchsite "${wordpress[@]}"
	      if [[ $uri ]]; then 
	           uri=${uri#${svnurl}/${wordpresspath}/}
                   uri=${uri%/${wpchksumfile}}
		   uri=${uri,,}
      		   unset -v 'wordpress[$uri]'
              fi
              ;;
     esac
 done
}

if [[ $plat ]]; then
     types+=(plat)
     listsvndir "$new_platpath" new_platform
fi
if [[ $spwl ]]; then
     types+=(spwl)
     listsvndir "$prev_platpath" prev_platform
fi
if [[ $wp ]]; then
     types+=(wp)
     listsvndir "$wordpresspath" wordpress
fi

printf "\n"
printf "%s\n" "Scanning SVN paths:" "new platforms ${#new_platform[@]}"\
	 "prev platforms (oldplatform) ${#prev_platform[@]}" "wordpress ${#wordpress[@]}"

printf "%s\n" "Phase one: trying one to one mapping sitename vs svndirname"
for checksum in "${!csum[@]}"; do
     domain=${csum[$checksum]%%,*}
     if [[ ${type[$domain]} = "PLAT" ]]; then
          svncat new_platform
     elif [[ ${type[$domain]} = "SPWL" ]]; then
	    svncat prev_platform
     elif [[ ${type[$domain]} = "WP" ]]; then
	    svncat wordpress
     else
          for x in ${csum[$checksum]//,/ };do
              echo "Site type <${type[$x]}> for domain <$x> unknown."
          done
          exit 1
     fi
done

if (( "${#umatchedsum[@]}" )); then
     printf "%s\n" "Phase two: scanning ${types[*]/%/,} branches for all remaining sites"
fi
export key
resolve_umatchedsum

if (( "${#umatchedsum[@]}" )) && [[ $plat || $spwl ]]; then
     printf "%s\n" "Phase three: scanning plat and spwl trunk directories for all remaining sites"
     new_platform=() prev_platform=()
     new_platform[trunk]="${svnurl}/${new_platpath_trunk}/$pltchksumfile"
     prev_platform[trunk]="${svnurl}/${prev_platpath_trunk}/$pltchksumfile"
     resolve_umatchedsum
fi

printf "%${COLUMNS:-80}s\r\n"
for key in "${!domainsvnpath[@]}"; do
    printf "%s\n" "domain:path <${domainsvnpath[$key]}>:<${key%@(${pltchksumfile}|${wpchksumfile})}>"
done
printf "\n"

if [[ ${umatchedsum[@]} ]]; then
     for key in "${!umatchedsum[@]}"; do
           printf "No svnpath matching Production found for <%s> type <%s>\n" "${csum[$key]%,}" "${umatchedsum[$key]}"
     done
fi

rootdomainregex="^([^.]+\.)*([^.]+\.[^.]+)$"
#for key in "${!domainsvnpath[@]}"; do
#    tag=${domainsvnpath[$key]%%,*}
#    [[ $tag = $rootdomainregex ]] && rootdomain=${BASH_REMATCH[2]}
    #r1 submit -center="${replicenter[integration]}" -center_user="$repliwebuser" @<(printf -vpass %q "$repliwebpassword" ;printf %s "-center_password=$pass") -type=distribution -source_directory= -notree_recurse -target_directory= -name= -tags=\"tag1, tag2\\sub_tag2, tag3.sub_tag3, . . .\"
#    printf "%s\n" "domain:path <${domainsvnpath[$key]}>:<$key>"
#done
#printf "\n"
