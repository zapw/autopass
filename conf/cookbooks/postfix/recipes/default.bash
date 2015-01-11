#!/bin/bash
set -e

postconf -e 'transport_maps=hash:/etc/postfix/transport'
postconf -e "mydomain=$mydomain" "myorigin=$myorigin"
postconf -e "relayhost=[$relayhost_external]"

echo "$transport_map" >/etc/postfix/transport
postmap /etc/postfix/transport

service_name postfix enable restart
