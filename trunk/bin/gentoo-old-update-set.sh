#!/bin/bash

# Ver. 	1.0 Wed May 20 21:19:21 2020
#		- initial
#	1.1 Wed May 20 21:40:08 2020
#		- up to 3 user params to emerge added
#		- default -ask removed
#	1.2 Thu May 21 00:20:33 2020
#		- remove interactive editing the list
#		- remove --emptytree

TMP_FILE="/tmp/${1}.txt"

emerge --pretend "${2}" --quiet --columns --color\=n "${1}" | sed -e '/^$/,$d' | sed -r '/^.{,9}$/d' | awk -F ' ' '{print $2}' > "${TMP_FILE}" && \
emerge --verbose --oneshot --nodeps --keep-going "${@:3}" $(cat "${TMP_FILE}")


