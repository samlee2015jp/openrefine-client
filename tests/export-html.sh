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

cat << "DATA" > "tmp/${t}/${t}.csv"
a,b,c
1,2,3
0,0,0
$,\,'
DATA

# ================================= ASSERTION ================================ #

cat << "DATA" > "tmp/${t}/${t}.assert"
<html>
<head>
<title>export-html</title>
<meta charset="utf-8" />
</head>
<body>
<table>
<tr><th>a</th><th>b</th><th>c</th></tr>
<tr><td>1</td><td>2</td><td>3</td></tr>
<tr><td>0</td><td>0</td><td>0</td></tr>
<tr><td>$</td><td>\</td><td>&apos;</td></tr>
</table>
</body>
</html>
DATA

# ================================== ACTION ================================== #

${cmd} --create "tmp/${t}/${t}.csv"
${cmd} --export "${t}" --output "tmp/${t}/${t}.html"

# =================================== TEST =================================== #

diff -u "tmp/${t}/${t}.assert" "tmp/${t}/${t}.html"
