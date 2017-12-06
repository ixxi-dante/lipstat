# LIP Stat

Tells you which nodes at the LIP are not being used too much.
Make sure:
* You have access to the LIP intranet (used to get the node specs), usually using the VPN
* You can log in to all the LIP workstations and Crunch machines with your ssh public key (password authentication is prevented in these scripts).

Dependencies:
* [cURL](https://curl.haxx.se/) for getting the node specs from the intranet
* [Perl](https://www.perl.org/) and [xmllint](http://xmlsoft.org/xmllint.html) to parse the specs
* [GNU Parallel](https://www.gnu.org/software/parallel/) to run the ssh connections in parallel

Usage: 
```
./nodestat.sh <machine>  # To get a single node's load
./lipstat.sh             # To sort all nodes by their load
```

The fingerprints of the nodes' ssh keys will be scanned and stored locally in `./known_hosts`, so that you're not asked to confirm them when these scripts log in to a node for the first time.
