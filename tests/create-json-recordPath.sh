#!/bin/bash

# =============================== ENVIRONMENT ================================ #

if [[ ${1} ]]; then
  cmd="${1}"
else
  echo 1>&2 "execute tests-cli.sh to run all tests"; exit 1
fi

t="$(basename "${BASH_SOURCE[0]}" .sh)"
cd "${BASH_SOURCE%/*}/" || exit 1
mkdir -p "tmp/${t}"

# =================================== DATA =================================== #

cat << "DATA" > "tmp/${t}/${t}.json"
{
   "rows":[
      {
         "a":1,
         "b":2,
         "c":3
      },
      {
         "a":0,
         "b":0,
         "c":0
      },
      {
         "a":"$",
         "b":"\\",
         "c":"\""
      }
   ]
}
DATA

# ================================= ASSERTION ================================ #

cat << "DATA" > "tmp/${t}/${t}.assert"
_ - a	_ - b	_ - c
1	2	3
0	0	0
$	\	""""
DATA

# ================================== ACTION ================================== #

${cmd} --create "tmp/${t}/${t}.json" --recordPath "_" --recordPath "rows" --recordPath "_"
${cmd} --export "${t}" --output "tmp/${t}/${t}.output"

# =================================== TEST =================================== #

diff -u "tmp/${t}/${t}.assert" "tmp/${t}/${t}.output"
