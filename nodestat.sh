#!/bin/bash -e

# Check arguments
if [ $# -eq 1 ]; then
  delay=5
elif [ $# -eq 2 ]; then
  delay=$2
else
  echo "Usage: $(basename $0) <machine-name> [DELAY_SECONDS=5]"
  exit 1
fi
machine=$1
machine_fqdn=$machine.lip.ens-lyon.fr

# Check we already have the host's keys, otherwise store it locally
# This is okay as we're only doing key-based authentication (no passwords to
# be snooped), and only running vmstat on the host machines, so a MITM has
# no real risk
if [ ! -f known_hosts ] || ! grep -q "^$machine_fqdn" known_hosts; then
  ssh-keyscan -t rsa,dsa $machine_fqdn 2>/dev/null >> known_hosts
fi

# vmstat <delay> <number-of-iterations>
# adjust to make the runtime shorter but the result less accurate
# $15 = idle cpu
# $4 = free memory
# $6 = cache memory
ssh \
  -o PasswordAuthentication=False \
  -o UserKnownHostsFile=./known_hosts \
  $machine_fqdn \
  "echo \$(vmstat -S M $delay 2 | tail -1 | awk '{printf \"%d%%|%.2fG|%.2fG\", 100-\$15, \$4/1024, \$6/1024}')\"|\"\$(df -h | grep -F /local | awk '{print \$4}')" \
  2>/dev/null
