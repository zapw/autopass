#!/bin/bash
set -e

printf "\n%s" "Machine: $(hostname)'s memory: "
awk '$1 == "MemTotal:" { OFS=""; print int($2/1000000), "G"   }' </proc/meminfo
