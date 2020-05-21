#!/bin/bash

# Ver. 1.0 Wed May 20 22:36:15 2020
#		- initial
#	1.1 Thu May 21 00:25:48 2020
#		- --update/--emptytree added
#	1.2 Thu May 21 11:55:06 2020
#		- toolchain update added
#	1.3 Thu May 21 12:24:54 2020
#		- system echo added

# TODO: detect emerge exit code

[ "$RC_GOT_FUNCTIONS" ] || . /etc/init.d/functions.sh

 einfo "1/12. Update gcc ..." && \
emerge --oneshot --nodeps "${@}" gcc && \
 einfo "2/12. Update binutils ..." && \
emerge --oneshot --nodeps "${@}" binutils && \
 einfo "3/12. Update glibc ..." && \
emerge --oneshot --nodeps "${@}" glibc && \
 einfo "4/12. Remove old version of the toolchains ..." && \
emerge --depclean --nodeps "${@}" gcc binutils glibc && \
 einfo "5/12. Update profile ..." && \
. /etc/profile && \
 einfo "6/12. Rebuild system set (pass 1/3) ..." && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
 einfo "7/12. Rebuild system set (pass 2/3) ..." && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
 einfo "8/12. Rebuild system set (pass 3/3) ..." && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
 einfo "9/12. Rebuild world set (pass 1/3) ..." && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
 einfo "10/12. Rebuild world set (pass 2/3) ..." && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
 einfo "11/12. Rebuild world set (pass 3/3) ..." && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
 einfo "12/12. Rebuild world set with dependancies ..." && \
emerge --emptytree "${@}" @world
