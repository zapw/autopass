
setvar="IFS=\$'\n' read -d '' -r"
centers_hostnames=("web1")

umask 0022

banner () {
 if (( $# > 1 )); then
      norefresh=1
      shift
 else
      printf "%${COLUMNS:-80}s\r" ""
 fi
 for element in "$@"; do
     (( stringnum += ${#element} ))
 done

 while kill -0 $! 2>/dev/null ; do
        for v in '|' '/' '-' '\' '|' '/' '-' '\' ; do
	     printf -vspace "%$((${COLUMNS:-80}-$((stringnum-2))))s" ""
             sleep 0.1 ; printf "$@ %s$space\r" "$v"
        done
 done
 [[ $norefresh ]] || printf "%${COLUMNS:-80}s\r" ""
}

bashversion () {
case $BASH_VERSION in 
	[123]*) 
          printf "%s\n" "Bash version $BASH_VERSION not supported, version 4>= required." "Prepend bash4 cookbook. Example: ./progname -r bash4 myothercookbook ..."
          exit 1
	  ;;
esac
}

iscenter () {
  printf -v centers "%s|" "${centers_hostnames[@]}"
  centers_regex="(${centers%|})(\>|\.)"
  if [[ $(hostname) =~ $centers_regex ]] ; then
       return 0
  else
       return 1
  fi
}

showcookbook() {
    if [[ $1 = "on" ]] ; then
         exec 1> >(sed "s/^/===${cookbook}::${recipefile}=== /" >&2) 2>&1
    elif [[ $1 = "off" ]] ; then
           exec 1>&4 2>&1
    fi
}

checkvars() {
    local i k unsetvars
    for i; do
	local -a 'keys=("${!'"$i"'[@]}")'
        if (( ${#keys[@]} == 0 )) ; then 
            unsetvars+=("$i")
	    continue
	fi

	k="${i/%/["\$key"]}"

        local key null=1
        for key in "${keys[@]}"; do
            if [[ ${!k:+_} ]] ; then
	        null=0
		break
	    fi
        done
        [[ $null != 0 ]] && unsetvars+=("$i")
    done
    if [[ "${unsetvars[@]}" ]] ; then
        printf -v format ' <%%s>%.s' "${unsetvars[@]}";
        printf "variables:$format are null or unset\n" "${unsetvars[@]}"
        exit 1
    fi
}

inarray() {
 local n=$1 h
 shift
 for h; do
   [[ $n = "$h" ]] && return
 done
 return 1
}

#check centos/redhat release ver
if [[ -f /etc/redhat-release ]] ; then
   os_rel="redhat"
   os_relver=($(rpm -qf /etc/redhat-release | sed -r -n 'h;s/.+\.el([0-9]+)\..+/\1/p;x;s/^([^-]+).+/\1/p'))
fi

package_exist() {
  if [[ $os_rel == "redhat" ]] ; then
      rpm -q "${@}" 2>/dev/null | awk '/not installed/ { printf ("%s ", $2); missing=1 } END { if (missing == 1) exit 1  }' || return 1
  fi
  return 0
}

package_install() {
  local packages
  packages=($(package_exist "$@")) && return 0
  [[ $os_rel == "redhat" ]] && yum install -y "${packages[@]}"
}

package_update() {
  if [[ $os_rel == "redhat" ]] ; then
      yum -y update "$@"
  fi
}

install_pkg() {
  local pkg bin binary
  for bin; do
      [[ ! -x "$bin" ]] && binaries+=("$bin")
  done
  if ((${#binaries[@]})) ; then
       echo Installing missing binaries: "${binaries[@]}"
       if [[ -f /etc/redhat-release ]] ; then
            read -r -a pkg < <(yum -q provides "${binaries[@]}" | awk '/:?[^[:space:]]+ : / { if(lastLine == "") { sub(/[0-9]\:/, "" , $0 ) ; printf "%s ", $1 } } { lastLine = $0 }')
            ((${#pkg[@]})) && yum install -y "${pkg[@]%%-*}"
       fi
       if [[ -f /etc/debian_version ]] ; then
           apt-get install "${[@]##*/}"
       fi
  fi
}

service_name() {
  servicename="$1" 
  shift
  for action; do
        if [[ $os_rel == "redhat" ]] ; then
             if (( os_relver == 7 )) ; then
		  [[ $action == "on" ]] && action="enable" 
		  [[ $action == "off" ]] && action="disable" 
                  systemctl "$action" "$servicename"
	     elif (( os_relver < 7 )) ; then
		  if [[ $action == "enable" ]] ; then
		      chkconfig "$servicename" on
		      continue
		  elif [[ $action == "on" ]] ; then
		        chkconfig "$servicename" on
			continue
		  elif [[ $action == "off" ]] ; then
			chkconfig "$servicename" off
			continue
		  elif [[ $action == "disable" ]] ; then
			chkconfig "$servicename" off
			continue
		  fi
		  service "$servicename" "$action"
             fi
        fi
  done
}
