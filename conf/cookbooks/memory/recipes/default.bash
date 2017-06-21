#!/bin/bash
set -e

printf "\n%s" "Machine: $(hostname)'s memory: "
awk '$1 == "MemTotal:" { OFS=""; num=int($2/1000000); if (num % 2 != 0) num-- ; print num, "G", "\n" }' </proc/meminfo
