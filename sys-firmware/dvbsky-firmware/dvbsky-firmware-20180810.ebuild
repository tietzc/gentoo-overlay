# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Firmware for DVBSky cards/boxes"
HOMEPAGE="http://www.dvbsky.net/Support_linux.html"
SRC_URI="http://www.dvbsky.net/download/linux/firmware.zip -> ${P}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /lib/firmware
	doins *.fw
}
