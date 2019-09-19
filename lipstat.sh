#!/bin/bash

# Emulate GNU's `readlink -f` behaviour, in case we're on Darwin
# (https://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac)
TARGET_FILE=$0
INITIAL_PWD=$(pwd)
cd $(dirname $TARGET_FILE)
TARGET_FILE=$(basename $TARGET_FILE)
# Iterate down a (possible) chain of symlinks
max_links=1000
i=0
while [ -L "$TARGET_FILE" ]; do
  TARGET_FILE=$(readlink $TARGET_FILE)
  cd $(dirname $TARGET_FILE)
  TARGET_FILE=$(basename $TARGET_FILE)

  i=$(( $i + 1 ))
  if [ $i -gt $max_links ]; then
    echo "Error: too many links followed (> $max_links). Maybe you have a symlink cycle?"
    exit 1
  fi
done
# Compute the canonicalized name by finding the physical path
# for the directory we're in and appending the target file.
BASEDIR=$(pwd -P)

# We now have our real base directory, so move on to the actual work of getting nodes and their load
NODES=$BASEDIR/nodes.sh
NODESTAT=$BASEDIR/nodestat.sh

print_nodes_stat () {
  header="%User|%Nice|Mem (Free)|Mem (Cache)|Local Disk (Free)|$($NODES --header $1)"
  $NODES $1 \
    | parallel -j0 "echo \$($NODESTAT {= s/\|.*//g =} $2)\"|\"{}" \
    | sed 's/^|/-|-|-|-|-|/g' \
    | sort -t '|' -k 1n,2n \
    | echo -e "$header\n$(cat -)" \
    | column -t -s '|'
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
