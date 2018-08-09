#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# Automate add torrent to trasmission-remote on DietPi
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
APPNAME="addTorrent"
VERSION="1.0.0"

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

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} )"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# log4.sh inclusion
source ../../log4sh/script/log4.sh -v INFO

DEBUG "__dir  = "$__dir
DEBUG "__file = "$__file
DEBUG "__base = "$__base
DEBUG "__root = "$__root

TORRENT_PATH="$1"

# IFS stands for "internal field separator". It is used by the shell to determine how to do word splitting, i. e. how to recognize word boundaries.
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

INFO "Remember to launch this script as sudo!"

if [ -z "$(ls -A $TORRENT_PATH | grep *.torrent)" ]; then
    WARN "Directory is empty. Nothing to add."
    exit 1
fi

for f in $TORRENT_PATH/*.torrent; do
  # take action on each file. $f store current file name
  INFO "Adding $f ..." 
  
  #transmission-remote -n 'pi:raspberry' -a $f | INFO
  if [ $? -eq 0 ]; then
    DEBUG "Delete $f ..."
#    rm $f
  else
    ERROR "Error on $f ..."
  fi
done

# restore IFS
IFS=$SAVEIFS
exit 0
