# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/notification-daemon/notification-daemon-0.5.0.ebuild,v 1.13 2012/01/28 02:17:07 ssuominen Exp $

EAPI=4
GCONF_DEBUG=no
GNOME2_LA_PUNT=yes
GNOME_TARBALL_SUFFIX="bz2"

inherit eutils gnome2 flag-o-matic

DESCRIPTION="Notification daemon"
HOMEPAGE="http://git.gnome.org/browse/notification-daemon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=gnome-base/gconf-2.4:2
	>=dev-libs/dbus-glib-0.78
	>=sys-apps/dbus-1
	>=media-libs/libcanberra-0.4[gtk]
	x11-libs/libnotify
	x11-libs/libwnck:1
	x11-libs/libX11
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.4:2
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.14"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS"
	G2CONF="${G2CONF} --disable-static"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libnotify-0.7.patch
	gnome2_src_prepare
}

src_configure() {
        append-ldflags "-lgmodule-2.0"
        econf
}
