# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

DESCRIPTION="A new Thunderbird address book based on the CardDAV and vCard standards"
HOMEPAGE="https://addons.mozilla.org/en-US/thunderbird/addon/cardbook"
SRC_URI="https://addons.mozilla.org/thunderbird/downloads/file/864027/${P}-tb.xpi"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="mail-client/thunderbird[lightning]"

DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local MOZILLA_FIVE_HOME="/usr/$(get_libdir)/thunderbird"
	local emid="$(sed -n '/\<\(em:\)*id\>/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q' install.rdf || die)"

	insinto "${MOZILLA_FIVE_HOME}/extensions/${emid}"
	doins -r .
}
