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
# Non compatibile con la verifica delle opzioni passate come argomento
# set -o errexit 
# # Exit on error inside any functions or subshells.
set -o errtrace
# # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} )"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# log4.sh inclusion
source log4.sh -v INFO

DEBUG "__dir  = "$__dir
DEBUG "__file = "$__file
DEBUG "__base = "$__base
DEBUG "__root = "$__root

# Add single torrent (file/magnet link) to trasmission-remote
# Parameter
#  $1: file torrent or magnet link
function _add() {
    # transmission-remote -n 'pi:raspberry' -a $1
    echo "add"
}

# Parameter $1 directory to scan
function _add_dir() {
    if [[ ! -d $1 ]]; then
        echo "argh not a directory!" 
        exit 1
    fi

    if [ -z "$(ls -A $TORRENT_PATH | grep *.torrent)" ]; then
        WARN "Directory is empty. Nothing to add."
            exit 1
        fi
}

function main() {
    # IFS stands for "internal field separator". It is used by the shell to determine how to do word splitting, i. e. how to recognize word boundaries.
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")

    INFO "Remember to launch this script as sudo!"

    for f in $TORRENT_PATH/*.torrent; do
        # take action on each file. $f store current file name
        INFO "Adding $f ..."

        _add $f
        if [ $? -eq 0 ]; then
            DEBUG "Delete $f ..."
            #    rm $f
        else
            ERROR "Error on $f ..."
        fi
    done
    # restore IFS
    IFS=$SAVEIFS
}

function usage() {
    echo "usage!"
}

function version() {
    echo -e "$(basename $0) v$VERSION" 
    echo -e "Automate add torrent to trasmission-remote on DietPi"
    echo -e "Copyright (c) Marco Lovazzano"
    echo -e "Licensed under the GNU General Public License v3.0"
    echo -e "http://github.com/martcus"
}

# Check parameter
if [[ ! $@ =~ ^\-.+ ]]; then
    echo "parametri insufficenti"
    usage
fi

OPTS=$(getopt -o hd:f:b: --long "help,version,dir:,file:,backup:"  -n $APPNAME -- "$@")

#directory, file singolo

#Bad arguments, something has gone wrong with the getopt command.
if [ $? -ne 0 ]; then
    #Option not allowed
    echo -e "Error: '$0' invalid option '$1'."
    echo -e "Try '$0 -h' for more information."
    exit 1
fi

# A little magic, necessary when using getopt.
eval set -- "$OPTS"

while true; do
    case "$1" in
        -h|--help)
            usage
            exit 0;;
        --version)
            version
            exit 0;;
        -d|--dir)
            TORRENT_PATH="$2"
            shift 2;;
        -f|--file)
            DEBUG "Opt for future release"
            shift 2;;
        -b|--backup)
            DEBUG "Opt for future release"
            shift 2;;
        --)
            shift
            break;;
    esac
done

# check valid opt
# if dir call add_dir
if [ ! -z "$TORRENT_PATH" ]; then
    _add_dir "$TORRENT_PATH"
fi
