#!/bin/bash

print_nodes_stat () {
  header="%User,%Nice,Mem (Free),Mem (Cache),Local Disk (Free),$(./nodes.sh --header $1 | sed 's/|/,/g')"
  ./nodes.sh $1 \
    | parallel -j0 "echo \$(./nodestat.sh {= s/\|.*//g =} $2)\"|\"{}" \
    | sed 's/^|/-|-|-|-|-|/g' \
    | sort -t '|' -k 1n,2n \
    | column -t -s '|' -N "$header" -R "%User,%Nice,Mem (Free),Mem (Cache),Local Disk (Free)"
}

if [ $# -eq 0 ]; then
  delay=5
elif [ $# -eq 1 ]; then
  delay=$1
else
  echo "Usage: $(basename $0) [DELAY_SECONDS=5]"
  exit 1
fi

echo "Getting load over $delay second(s)..."
echo

echo "================"
echo "LIP Workstations"
echo "================"
echo
print_nodes_stat workstation $delay

echo
echo "==================="
echo "Crunch Workstations"
echo "==================="
echo
print_nodes_stat crunch $delay
