#!/bin/bash


copy_pkg() {
    echo "=== $1"
    pkg="$(eix -e --format '<bestversion:NAMEVERSION>' --pure-packages $1)"
    if [[ "${pkg}" != "" ]]; then
	pcat=$(eix -e --format '<category>' --pure-packages $1)
	catpkg=$(eix -e --format '<category>/<name>' --pure-packages $1)
	pkg=${pkg##*\/}
	echo "  available: ${pkg}, coping..."

	mkdir -pv ../${catpkg}
	cp -rpv /usr/portage/${catpkg}/{${pkg}.ebuild,files,metadata.xml,ChangeLog} ../${catpkg}/

	ebuild ../${catpkg}/${pkg}.ebuild manifest

	for dist in $(grep DIST ../${catpkg}/Manifest | cut -d ' ' -f2); do
	    cp -pv /usr/portage/distfiles/${dist} ../../distfiles/
	done

	echo ${pcat} >> ../profiles/categories
    else
	echo "  not available! skipping!"
    fi
}


for pkg in $(grep -v "^#" ../profiles/package.mask/gnome3 | eix '-|*' --format '<category>/<name>\n'); do
    copy_pkg ${pkg}
done

cp -v ../profiles/categories ../profiles/categories.tmp
cat ../profiles/categories.tmp | sort -u > ../profiles/categories
rm -v ../profiles/categories.tmp

