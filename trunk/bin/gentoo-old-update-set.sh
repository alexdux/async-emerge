#!/bin/bash

# Ver. 	1.0 Wed May 20 21:19:21 2020
#		- initial
#	1.1 Wed May 20 21:40:08 2020
#		- up to 3 user params to emerge added
#		- default -ask removed
#	1.2 Thu May 21 00:20:33 2020
#		- remove interactive editing the list
#		- remove --emptytree
#	1.3 Thu May 21 12:08:47 2020
#		- remove --verbose
#	1.4 Thu May 21 12:14:33 2020
#		- echo added
#		- COLLISION_IGNORE added
#	1.5 Sat May 23 14:23:54 2020
#		- tmp_file moved from /tmp/ to /var/tmp/portage

TMP_FILE="/var/tmp/portage/${1}.txt"

echo "<<< (1/2) Request packets ordered list from portage for set \"${1}\". Please wait ... >>>"
emerge --pretend "${2}" --quiet --columns --color\=n "${1}" | sed -e '/^$/,$d' | cut -c8- | cut -d' ' -f1 > "${TMP_FILE}"
echo "<<< (2/2) Update the list without dependencies checking. It takes a while ...      >>>"
echo "<<<       Please use <Ctrl>+<C> several times to stop;                             >>>"
echo "<<<       --verbose/--queit for control output details;                            >>>"
echo "<<<       and \"nonup ... &\" and \"tail -f nohup.out\" to run in background.          >>>"
COLLISION_IGNORE="*" emerge --oneshot --nodeps --keep-going "${@:3}" $(cat "${TMP_FILE}")


