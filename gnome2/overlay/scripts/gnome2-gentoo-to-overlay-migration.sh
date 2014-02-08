#!/bin/sh

# World file
WRLD=/var/lib/portage/world

# Make backup of the world file
cp -pv ${WRLD} "${WRLD}.g2ovlbk.$(date +'%Y-%m-%d %X')"

# Get the list of masked [gnome3] packages
for pkg in $(grep -v "^#" ../profiles/package.mask/gnome3 | eix '-|*' --format '<category>/<name>\n'); do
    # for each atom try to add ::gnome2 rep, if the overlay for the atom is not given [before]
    sed -i "s|^${pkg}$|${pkg}::gnome2|" ${WRLD}
done

# echo ::gnome2 for your info
grep gnome2 ${WRLD}
