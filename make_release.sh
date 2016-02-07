#!/bin/bash

# Get PV
PV=async-emerge-`cat version.txt`
PF=async-emerge-`cat version.txt; cat revision.txt`

#cd async-emerge

# Make source tarball
mkdir -p src/${PV}
cp -pRf trunk/{bin,etc,src} src/${PV}
#cp -pR src/current/{bin,etc}/[^.]* src/${PV}
rm -rf src/${PV}/.svn src/${PV}/*/.svn
cd src
tar -cjvf ../distfiles/${PV}.tar.bz2 ${PV}
cd ..
#sudo cp distfiles/* /usr/portage/distfiles/

## add distfile to SVN
#svn add distfiles/${PV}.tar.bz2

# add distfile to Git
git add distfiles/${PV}.tar.bz2

# Copy current ebuild to versioned
cp -p async-emerge.ebuild overlay/app-portage/async-emerge/${PF}.ebuild
cp -p async-emerge.ebuild overlay/app-portage/async-emerge/async-emerge-9999.ebuild

DISTDIR=distfiles/ ebuild --force overlay/app-portage/async-emerge/${PF}.ebuild manifest
DISTDIR=distfiles/ ebuild --force overlay/app-portage/async-emerge/async-emerge-9999.ebuild manifest
#DISTDIR=distfiles ebuild --force distfiles/* digest
#ebuild --force overlay/app-portage/async-emerge/*.ebuild manifest

## add ebuild to SVN
##cd overlay/app-portage/async-emerge/
#svn add overlay/app-portage/async-emerge/${PF}.ebuild
##cd ../../..

# add ebuild to Git
cd overlay/app-portage/async-emerge/
git add ${PF}.ebuild
cd ../../..
