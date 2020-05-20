#!/bin/bash

# Ver. 	1.0 Wed May 20 21:19:21 2020
#		- initial
#	1.1 Wed May 20 21:40:08 2020
#		- up to 3 user params to emerge added
#		- default -ask removed

EDITOR="mcedit"
TMP_FILE="/tmp/${1}.txt"

emerge --pretend --emptytree --quiet --columns --color\=n "${1}" | awk -F ' ' '{print $2}' > "${TMP_FILE}" && \
${EDITOR} "${TMP_FILE}" && \
emerge --verbose --oneshot --nodeps --keep-going "${@:2}" $(cat "${TMP_FILE}")


