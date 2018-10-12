#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# Template script
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# IFS stands for "internal field separator". It is used by the shell to determine how to do word splitting, i. e. how to recognize word boundaries.
SAVEIFS=$IFS
IFS=$(echo -en "\n\b") # <-- change this as it depends on your app

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# log4.sh inclusion
source log4.sh -v INFO -d "+%Y-%m-%d %H:%M:%S" #-f $__file.log

DEBUG "__dir  = "$__dir
DEBUG "__file = "$__file
DEBUG "__base = "$__base
DEBUG "__root = "$__root
DEBUG ""

_usage() {
    echo -e "usage: "
    echo -e "    ./readline.sh <filename> <linenumber>"
}

# --> Some script here

file=${1:-}
line=${2:-}

DEBUG "file= " $file
DEBUG "linen= " $line

if [ -z "$file" ] || [ -z "$line" ]; then
    _usage
    exit 1
fi

sed -n "${line}{p;q;}" $file
# sed -n '134647{p;q;}' catalina.out
# sed -n "1,100{p;}"

COUNTER=0
while [  $COUNTER -lt 10 ]; do
    echo The counter is $COUNTER
    let COUNTER=COUNTER+1 
done


# Restore IFS
IFS=$SAVEIFS
exit 0
