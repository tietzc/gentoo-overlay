# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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

PATCHES=( "${FILESDIR}"/brother_lpdwrapper_BrGenML1.patch )

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

src_install() {
	cp -r etc "${D}" || die
	cp -r opt "${D}" || die
	cp -r var "${D}" || die

	dodir /usr/libexec/cups/filter
	dosym ../../../../opt/brother/Printers/BrGenML1/cupswrapper/brother_lpdwrapper_BrGenML1 \
		/usr/libexec/cups/filter/brother_lpdwrapper_BrGenML1

	dodir /usr/share/cups/model
	dosym ../../../../opt/brother/Printers/BrGenML1/cupswrapper/brother-BrGenML1-cups-en.ppd \
		/usr/share/cups/model/brother-BrGenML1-cups-en.ppd
}
