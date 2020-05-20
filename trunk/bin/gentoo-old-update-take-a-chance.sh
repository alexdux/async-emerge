#!/bin/bash

# Ver. 1.0 Wed May 20 22:36:15 2020
#		- initial
#	1.1 Thu May 21 00:25:48 2020
#		- --update/--emptytree added

# TODO: detect emerge exit code

gentoo-old-update-set.sh system --emptytree "${@}" && \
gentoo-old-update-set.sh system --update "${@}" && \
gentoo-old-update-set.sh system --update "${@}" && \
(eselect gcc set 2 || true) && \
(eselect binutils set 2 || true) && \
. /etc/profile && \
gentoo-old-update-set.sh world --emptytree "${@}" && \
gentoo-old-update-set.sh world --update "${@}" && \
gentoo-old-update-set.sh world --update "${@}" && \
emerge --emptytree "${@}" @world 
