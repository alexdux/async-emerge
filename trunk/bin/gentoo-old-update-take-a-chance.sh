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

 echo " * 1/12. Update gcc ..." && \
emerge --oneshot --nodeps "${@}" gcc && \
 echo " * 2/12. Update binutils ..." && \
emerge --oneshot --nodeps "${@}" binutils && \
 echo " * 3/12. Update glibc ..." && \
emerge --oneshot --nodeps "${@}" glibc && \
 echo " * 4/12. Remove old versions of the toolchain ..." && \
emerge --depclean --nodeps "${@}" gcc binutils glibc && \
 echo " * 5/12. Update profile ..." && \
source /etc/profile && \
 echo " * 6/12. Rebuild system set (pass 1/3) ..." && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
 echo " * 7/12. Rebuild system set (pass 2/3) ..." && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
 echo " * 8/12. Rebuild system set (pass 3/3) ..." && \
gentoo-old-update-set.sh system --emptytree "${@}" && \
 echo " * 9/12. Rebuild world set (pass 1/3) ..." && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
 echo " * 10/12. Rebuild world set (pass 2/3) ..." && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
 echo " * 11/12. Rebuild world set (pass 3/3) ..." && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
 echo " * 12/12. Rebuild world set with dependancies ..." && \
emerge --emptytree "${@}" @world
