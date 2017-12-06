# LIP Stat

Tell me what machines at the LIP are not being used too much.

Make sure you can log in to all the LIP workstations and Crunch machines with your ssh public key (password authentication is prevented in these scripts).

Dependencies:
* [GNU Parallel](https://www.gnu.org/software/parallel/)
* Perl
* cURL

Usage: 
```
./nodestat.sh <machine>  # To get a single machine's load
./lipstat.sh             # To sort all machines by their load
```
