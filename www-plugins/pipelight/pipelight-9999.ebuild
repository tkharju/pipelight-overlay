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

DEPEND="app-emulation/wine-compholio[X,abi_x86_32]"
RDEPEND="${DEPEND}
	gnome-extra/zenity
	x11-apps/mesa-progs"

# Supported plugins
STANDARD_PLUGINS=("silverlight5.1" "silverlight5.0" "silverlight4" "flash" "unity3d" "widevine")
ADDITIONAL_PLUGINS=("shockwave" "foxitpdf" "grandstream" "adobereader" "hikvision" "npactivex" "roblox")
ALL_PLUGINS=("${STANDARD_PLUGINS[@]}" "${ADDITIONAL_PLUGINS[@]}")

src_prepare() {
	sed -i \
		-e "s:lib/:$(get_libdir)/:g" \
		-e "s:^\(prefix=\)\(.*\):\1${EPREFIX}/usr:" \
		-e "s:^\(win32cxx=\)\(.*\):\1${EPREFIX}/opt/wine-compholio/bin/wineg++:" \
		-e "s:^\(win32flags=\)\(.*\):\1-m32 -malign-double -Wl,-rpath=${EPREFIX}/opt/wine-compholio/lib32:" \
		./Makefile

}

src_configure() {
	:
}

src_compile() {
	emake WINEBUILD=${EPREFIX}/opt/wine-compholio/bin/winebuild
}

src_install() {
	default_src_install

	dodir /usr/share/wine-browser-installer
	exeinto /usr/share/wine-browser-installer
	doexe "${FILESDIR}/install-dependency"
	doexe "${FILESDIR}/hw-accel-default"
	doexe "${FILESDIR}/gizmos"

	install -m 755 -t "${ED}/usr/lib64/pipelight" "${ED}/usr/$(get_libdir)/pipelight/libpipelight.so"
	for i in "${ALL_PLUGINS[@]}"
	do
		#ln -s libpipelight.so "${ED}/usr/$(get_libdir)/pipelight/libpipelight-${i}.so"
		cp "${ED}/usr/$(get_libdir)/pipelight/libpipelight.so" "${ED}/usr/$(get_libdir)/pipelight/libpipelight-${i}.so"
	done

}
