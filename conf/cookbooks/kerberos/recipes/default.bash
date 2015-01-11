#!/bin/bash
package_install krb5-libs

echo "$krb5_conf" >"/etc/krb5.conf"
