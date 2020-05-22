#!/bin/bash

# Ver. 	1.0 Wed May 20 22:36:15 2020
#		- initial
#	1.1 Thu May 21 00:25:48 2020
#		- --update/--emptytree added
#	1.2 Thu May 21 11:55:06 2020
#		- toolchain update added
#	1.3 Thu May 21 12:24:54 2020
#		- system echo added
#	1.4 Fri 22 May 2020 07:45:02 AM MSK
#		- add log func


log() {
    echo
    echo
    echo " * "${1}" ..."
    echo "    ("$(date)")"
    echo
}

 log "Start of update the system"

 log "1/12. Update gcc"
time emerge --oneshot --nodeps "${@}" gcc
 log "2/12. Update binutils"
time emerge --oneshot --nodeps "${@}" binutils
 log "3/12. Update glibc"
time emerge --oneshot --nodeps "${@}" glibc
 log "4/12. Remove old versions of the toolchain"
time emerge --depclean --nodeps "${@}" gcc binutils glibc
 log "5/12. Update profile"
time source /etc/profile
 log "6/12. Rebuild system set (pass 1/3)"
time gentoo-old-update-set.sh system --emptytree "${@}"
 log "7/12. Rebuild system set (pass 2/3)"
time gentoo-old-update-set.sh system --emptytree "${@}"
 log "8/12. Rebuild system set (pass 3/3)"
time gentoo-old-update-set.sh system --emptytree "${@}"
 log "9/12. Rebuild world set (pass 1/3)"
time gentoo-old-update-set.sh world --emptytree "${@}"
 log "10/12. Rebuild world set (pass 2/3)"
time gentoo-old-update-set.sh world --emptytree "${@}"
 log "11/12. Rebuild world set (pass 3/3)"
time gentoo-old-update-set.sh world --emptytree "${@}"
 log "12/12. Rebuild world set with dependancies"
time emerge --emptytree "${@}" @world

 log "End of update the system"
