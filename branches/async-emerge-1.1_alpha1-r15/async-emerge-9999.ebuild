# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="Periodically sync portage and prebuild binary updates for Gentoo."
#DESCRIPTION="Asynchronous multiple binaries cooker for Gentoo"
HOMEPAGE="http://code.google.com/p/async-emerge/"

if [ "$PV" == "9999" ]; then
    inherit subversion
    SRC_URI=""
    ESVN_REPO_URI="http://async-emerge.googlecode.com/svn/trunk/"
    KEYWORDS=""
else
    SRC_URI="http://async-emerge.googlecode.com/svn/distfiles/${P}.tar.bz2"
    KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="" # "eix layman"

# A space delimited list of portage features to restrict. man 5 ebuild for details.  Usually not needed.
#RESTRICT="strip"
RESTRICT="mirror"
#RESTRICT="fetch"

RDEPEND="sys-fs/aufs2
app-portage/gentoolkit
app-shells/bash
app-portage/eix
sys-process/lsof"
#DEPEND="${RDEPEND}"


src_install() {
#	dobin "${S}"/bin/ae_[^v]* || die
#	for f in "${S}"/bin/; do
#	    if [ -x "$f" ]; do
#		dobin "$f" || die
#	    fi
#	done
	dodir /usr/bin
	cp -R ${S}/bin/* ${D}/usr/bin/ || die
	insinto /etc
	doins "${S}"/etc/* || die
	keepdir /var/log/async.emerge
}

