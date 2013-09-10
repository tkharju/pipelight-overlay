# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 multilib

DESCRIPTION="Wine-based wrapper for Windows Silverlight"
HOMEPAGE="https://launchpad.net/pipelight"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.org/mmueller2012/${PN}.git"

LICENSE="|| ( GPL-2+ LGPL-2.1+ MPL-1.1 )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-emulation/wine-compholio[abi_x86_32]
	cross-i686-w64-mingw32/gcc
	cross-i686-w64-mingw32/binutils
	cross-i686-w64-mingw32/mingw64-runtime"
RDEPEND="${DEPEND}
	gnome-extra/zenity"

src_prepare() {
	sed -i \
		-e "s:^\(PLUGIN_DIR=\)\(.*\):\1/usr/$(get_libdir)/mozilla/plugins:" \
		-e "s:^\(prefix=\)\(.*\):\1${EPREFIX}/usr:" \
		./Makefile

	sed -i \
		-e "s:^gccRuntimeDlls\(.*\)lib\(.*\):gccRuntimeDlls\1$(get_libdir)/gcc/i686-w64-mingw32/$(ls /usr/$(get_libdir)/gcc/i686-w64-mingw32):" \
		./share/pipelight
}

src_configure() {
	:
}

src_install() {
	default_src_install

	dodir /usr/share/wine-browser-installer
	exeinto /usr/share/wine-browser-installer
	doexe "${FILESDIR}/install-dependency"
	doexe "${FILESDIR}/hw-accel-default"
	doexe "${FILESDIR}/gizmos"
}
