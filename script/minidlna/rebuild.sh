#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# Rebuild minidnla database on DietPi
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
APPNAME="rebuild"
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

# IFS stands for "internal field separator". It is used by the shell to determine how to do word splitting, i. e. how to recognize word boundaries.
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# log4.sh inclusion
source ../../log4sh/script/log4.sh -v INFO

DEBUG "__dir  = "$__dir
DEBUG "__file = "$__file
DEBUG "__base = "$__base
DEBUG "__root = "$__root

INFO "Remember to launch this script as sudo!"
#QUESTION=$(INFO "Are you sure to proced to reset MiniDLNA database? [Y/N] ")
QUEST=$(echo -e "This is your last chance. After this, there is no turning back.\nYou take the blue pill: the story ends, you wake up in your bed and believe whatever you want to believe. [B]\nYou take the red pill:  you stay in Wonderland, and I show you how deep the rabbit hole goes [R].\nRemember: all I'm offering is the truth. Nothing more.\nWhat is your choice? ")
read -p "$QUEST" -n 1 -r
echo # move to a new line

if [[ $REPLY =~ ^[Rr]$ ]]; then
    # Do dangerous stuff
    INFO "Red Pill, nice choice!"

    DEBUG "Delete cache MiniDLNA"
    rm -rf /mnt/dietpi_userdata/.MiniDLNA_Cache/*
    # need to trap previous command !!!!
    if [ ! $? -eq 0 ]; then
        FATAL "Can't delete cache MiniDLNA! Exiting..."
        exit 1
    fi

    DEBUG "Restart MiniDLNA"
    systemctl restart minidlna
    # need to trap previous command !!!!
    if [ ! $? -eq 0 ]; then
        FATAL "Can't restart MiniDLNA! Exiting..."
        exit 1
    fi
    INFO "Done!"
    exit 0
else
    INFO "Blue pill, bye bye!"
fi

IFS=$SAVEIFS

exit 0
