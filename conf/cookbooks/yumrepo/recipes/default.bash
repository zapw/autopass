#!/bin/env bash
bashversion

machine="$(uname -m)"
if [[ $machine != "x86_64" ]] ; then
     machine="i386"
fi

declare -A repo
if (( os_relver == 7 )) && [[ $machine != "x86_64" ]] ; then
    echo "machine is $machine, not supported for RHEL7"
    exit 1
fi

if [[ ${os_relver[1]} == "redhat" ]] ; then
     distro="Redhat"
else
     distro="CentOS"

fi

package_install yum-plugin-protectbase

repo=([epel]="http://dl.fedoraproject.org/pub/epel/$os_relver/$machine/repoview/epel-release.html")
repo+=([ius]="http://dl.iuscommunity.org/pub/ius/stable/$distro/$os_relver/$machine/repoview/ius-release.html")

for reponame in epel ius; do 
    curl -s "${repo["$reponame"]}" | sed -n -r  "s/.*href=\"(.*${reponame}-release.*.rpm)\".*/\1/p" | 
    while read -r file ; do 
       if [[ $file = http* ]] ; then
	   rpm -hUv "$file" 
       else
	   rpm -hUv "${repo["$reponame"]%/*.html}/${file}"
       fi
     done
     if sed -n "/\[$reponame]/,/^$/{ /protect=/q 1; }" "/etc/yum.repos.d/$reponame.repo"  ; then
         printf "%s\n" "/\[$reponame]/" '/enabled=/' 'a' 'protect=0' '.' 'w' | ed -s "/etc/yum.repos.d/$reponame.repo" >/dev/null
     else
         printf "%s\n" "/\[$reponame]/,/^$/s/protect=.*/protect=0/" | ed -s "/etc/yum.repos.d/$reponame.repo" >/dev/null
     fi
done
