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
LIPSTAT_CACHE=${XDG_CACHE_HOME:-$HOME/.cache}/lipstat
mkdir -p $LIPSTAT_CACHE
KNOWN_HOSTS=$LIPSTAT_CACHE/known_hosts

# Check we already have the host's keys, otherwise store it locally
# This is okay as we're only doing key-based authentication (no passwords to
# be snooped), and only running vmstat on the host machines, so a MITM has
# no real risk
if [ ! -f $KNOWN_HOSTS ] || ! grep -q "^$machine_fqdn" $KNOWN_HOSTS; then
  ssh-keyscan -t rsa,dsa $machine_fqdn 2>/dev/null >> $KNOWN_HOSTS
fi

ssh \
  -o PasswordAuthentication=False \
  -o UserKnownHostsFile=$KNOWN_HOSTS \
  -o ConnectTimeout=10 \
  $machine_fqdn \
  "echo \$(sar -u $delay 1 | tail -1 | awk '{printf \"%d%%|%d%%\", \$3, \$4}')\|\$(sar -r 1 1 | tail -1 | awk '{printf  \"%.2fG|%.2fG\", \$2/1048576, \$6/1048576}')\|\$(df -h | grep -F /local | awk '{print \$4}')" \
  2>/dev/null
