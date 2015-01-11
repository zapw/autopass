#!/bin/bash

linenum="$(iptables -L RH-Firewall-1-INPUT -n --line-num  | awk '/state RELATED,ESTABLISHED/{ if ( $1 ~ /^[[:digit:]]+$/ ) print ++$1 ; exit}')"
if [[ $linenum ]] ; then
     for ip in "${ips[@]}"; do
          { iptables -D RH-Firewall-1-INPUT -m state --state NEW -p tcp --src "$ip" --dport "$smtpport" -j ACCEPT || iptables -D RH-Firewall-1-INPUT -p tcp --src "$ip" --dport "$smtpport" -m state --state NEW  -j ACCEPT ;} 2>/dev/null
          iptables -I RH-Firewall-1-INPUT "$linenum" -p tcp --src "$ip" -m state --state NEW --dport "$smtpport" -j ACCEPT
     done
     service iptables save
fi
