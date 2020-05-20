#!/bin/bash

# Ver. 1.0 Wed May 20 22:36:15 2020
#		- initial

gentoo-old-update-set.sh system "${@}" && \
(eselect gcc set 2 || true) && \
(eselect binutils set 2 || true) && \
. /etc/profile && \
gentoo-old-update-set.sh world "${@}" && \
emerge --emptytree "${@}" @world 
