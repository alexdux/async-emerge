#!/bin/bash

# Ver. 1.0 Wed May 20 22:36:15 2020
#		- initial
#	1.1 Thu May 21 00:25:48 2020
#		- --update/--emptytree added
#	1.2 Thu May 21 11:55:06 2020
#		- toolchain update added

# TODO: detect emerge exit code

emerge --oneshot --nodeps gcc
emerge --oneshot --nodeps binutils
emerge --oneshot --nodeps glibc
emerge --depclean --nodeps gcc binutils glibc
. /etc/profile && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
emerge --emptytree "${@}" @world 
