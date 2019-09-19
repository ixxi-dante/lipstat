#!/bin/bash
# Don't tolerate errors
set -e

usage="Usage: $(basename $0) [--header] TABLE_ID"
nodes_url="http://intralip.lip.ens-lyon.fr/services/node_spec.html"

print_table_as_csv () {
  echo $1 \
    | sed -e "s/ *<\/t[dh]>[^<]*<t[dh][^>]*> */|/g" \
    | sed -e "s/ *<\/t[dh]>[^<]*<t[dh][^>]*> */|/g" \
    | sed -e "s/ *<\/t[dh]>[^<]*<\/tr>[^<]*<tr[^>]*>[^<]*<t[dh][^>]*> */\n/g" \
    | sed -e 's/ *<tr[^>]*>[^<]*<t[dh][^>]*> *//g' \
    | sed -e 's/ *<\/t[dh]>[^<]*<\/tr> *//' \
    | sed -e 's/[\t ]\+/ /g'
}

get_nodes () {
  nodes=$(curl -Ss "$nodes_url" | xmllint --html --xpath "//h2[@id=\"$1\"]/following-sibling::table[1]/tbody/tr" -)
  print_table_as_csv "$nodes"
}

get_header () {
  header=$(curl -Ss "$nodes_url" | xmllint --html --xpath "//h2[@id=\"$1\"]/following-sibling::table[1]/thead/tr" -)
  print_table_as_csv "$header"
}

if [ $# -eq 1 ]; then
  table=$1
  get_nodes $table

elif [ $# -eq 2 ]; then
  if [ $1 != "--header" ]; then
    echo "$usage"
    exit 1
  fi

  table=$2
  get_header $table

else
  echo "$usage"
  exit 1
fi
