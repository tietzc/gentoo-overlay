# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info multilib rpm

DESCRIPTION="Generic Brother printer driver"
HOMEPAGE="http://support.brother.com"
SRC_URI="
	http://download.brother.com/welcome/dlf101124/brgenml1lpr-3.1.0-1.i386.rpm
	http://download.brother.com/welcome/dlf101126/brgenml1cupswrapper-3.1.0-1.i386.rpm"

LICENSE="brother-eula"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="net-print/cups"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

pkg_setup() {
	CONFIG_CHECK=""
	if use amd64 ; then
		CONFIG_CHECK="${CONFIG_CHECK} ~IA32_EMULATION"
		if ! has_multilib_profile ; then
			die "This package CANNOT be installed on pure 64-bit systems. You need multilib enabled."
		fi
	fi

	linux-info_pkg_setup
}

src_unpack() {
	rpm_unpack ${A}
}

src_prepare() {
	eapply "${FILESDIR}/brother_lpdwrapper_BrGenML1.patch"
	default
}

src_install() {
	cp -r var "${D}" || die
	cp -r opt "${D}" || die
	cp -r etc "${D}" || die

	mkdir -p "${D}/usr/libexec/cups/filter" || die
	( cd "${D}/usr/libexec/cups/filter/" && ln -s ../../../../opt/brother/Printers/BrGenML1/cupswrapper/brother_lpdwrapper_BrGenML1 ) || die

	mkdir -p "${D}/usr/share/cups/model" || die
	( cd "${D}/usr/share/cups/model" && ln -s ../../../../opt/brother/Printers/BrGenML1/cupswrapper/brother-BrGenML1-cups-en.ppd ) || die
}
