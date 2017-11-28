#!/bin/bash -e

if [ $# -ne 1 ]; then
  echo "Usage: $(basename $0) <machine-name>"
  exit 1
fi

machine=$1

# vmstat <delay> <number-of-iterations>
# adjust to make the runtime shorter but the result less accurate
ssh -o PasswordAuthentication=False $machine.lip.ens-lyon.fr 'echo $[100 - $(vmstat 5 2 | tail -1 | awk "{print \$15}")]'
