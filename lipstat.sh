#!/bin/bash

# The workstations-*.csv files list the hostnames and characteristics of the machines

echo "LIP Workstations"
cat workstations-lip.csv | grep -v '^#' | parallel -C ' ' 'printf "%4s" "$(./wsstat.sh {1})%" && echo "  "{}' | sort -n

echo
echo "Crunch Workstations"
cat workstations-crunch.csv | grep -v '^#' | parallel -C ' ' 'printf "%4s" "$(./wsstat.sh {1})%" && echo "  "{}' | sort -n
