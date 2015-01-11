#!/bin/bash
set -e

bashversion
basedir="${basedir%/}"
apachegroup="$apacheuser"
sites="$basedir/${companyname,,}"
sys="$basedir/${companyprefix,,}sys"
crm="$basedir/crm"
devuser_dirs=("$sys")
apacheuser_dirs=("$crm" "$sites" "$sys")

for dir in "${devuser_dirs[@]}" "${apacheuser_dirs[@]}" ; do 
    [[ ! -d "$dir" ]] && mkdir -p "$dir"
done
shopt -s extglob
#if [[ -d "$media_uploads" && iscenter ]] ; then
#    apacheuser_dirs+=("$media_uploads")
#fi

declare -A userarr=(["apacheuser"]="$apacheuser" ["devuser"]="$devuser")

for usertype in "${!userarr[@]}" ; do
     if getent passwd "${userarr["$usertype"]}" >/dev/null ; then
         usertexists+=("$usertype")
     fi
done

acl () {
 local i dir
 while (( $# )) ; do
       case "$1" in
	   apacheuser_dirs)
		for dir in "${apacheuser_dirs[@]}" ; do
		      find "$dir" -type d -exec setfacl -m u:"$apacheuser":rwx -m g:"$apachegroup":rwx {} +
      		      find "$dir" -type d -exec setfacl -d -m u:"$apacheuser":rwx -m g:"$apachegroup":rwx {} +
		done
		;;
	    devuser_dirs)
		for dir in "${devuser_dirs[@]}" ; do
      			find "$dir" -type d -exec setfacl -m u:"$devuser":rwx {} +
      			find "$dir" -type d -exec setfacl -d -m u:"$devuser":rwx {} +
		done
		;;
		*)
		:
	esac
	shift
  done
}

if inarray "apacheuser" "${usertexists[@]}" && inarray "devuser" "${usertexists[@]}"; then
      printf -v format "<%%s> %.s" "${apacheuser_dirs[@]}"
      printf -v format1 "<%%s> %.s" "${devuser_dirs[@]}"
      printf "%s %s\n" "Found apacheuser '$apacheuser' and devuser '$devuser'" "Chaning folders permissions:"        
      printf "%s $format\n" "$apacheuser - " "${apacheuser_dirs[@]}"
      printf "%s $format1\n" "$devuser - " "${devuser_dirs[@]}"
      acl apacheuser_dirs devuser_dirs
      
elif inarray "apacheuser" "${usertexists[@]}" ; then
      printf -v format "<%%s> %.s" "${apacheuser_dirs[@]}"
      printf "%s %s\n%s $format\n" "Found apacheuser '$apacheuser'" "Chaning folders permissions:" "$apacheuser - " "${apacheuser_dirs[@]}"
      acl apacheuser_dirs
      
elif inarray "devuser" "${usertexists[@]}"; then
      printf -v format "<%%s> %.s" "${devuser_dirs[@]}"
      printf "%s %s\n%s $format\n" "Found devuser '$devuser'" "Chaning folders permissions:" "$devuser - " "${devuser_dirs[@]}"
      acl devuser_dirs
fi
