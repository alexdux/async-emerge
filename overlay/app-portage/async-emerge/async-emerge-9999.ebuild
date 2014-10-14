# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils linux-info

if [ "${PV}" == "9999" ]; then
    inherit subversion
    SRC_URI=""
    ESVN_REPO_URI="http://async-emerge.googlecode.com/svn/trunk/"
    KEYWORDS="~amd64 ~x86"
else
    SRC_URI="http://async-emerge.googlecode.com/svn/distfiles/${P}.tar.bz2"
    KEYWORDS="amd64 x86"
fi

HOMEPAGE="http://code.google.com/p/async-emerge/"
DESCRIPTION="Periodically sync portage and build binary packages for Gentoo updates."
LICENSE="GPL-2"
SLOT="0"

IUSE="aufs logrotate noemail notmpfs" # "eix layman"

# A space delimited list of portage features to restrict. man 5 ebuild for details.  Usually not needed.
#RESTRICT="strip"
RESTRICT="mirror"
#RESTRICT="fetch"

RDEPEND="app-portage/gentoolkit
			app-shells/bash
			app-portage/eix
			sys-process/lsof
			sys-apps/util-linux
			!noemail? ( net-mail/email )"
#DEPEND="${RDEPEND}"


src_configure() {
	AE_CONF="${S}/etc/async.emerge.conf"
	# check for AUFS, out the banner if needed to inform the user about dependencies
	if use aufs ; then
		if linux_config_exists && linux_chkconfig_present CONFIG_AUFS_FS ; then # check for built-in
			ewarn "Bltn ok"
			#;
		elif best_version 'sys-fs/aufs3'; then # check for standalone aufs3 module
			ewarn "Stnd alone ok"
			#;
		else
			echo
			eerror "AUFS functionality is enabled in the USE var,"
			eerror "but neither standalone \`aufs\` not kernel support for \`aufs\`"
			eerror "is not found. Please, to get AUFS working choose one of:"
			eerror "   - emerge \`sys-fs/aufs3\`"
			eerror "   - emerge \`sys-kernel/aufs-sources\` or another kernel witn AUFS support"
			eerror "   - or add AUFS support to the kernel by another way (e.g. patch it)!"
			eerror "Now stop."
			echo
			exit 1
		fi
	else
		echo
		einfo "\`Aufs\` USE flag in not set. Functionality of AE is limited."
		einfo "If you intend to build binaries in a chrooted environment,"
		einfo "you need to add USE flag \`aufs\` and install standalone aufs"
		einfo "package or a kernel with AUFS support."
		echo
	fi
	# to-do: add checking FEATURES & EMERGE_DEFAULT_OPTS
	# configure USE
	if use notmpfs ; then
		sed -i -e 's/\([[] \"$AE_NOTMPFS\" []]\)/#\1/' "${AE_CONF}" || \
			die "Can't adjust AE_NOTMPFS! Stop."
		sed -i -e 's/#\([[] \"$AE_USETMPFS\" []]\)/\1/' "${AE_CONF}" || \
			die "Can't adjust AE_USETMPFS! Stop."
	fi
	# portage version adjust
	P_VER=$(emerge --info | grep 'portage ' -i | cut -f2 -d'.')
	if ((P_VER>1)); then # new portage-2.2 +
		sed -i -e "s/^\(AE_REBUILD\[DO_OBSOLETED_LIBS\]='\)y/\1n/" "${AE_CONF}" || \
			die "Can't adjust AE_REBUILD[DO_OBSOLETED_LIBS]! Stop."
		sed -i -e "s/^\(AE_REBUILD\[DO_REVDEP_REBUILD\]='\)y/\1n/" "${AE_CONF}" || \
			die "Can't adjust AE_REBUILD[DO_REVDEP_REBUILD]! Stop."
		# $(qlist -I -C x11-drivers/) -> @x11-module-rebuild
#		sed -i -e "s/\$\(qlist -I -C x11-drivers\/\)/\@x11-module-rebuild/" "${AE_CONF}" || \
#			die "Can't adjust add_subset_update 'X server'! Stop."
	else # old portage-2.2 -
		sed -i -e "s/^\(AE_REBUILD\[DO_PRESERVED_REBUILD\]='\)y/\1n/" "${AE_CONF}" || \
			die "Can't adjust AE_REBUILD[DO_PRESERVED_REBUILD]! Stop."
	fi
	# get some portage vars
	grep -o '`portageq .*`' "${AE_CONF}" | cut -f2 -d'`' | \
		while read str_todo; do 
			sed -i -e "s@\`${str_todo}\`@`${str_todo}`@" "${AE_CONF}" || \
				die "Can't exec '${str_todo}'! Stop." # '
		done
	# disable ccache if not installed (not tested)
	[ "$CCACHE_DIR" ] || \
		sed -i -e "s/^\(AE_DIR\[TRANSPARENT\]+=\" $CCACHE_DIR\"\)/#\1/" "${AE_CONF}" || \
			die "Can't adjust AE_DIR[TRANSPARENT]! Stop."
}

src_install() {
	# bin
	dodir /usr/bin
	cp -R ${S}/bin/* ${D}/usr/bin/ || die
	# conf
	insinto /etc
	doins "${S}"/etc/* || die
	# log
	keepdir /var/log/async.emerge
	# logrotate config for AE
	#if has_version "app-admin/logrotate"; then
	if use logrotate ; then
		dodir /etc/logrotate.d/
		cp -R ${S}/etc/logrotate.d/* ${D}/etc/logrotate.d/ || die
		keepdir /var/log/async.emerge/archive
	fi
	
	# Extra Stuff
	# script to build new kernel 
	# usr/src
	dodir /usr/src
	cp -R ${S}/src/* ${D}/usr/src/ || die
}

