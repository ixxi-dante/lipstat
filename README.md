# LIP Stat

Tells you which nodes at the LIP are not being used too much.

## How to use

Make sure that:
* You have access to the LIP intranet (used to get the node specs), usually using the VPN
* You can log in to all the LIP workstations and Crunch machines with your ssh public key (password authentication is prevented in these scripts).

Dependencies:
* [cURL](https://curl.haxx.se/) for getting the node specs from the intranet
* [Perl](https://www.perl.org/) and [xmllint](http://xmlsoft.org/xmllint.html) to parse the specs
* [GNU Parallel](https://www.gnu.org/software/parallel/) to run the ssh connections in parallel

Usage: 
```
./lipstat.sh  # Sorts all nodes by their usage and pretty prints various load statistics
```

The script will report the following fields for each machine:
* `%User`: percentage CPU load (normal priority user processes, with which your own processes compete)
* `%Nice`: percentage CPU load (only low-priority user processes, over which your own processes will have priority unless otherwise configured)
* `Mem (Free)`: amount of free RAM (directly available to your processes)
* `Mem (Cache)`: amount of RAM used for cache (and which can potentially be released for your processes)
* `Local Disk (Free)`: amount of free disk space in `/local` (machine's local storage)
* `Name`: machine name
* `CPU`: CPU type
* `Total Cores`: total number of cores on the machine
* `Memory (GB)`: total RAM
* `System type`: usually the brand and model of the machine

The first five are gathered over 5 seconds on the machines, the last 5 come from the LIP intranet. The list is ordered by `%User` first, and `%Nice` second.

You can also use `./nodestat.sh <machine>` the get the (unformatted) load information of a single machine.
Note that the fingerprints of the nodes' ssh keys will be scanned and stored locally in `./known_hosts`, so that you're not asked to confirm them when these scripts log in to a node for the first time.

## Problems?

The script doesn't work? You're using OS X and there are some utilities missing? Anything else? Please [open an issue](https://github.com/ixxi-dante/lipstat/issues/new) so we can fix the problem and improve the instructions!
